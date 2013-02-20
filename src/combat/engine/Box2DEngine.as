package combat.engine {
	import Box2D.Collision.b2AABB;
	import Box2D.Collision.Shapes.b2CircleShape;
	import Box2D.Collision.Shapes.b2EdgeShape;
	import Box2D.Collision.Shapes.b2PolygonShape;
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.b2BodyDef;
	import Box2D.Dynamics.b2DebugDraw;
	import Box2D.Dynamics.b2Fixture;
	import Box2D.Dynamics.b2FixtureDef;
	import Box2D.Dynamics.b2World;
	import Box2D.Dynamics.Contacts.b2Contact;
	import Box2D.Dynamics.Contacts.b2ContactEdge;
	import combat.data.AffectVO;
	import combat.engine.api.IEngine;
	import combat.engine.events.ContactEvent;
	import combat.engine.listeners.FighterContactListener;
	import combat.view.ICollidableObject;
	import flash.display.Graphics;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	/**
	 * ...
	 * @author Karlis Zemdega
	 */
	public class Box2DEngine implements IEngine {
		private var _stage:Stage;
		private var _pixelsToMeters:Number;
		private var world:b2World;
		private var tick:Number;
		private var dynamicBodies:Vector.<b2Body> = new Vector.<b2Body>();
		private var persistentEffects:Vector.<PersistentEffect> = new Vector.<PersistentEffect>();
		private var debugData:*;
		
		public function Box2DEngine() {
			
		}
		
		
		/* INTERFACE combat.engine.api.IEngine */
		
		public function setup(tick:Number, gravity:Number):void
		{
			this.tick = tick;
			
			var gravityVector:b2Vec2 = new b2Vec2(0, gravity);
			
			world = new b2World(gravityVector, true);
			
			_stage.addEventListener(Event.ENTER_FRAME, onEnterFrame);

			//world.add
		}
		
		private function onEnterFrame(e:Event):void
		{
			update();
		}
		
		private function update():void
		{
			applyPersistentEffects();
			
			world.Step(tick, 10, 10);
			world.ClearForces();
			
			var body:b2Body, sprite:Sprite;
			var userData:UserDataVO, centerPoint:Point;
			var contactList:b2ContactEdge, contact:b2Contact;
			for (body = world.GetBodyList(); body; body = body.GetNext())
			{
				userData = body.GetUserData();
				if (!userData) { continue; } // FIXME
				if (!userData.container) // move containers
				{
					// placement
					sprite = userData.sprite;
					sprite.x = body.GetPosition().x * _pixelsToMeters;
					sprite.y = body.GetPosition().y * _pixelsToMeters;
				}
				else // move parts
				{
					// placement
					centerPoint = userData.sprite.localToGlobal(new Point(userData.sprite.center.x, userData.sprite.center.y));
					body.SetPosition(new b2Vec2(centerPoint.x / _pixelsToMeters, centerPoint.y / _pixelsToMeters));
					body.SetAngle((userData.sprite.rotation - 180) * userData.sprite.parent.scaleX * (Math.PI / 180)); // in radians
				}
			}
			
			drawDebug();
		}
		
		private function drawDebug():void
		{
			var graphics:Graphics;
			if (!debugData)
			{
				graphics = _stage.getChildAt(0)["graphics"] as Graphics;
				debugData = graphics;
				var debugSprite:Sprite = new Sprite();
				Sprite(_stage.getChildAt(0)).addChild(debugSprite);
				var debugDraw:b2DebugDraw = new b2DebugDraw();
				debugDraw.SetSprite(debugSprite);
				debugDraw.SetDrawScale(_pixelsToMeters);
				debugDraw.SetLineThickness( 1.0);
				debugDraw.SetAlpha(1);
				debugDraw.SetFillAlpha(0.4);
				debugDraw.SetFlags(b2DebugDraw.e_shapeBit);
				world.SetDebugDraw(debugDraw);
			}
			else
				graphics = debugData;
			
			graphics.clear();
			world.DrawDebugData();
		}
		
		private function applyPersistentEffects():void
		{
			var body:b2Body;
			for each (var effect:PersistentEffect in persistentEffects)
			{
				body = effect.target;
				switch (effect.type)
				{
					case PersistentEffect.FORCE:
						body.ApplyForce(effect.vector, body.GetPosition());
						break;
				}
			}
		}
		
		private function getBodyBySprite(object:ICollidableObject):b2Body
		{
			var ret:b2Body;
			for each (var body:b2Body in dynamicBodies)
			{
				if (body.GetUserData().sprite == object)
				{
					ret = body;
					break;
				}
			}
			
			return ret;
		}
		
		public function addObjects(objects:Vector.<ICollidableObject>):void
		{
			var bodyDef:b2BodyDef, shape:b2PolygonShape, body:b2Body, fixture:b2FixtureDef, containerBody:b2Body;
			var centerPoint:Point = new Point();
			for each (var container:ICollidableObject in objects)
			{
				
				bodyDef = new b2BodyDef();
				bodyDef.position.Set	(
											container.x/_pixelsToMeters,
											container.y/_pixelsToMeters
										);

				bodyDef.type = b2Body.b2_dynamicBody;
				bodyDef.allowSleep = false;
				
				containerBody = world.CreateBody(bodyDef);
				containerBody.SetUserData(new UserDataVO(container as MovieClip));
				containerBody.SetFixedRotation(true);
				
				shape = new b2PolygonShape();
				shape.SetAsBox	(
									(container.width * .5)/_pixelsToMeters,
									(container.height * .5)/_pixelsToMeters
								);
				
				fixture = new b2FixtureDef();
				fixture.shape = shape;
				fixture.density = 1;
				fixture.friction = .3;
				//fixture.isSensor = true;
				
				containerBody.CreateFixture(fixture);
				
				dynamicBodies.push(containerBody);
				var contactListener:FighterContactListener = new FighterContactListener();
				contactListener.eventDispatcher.addEventListener(ContactEvent.FIGHTER_CONTACT, onFighterContact);
				world.SetContactListener(contactListener);
				
				for each (var o:MovieClip in container.getSubObjects()) // sub objects
				{
					if (o.center) // TODO: do the math, not center objects
						centerPoint = o.localToGlobal(new Point(o.center.x, o.center.y));
					else
						trace("[WARNING] Box2DEngine: " + o.name + " doesn't have a set center object");
						
					bodyDef = new b2BodyDef();
					bodyDef.position.Set	(
												(centerPoint.x)/_pixelsToMeters,
												(centerPoint.y)/_pixelsToMeters
											);

					bodyDef.type = b2Body.b2_dynamicBody;
					bodyDef.allowSleep = false;
					
					body = world.CreateBody(bodyDef);
					body.SetUserData(new UserDataVO(o, containerBody));
					//body.SetFixedRotation(true);
					
					shape = new b2PolygonShape();
					shape.SetAsBox	(
												(o.getChildAt(0).width * .5)/_pixelsToMeters,
												(o.getChildAt(0).height * .5) / _pixelsToMeters
											);
					body.SetAngle((o.rotation - 180) * (Math.PI / 180)); // in radians
					
					fixture = new b2FixtureDef();
					fixture.shape = shape;
					fixture.density = 1;
					fixture.friction = .3;
					fixture.isSensor = true;
					
					body.CreateFixture(fixture);
					
					dynamicBodies.push(body);
				}
			}
		}
		
		private function onFighterContact(e:ContactEvent):void 
		{
			var contact:b2Contact = e.contact;
			var fixtureA:b2Fixture = contact.GetFixtureA();
			var fixtureB:b2Fixture = contact.GetFixtureB();
			var containerA:b2Body = fixtureA.GetBody().GetUserData().container;
			var containerB:b2Body = fixtureB.GetBody().GetUserData().container;
			var userDataA:UserDataVO = containerA.GetUserData();
			var userDataB:UserDataVO = containerB.GetUserData();
			
			//trace("fighter contact", userDataA.sprite.name, userDataB.sprite.name);
			
			var partAPosition:b2Vec2 = fixtureA.GetBody().GetPosition();
			var partBPosition:b2Vec2 = fixtureB.GetBody().GetPosition();
			
			
			// check for carried force
			if (userDataA.carriedForce || userDataB.carriedForce) // TODO: check if this is done twice every update
			{
				var facingMultiplierA:int = userDataA.sprite.getChildAt(0).scaleX;
				var facingMultiplierB:int = userDataB.sprite.getChildAt(0).scaleX;
				//var directionMultiplier:int = partAPosition.x < partBPosition.x ? 1 : -1; // simple relative direction determining
				
				if (userDataA.carriedForce)
					containerB.ApplyForce(new b2Vec2(userDataA.carriedForce.x * facingMultiplierA, userDataA.carriedForce.y), containerB.GetPosition());
				else
					containerA.ApplyForce(new b2Vec2(userDataB.carriedForce.x * facingMultiplierB, userDataB.carriedForce.y), containerA.GetPosition());					
			}
		}
		
		public function addStaticObjects(gameStage:ICollidableObject):void
		{
			var bodyDef:b2BodyDef, shape:b2PolygonShape, body:b2Body, fixture:b2FixtureDef;
			for each (var o:MovieClip in gameStage.getSubObjects())
			{
				bodyDef = new b2BodyDef();
				bodyDef.position = new b2Vec2	(
													o.x/_pixelsToMeters,
													o.y/_pixelsToMeters
												);
				bodyDef.type = b2Body.b2_staticBody;
				body = world.CreateBody(bodyDef);
				body.SetUserData(new UserDataVO(o));
				
				shape = new b2PolygonShape();
				shape.SetAsBox	(
									(o.width * .5)/_pixelsToMeters,
									(o.height * .5)/_pixelsToMeters
								);
				
				fixture = new b2FixtureDef();
				fixture.shape = shape;
				//fixture.density = 9;
				//fixture.friction = 1;
				fixture.restitution = 0;
				
				body.CreateFixture(fixture);
			}
		}
		
		/* INTERFACE combat.engine.api.IEngine */
		
		public function affectWorld(affectVO:AffectVO):void
		{
			var body:b2Body = getBodyBySprite(affectVO.object);
			if (affectVO.force)
				body.ApplyForce(new b2Vec2(affectVO.force.x, affectVO.force.y), body.GetPosition());
				
			if (affectVO.persistentForce)
				addPersistentEffect(
					new PersistentEffect(
											PersistentEffect.FORCE,
											new b2Vec2(affectVO.persistentForce.x, affectVO.persistentForce.y),
											body
										)
									);
									
			if (affectVO.carriedForce)
				(body.GetUserData() as UserDataVO).carriedForce = affectVO.carriedForce;
		}
		
		private function addPersistentEffect(newEffect:PersistentEffect):void
		{
			// check if body already has persistent effect
			var effect:PersistentEffect, l:uint = persistentEffects.length;
			for (var i:uint = 0; i < l; i++ )
			{
				effect = persistentEffects[i];
				if (effect.target === newEffect.target)
				{
					// modify existing effect if yes
					effect.vector.Add(newEffect.vector);
					
					// if resulting vector is null, remove effect
					if (effect.vector.x === 0 && effect.vector.y === 0)
						persistentEffects.splice(i, 1);
						
					return; // done
				}
			}
			
			// add new effect if not
			persistentEffects.push(newEffect);
		}
		
		public function get stage():Stage
		{
			return _stage;
		}
		
		public function set stage(value:Stage):void
		{
			_stage = value;
		}
		
		public function get pixelsToMeters():Number
		{
			return _pixelsToMeters;
		}
		
		public function set pixelsToMeters(value:Number):void
		{
			_pixelsToMeters = value;
		}
		
	}

}
import Box2D.Common.Math.b2Vec2;
import Box2D.Dynamics.b2Body;
import flash.display.MovieClip;
import flash.display.Sprite;
import flash.geom.Point;

class PersistentEffect {
	public static const FORCE:String = "force";
	
	public var type:String;
	public var vector:b2Vec2;
	public var target:b2Body;
	public function PersistentEffect(type:String, vector:b2Vec2, target:b2Body)
	{
		this.type = type;
		this.vector = vector;
		this.target = target;
		
	}
}

class UserDataVO
{
	public var carriedForce:Point;
	public var sprite:MovieClip;
	public var container:b2Body;
	
	public function UserDataVO(sprite:MovieClip, container:b2Body = null, carriedForce:Point = null)
	{
		this.carriedForce = carriedForce;
		this.sprite = sprite;
		this.container = container;
		
	}
}