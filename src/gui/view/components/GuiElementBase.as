package gui.view.components 
{
	import flash.display.Sprite;
	import flash.events.Event;
	/**
	 * ...
	 * @author Karlis Zemdega
	 */
	public class GuiElementBase extends Sprite
	{
		
		public function GuiElementBase() 
		{
			
		}
		
		protected function markDirty():void
		{
			addEventListener(Event.EXIT_FRAME, validate, false, int.MIN_VALUE);
			addEventListener(Event.EXIT_FRAME, removeValidateListeners, false, int.MIN_VALUE+1);
		}
		
		private function removeValidateListeners(e:Event):void 
		{
			removeEventListener(Event.EXIT_FRAME, removeValidateListeners, false, int.MIN_VALUE + 1);
			markClean();			
		}
		
		/**
		 * Override this in subclasses
		 * @param	...ignore
		 */
		protected function validate(...ignore):void 
		{throw new Error("validate() not implemented"); }
		
		protected function markClean():void
		{
			if (hasEventListener(Event.EXIT_FRAME))
				removeEventListener(Event.EXIT_FRAME, validate);
		}
		
	}

}