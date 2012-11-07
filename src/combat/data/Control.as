package combat.data {
	/**
	 * ...
	 * @author Karlis Zemdega
	 */
	public class Control {
		
		public var key:uint;
		public var modifier:uint;
		public var id:String;
		public var type:String;
		
		public function Control(type:String, id:String, key:uint, modifier:uint) {
			this.type = type;
			this.id = id;
			this.key = key;
			this.modifier = modifier;
		}
		
	}

}