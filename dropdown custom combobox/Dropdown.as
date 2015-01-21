package {	
	import flash.display.Sprite;	
	import flash.events.MouseEvent;
	import flash.events.Event;
	import flash.utils.setTimeout;
	
	public class Dropdown extends Sprite {
		public static const DROPDOWN_SELECTED:String = "dropdownSelected";
		private var cellContainer:Sprite = new Sprite();
		private var scrolling:Boolean = false;
		private var cellAreaHeight:Number;
		private var _mask:Dropdown_Cell_Backdrop;
		private var doubleclicking:Boolean;
		public var _index:uint;
		public var _label:String;
		public var _value:String;
		
		public function Dropdown() {
			dropdown_Cell_Backdrop.visible = false;
			dropdown_Cell_Backdrop.addChild(cellContainer);
			arrowUp.visible = arrowDown.visible = false;
		}
		public function initDropdown(dropdownData:Array):void {
		//	trace("initDropdown");
			
			var maxCells:uint = 0;
			for (var d:uint=0; d<numChildren; d++) {
				if (getChildAt(d) is Dropdown_Cell) {
					removeChild(getChildAt(d));
					d--;
					maxCells++;
				}
			}
			
			dropdown_Cell_Backdrop.getChildAt(0).height = Dropdown_Cell.endY - dropdown_Cell_Backdrop.y;
			if (dropdownData.length > maxCells) {
				_mask = new Dropdown_Cell_Backdrop();
				dropdown_Cell_Backdrop.addChild(_mask);
				cellContainer.mask = _mask;
				scrolling = true;
			}
			
			for (var i:Number = 0; i<dropdownData.length; i++) {
				trace(i, dropdownData[i].label, "("+dropdownData[i].value+")");
				var cell:Dropdown_Cell = new Dropdown_Cell(dropdownData[i].label, dropdownData[i].value);
					cell.y = Dropdown_Cell.startY - dropdown_Cell_Backdrop.y + cell.height*i;
					cell.addEventListener(MouseEvent.MOUSE_UP, select);
				cellContainer.addChild(cell);
			}
			cellAreaHeight = Dropdown_Cell.endY - Dropdown_Cell.startY;
			
			addEventListener(MouseEvent.MOUSE_DOWN, openDropdown);
		}
		public function set index(i:uint):void {
			select(i);
		}
		public function get index():uint {
			return _index;
		}
		public function set value(s:String):void {
			select(s);
		}
		public function get value():String {
			return _value;
		}
		public function set label(s:String):void {
			select(s);
		}
		public function get label():String {
			return _label;
		}
		public function openDropdown(e:MouseEvent=null):void {
		//	trace("openDropdown");
			dropdown_Cell_Backdrop.visible = true;
			addEventListener(MouseEvent.ROLL_OUT, closeDropdown);
			removeEventListener(MouseEvent.MOUSE_DOWN, openDropdown);
			
			doubleclicking = true;
			setTimeout(handleClickDelay, 100);
			
			if (scrolling) addEventListener(Event.ENTER_FRAME, doScrolling);
		}
		private function handleClickDelay():void {
		//	trace("handleClickDelay");
			doubleclicking = false;
		}
		private function doScrolling(e:Event):void {
			var percent:Number = Math.min(1, Math.max(0, (dropdown_Cell_Backdrop.mouseY-dropdown_Cell_Backdrop.y-10) / (cellAreaHeight-20)));
			cellContainer.y = percent*(cellAreaHeight - cellContainer.height);
			//trace(percent+"%", cellContainer.y, "=", cellAreaHeight+" - "+cellContainer.height);
			if (percent < 0.1) {
				arrowUp.visible = false;
				arrowDown.visible = true;
			} else if (percent > 0.9) {
				arrowUp.visible = true;
				arrowDown.visible = false;
			} else {
				arrowUp.visible = true;
				arrowDown.visible = true;
			}
		}
		private function closeDropdown(e:MouseEvent=null):void {
		//	trace("closeDropdown");
			removeEventListener(MouseEvent.ROLL_OUT, closeDropdown);
			dropdown_Cell_Backdrop.visible = false;
			addEventListener(MouseEvent.MOUSE_DOWN, openDropdown);
			
			if (scrolling) removeEventListener(Event.ENTER_FRAME, doScrolling);
			arrowUp.visible = false;
			arrowDown.visible = false;
		}
		private function select(e=null):void {
			if (e is uint) {
				Dropdown_Base.tf.text = cellContainer.getChildAt(e).name;
				_index = e;
				_label = Dropdown_Cell(cellContainer.getChildAt(e)).label;
				_value = Dropdown_Cell(cellContainer.getChildAt(e)).value;
			//	trace("select by index", _index, _label, "/", _value);
			} else if (e is String) {
				var success:Boolean = false;
				for (var d:uint=0; d<cellContainer.numChildren; d++) {
					if (Dropdown_Cell(cellContainer.getChildAt(d)).name == e) {
						Dropdown_Base.tf.text = Dropdown_Cell(cellContainer.getChildAt(d)).name;
						_index = d;
						_label = Dropdown_Cell(cellContainer.getChildAt(d)).label;
						_value = Dropdown_Cell(cellContainer.getChildAt(d)).value;
					//	trace("select by label", _index, _label, "/", _value);
						success = true;
						break;
					} else if (Dropdown_Cell(cellContainer.getChildAt(d)).value == e) {
						Dropdown_Base.tf.text = Dropdown_Cell(cellContainer.getChildAt(d)).name;
						_index = d;
						_label = Dropdown_Cell(cellContainer.getChildAt(d)).label;
						_value = Dropdown_Cell(cellContainer.getChildAt(d)).value;
					//	trace("select by value", _index, _label, "/", _value);
						success = true;
						break;
					}
				}
				if (!success) trace("select failed. No labels or values named", e, "found in", this);
			} else if (e is MouseEvent) {
				if (doubleclicking) { trace("doubleclicking");return; }
				
				Dropdown_Base.tf.text = e.currentTarget.name;
				_index = cellContainer.getChildIndex(e.currentTarget);
				_label = e.currentTarget.label;
				_value = e.currentTarget.value;
			//	trace("select by click", _index, _label, "/", _value);
				dispatchEvent(new Event(DROPDOWN_SELECTED, true));
			} else trace("select failed. Unknown selection type", e, typeof(e));
			closeDropdown()
		}
	}	
}