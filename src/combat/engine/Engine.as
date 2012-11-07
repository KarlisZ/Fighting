package combat.engine {
	import com.coreyoneil.collision.CollisionGroup;
	import com.coreyoneil.collision.CollisionList;
	import combat.constant.CollidingObjectType;
	import combat.data.Collision;
	import combat.engine.api.IEngine;
	import combat.view.base.CollidibleObject;
	import combat.view.ICollidableObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.Timer;
	/**
	 * ...
	 * @author Karlis Zemdega
	 */
	public class Engine implements IEngine {
		private var running:Boolean;
		private var timer:Timer;
		private var gravity:Number;
		private var staticObjects:Array;
		private var dynamicObjects:Array;
		
		public function Engine() {
			init();
		}
		
		private function init():void {
			staticObjects = [];
			dynamicObjects = [];
		}
		
		public function setup(timerTick:uint, gravity:Number):void {
			timer = new Timer(timerTick);
			this.gravity = gravity;
		}
		
		public function start():void {
			collisionGroup = new CollisionGroup();
			collisionGroup.returnAngle = true;
			dynamicObjects.concat(staticObjects).forEach(function(item:CollidibleObject, ...ignore):void { collisionGroup.addItem(item) } ); // add items
			
			timer.addEventListener(TimerEvent.TIMER, tickHandler);
			timer.start();
			running = true;
		}
		
		private function tickHandler(e:TimerEvent):void {
			update();
		}
		
		private function update():void {
			var collisions:Vector.<Collision> = getCollisions();
			var obstructionSide:String;
			var mainA:CollidibleObject, mainB:CollidibleObject, subA:MovieClip, subB:MovieClip;
			for each (var collision:Object in collisions) {
				mainA = collision.object1;
				mainB = collision.object2;
				
				
				
				// reset position
				/*var angle:Number = collision.angle;
				var overlap:int = collision.overlapping.length;
				
				var sin:Number = Math.sin(angle);
				var cos:Number = Math.cos(angle);
					
				var vx0:Number = mainA.vector.x * cos + mainA.vector.y * sin;
				var vy0:Number = mainA.vector.y * cos - mainA.vector.x * sin;
				// Otherwise, vx0 would have been further calculated using both objects' masses and velocities, like so:
				// var vx1:Number = object2.vx * cos + object2.vy * sin;
				// vx0 = ((ball.mass - object2.mass) * vx0 + 2 * object2.mass * vx1) / (ball.mass + object2.mass);
				mainA.vector.x = vx0 * cos - vy0 * sin;
				mainA.vector.y = vy0 * cos + vx0 * sin;
				
				
				mainA.vector.x -= cos * overlap / 10;
				mainA.vector.y -= sin * overlap / 10;
				
				mainA.vector.x *= .3;
				mainA.vector.y *= .3;
				*/
			}
			
			// world affects dynamic objects
			var i:uint, l:uint = dynamicObjects.length, item:CollidibleObject;
			for (i = 0; i < l; i++) {
				item = dynamicObjects[i];
				
				// gravity
				item.vector.y += 1;//+= gravity * (timer.delay / 1000);
				
				// friction
				item.vector.x *= .9;
				item.vector.y *= .9;
				
				// adjust position
				item.x += item.vector.x;
				item.y += item.vector.y;
			}
			
		}
		
		private function getCollisions():Vector.<Collision> {
			var collisions:Vector.<Collision> = new Vector.<Collision>();
			var objects:Vector.<CollidibleObject> = dynamicObjects.concat(staticObjects);
			
			var i:uint, ii:uint, j:uint, jj:uint, l:uint, newCollision:Collision, axis:String,
				globalA:Point, globalB:Point,
				lenA:uint, lenB:uint, itemA:CollidibleObject, itemB:CollidibleObject,
				subA:MovieClip, subB:MovieClip, subsA:Vector.<MovieClip>, subsB:Vector.<MovieClip>;
				
			for (i = 0, l = objects.length; i < l; i++) { // match items by pairs
				for (ii = i+1; ii < l; ii++) { // i+1 skips already checked pairs
					itemA = objects[i];
					itemB = objects[ii];
					
					subsA = itemA.getSubObjects();
					subsB = itemB.getSubObjects();
					
					for (j = 0, lenA = subsA.length; j < lenA; j++) {
						for (jj = 0, lenB = subsB.length; jj < lenB; jj++) {
							subA = subsA[j];
							subB = subsB[jj];
							
							if (subA.hitTestObject(subB)) {
								// get axis
								globalA = subA.localToGlobal(new Point(subA.x, subA.y));
								globalB = subB.localToGlobal(new Point(subB.x, subB.y));
								
								/*if(globalA.x > )
								axis =
								newCollision = new Collision(itemA, itemB, subA, subB, axis);
								collisions.push(newCollision);*/
							}
						}
					}
				}
			}
			
			return collisions;
		}
		
		private function stop():void {
			timer.stop();
			timer.reset();
			timer.removeEventListener(TimerEvent.TIMER, tickHandler);
			running = false;
		}
		
		public function addObjects(objects:Vector.<MovieClip>):void {
			for each (var o:MovieClip in objects) {
				switch (o.type) {
					
					case "static":
						staticObjects.push(o);
						break;
						
					case "dynamic":
						dynamicObjects.push(o);
						break;
						
					default:
						trace("[ENGINE] Warning: Unexpected object type encountered when adding objects. Type: " + o.type, o);
				}
			}
			
			if (!running) start();
		}
		
		public function removeObject(object:ICollidableObject):void {
			
		}
	}

}