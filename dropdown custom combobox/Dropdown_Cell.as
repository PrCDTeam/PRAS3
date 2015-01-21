package {
	import flash.display.Sprite;
	import flash.events.MouseEvent;

	public class Dropdown_Cell extends Sprite {
		public static var textActiveColor:uint = 0xFFFFFF;
		public static var textDefaultColor:uint = 0x000000;
		public static var startY:Number = 1000;
		public static var endY:Number = 0;
		public var label:String;
		public var value:String;

		public function Dropdown_Cell(_label:String=null, _value:String=null) {
			if (_label) {
				//trace(">>", _label)
				name = label = _label;
				tf.text = _label;
				tf.textColor = textDefaultColor;
				if (_value) {
					value = _value;
				} else {
					value = _label;
				}
			} else {
				if (y < startY) startY = y;
				if (y + height > endY) endY = y + height;
			//	trace("--", name, y, startY, endY);
				if (this is Dropdown_Cell_Active) {
					textActiveColor = tf.textColor;
				} else {
					textDefaultColor = tf.textColor;
				}
			}
			addEventListener(MouseEvent.MOUSE_OVER, handleMouse);
			addEventListener(MouseEvent.MOUSE_OUT, handleMouse);
		}
		function handleMouse(e:MouseEvent):void {
			if (e.type == MouseEvent.MOUSE_OVER) {
				cell_background_active.visible = true;
				cell_background_default.visible = false;
				tf.textColor = textActiveColor;
			} else {
				cell_background_active.visible = false;
				cell_background_default.visible = true;
				tf.textColor = textDefaultColor;
			}
		}
	}
}