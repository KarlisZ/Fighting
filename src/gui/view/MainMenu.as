package gui.view 
{
	import com.bit101.components.PushButton;
	import com.sigfa.logger.api.ILogger;
	import com.sigfa.logger.Logger;
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import gui.event.MenuEvent;
	/**
	 * ...
	 * @author Karlis Zemdega
	 */
	public class MainMenu extends Sprite
	{
		static public const TITLE_TEXT:String = "Peer Pressure";
		
		private const logger:ILogger = Logger.getLogger(MainMenu);
		private var menuButtons:Vector.<PushButton>;
		private var title:TextField;
		
		public function MainMenu() 
		{
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		private function onAddedToStage(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			build();
		}
		
		private function build():void 
		{
			title = createTitle();
			title.x = (stage.stageWidth - title.width) * .5;
			title.y = 50;
			addChild(title);
			menuButtons = new Vector.<PushButton>();
			
			menuButtons.push(createTestStageButton());
			menuButtons.push(createQuickMatchButton());
			menuButtons.push(createJoinLobbyButton());
			menuButtons.push(createOptionsButton());
			menuButtons.push(createFullScreenButton());
			
			// add buttons
			const menuPos:Point = new Point(stage.stageWidth - 300, 200);
			const buttonSpacing:Number = 10;
			var button:PushButton, itemHeight:Number;
			for (var i:int = 0; i < menuButtons.length; i++)
			{
				button = menuButtons[i];
				itemHeight ||= button.height;
				button.x = menuPos.x;
				button.y = menuPos.y + itemHeight * i + buttonSpacing * i;
				addChild(button);
			}
			
		}
		
		private function createTitle():TextField 
		{
			const newTitle:TextField = new TextField();
			const fmt:TextFormat = new TextFormat('_sans', 80, 0x999999);
			newTitle.width = 600;
			newTitle.height = 100;
			newTitle.selectable = false;
			newTitle.text = TITLE_TEXT;
			newTitle.setTextFormat(fmt);
			return newTitle;
		}
		
		private function createFullScreenButton():PushButton 
		{
			const width:Number = 30;
			const height:Number = 30;
			const button:PushButton = new PushButton();
			button.addEventListener(MouseEvent.CLICK, onFullScreenClick);
			button.width = width;
			button.height = height;
			const graphic:Sprite = createFullScreenGraphic();
			graphic.x = (width - graphic.width) * .5;
			graphic.y = (height - graphic.height) * .5;
			button.addChild(graphic);
			return button;
		}
		
		private function createFullScreenGraphic():Sprite
		{
			// |- -|
			// |_ _|
			
			const width:Number = 16;
			const height:Number = 16;
			const space:Number = 4;
			const sprite:Sprite = new Sprite();
			const g:Graphics = sprite.graphics;
			g.lineStyle(1, 0x00);
			g.lineTo((width - space) * .5, 0);		// -.
			g.moveTo((width + space) * .5, 0);		// - .
			g.lineTo(width, 0);						// - -.
			g.lineTo(width, (height - space) * .5);	// - -|.
			g.moveTo(width, (height + space) * .5);	//    .
			g.lineTo(width, height);				//    |.
			g.lineTo((width + space) * .5, height);	//   ._
			g.moveTo((width - space) * .5, height);	//  . _
			g.lineTo(0, height);					// ._ _
			g.lineTo(0, (height + space) * .5);		// |'
			g.moveTo(0, (height - space) * .5);		//  '			
			g.lineTo(0, 0);							// |'
			return sprite;
		}
		
		private function onFullScreenClick(e:MouseEvent):void 
		{
			
		}
		
		private function createOptionsButton():PushButton 
		{
			const button:PushButton = createMenuButton('Options');
			button.addEventListener(MouseEvent.CLICK, onOptionsClick);
			return button;
		}
		
		private function onOptionsClick(e:MouseEvent):void 
		{
			
		}
		
		private function createJoinLobbyButton():PushButton 
		{
			const button:PushButton = createMenuButton('Join A Lobby');
			button.addEventListener(MouseEvent.CLICK, onJoinLobbyClick);
			return button;
		}
		
		private function onJoinLobbyClick(e:MouseEvent):void 
		{
			
		}
		
		private function createQuickMatchButton():PushButton 
		{
			const button:PushButton = createMenuButton('Quick Match');
			button.addEventListener(MouseEvent.CLICK, onQuickMatchClick);
			return button;
		}
		
		private function onQuickMatchClick(e:MouseEvent):void 
		{
			
		}
		
		private function createTestStageButton():PushButton 
		{
			const button:PushButton = createMenuButton('Test Stage');
			button.addEventListener(MouseEvent.CLICK, onTestStageClick);
			return button;
		}
		
		private function onTestStageClick(e:MouseEvent):void 
		{
			logger.log("Test stage clicked");
			dispatchEvent(new MenuEvent(MenuEvent.CREATE_TEST_COMBAT_STAGE));
			visible = false;
		}
		
		private function createMenuButton(label:String):PushButton 
		{
			const button:PushButton = new PushButton();
			button.label = label;
			button.width = 100;
			button.height = 20;
			return button;
		}
		
		
	}

}