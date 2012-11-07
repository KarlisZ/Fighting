package combat.data {
	/**
	 * ...
	 * @author Karlis Zemdega
	 */
	public class ControlMap {
		public var moveJump:Control;
		public var moveLeft:Control;
		public var moveRight:Control;
		public var moveDuck:Control;
		public var blockUp:Control;
		public var blockDown:Control;
		public var attackHigh:Control;
		public var attackMid:Control;
		public var attackLow:Control;
		public var specialAttacks:Vector.<Control> = new Vector.<Control>();
		
		public var allControls:Vector.<Control> = new Vector.<Control>();
		
		
		public function ControlMap(data:XML = null) {
			if (data) parseXML(data);
		}
		
		public function parseXML(data:XML):void {
			var varName:String, newControl:Control;
			for each (var item:XML in data.control) {
				newControl = new Control(item.@type, item.@id, Number(item.@keyCode), Number(item.@modifier));
				allControls.push(newControl);
				
				if (newControl.id.split("_")[0] == "special") {
					specialAttacks.push(newControl);
					
				} else {
					varName = item.@type + item.@id.substr(0, 1).toUpperCase() + item.@id.substring(1);
					try {
						this[varName] = newControl;
					} catch (e:Error) {
						trace(e.getStackTrace());
						continue;
					}
				}
			}
		}
		
		public function getControl(keyCodeValue:uint, ctrlKeyValue:Boolean = false, altKeyValue:Boolean = false, shiftKeyValue:Boolean = false, controlKeyValue:Boolean = false, commandKeyValue:Boolean = false):Control {
			var ret:Control;
			for each (var control:Control in allControls) {
				if (keyCodeValue == control.key || keyCodeValue == control.modifier) {
					ret = control;
					break;
				}
			}
			
			return ret;
		}
		
	}

}