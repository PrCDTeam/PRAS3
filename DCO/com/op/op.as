package com.op{
    import flash.display.MovieClip;
    import flash.events.Event;
    import flash.events.ErrorEvent;
 
    public class op extends MovieClip {
        private var dco:DCO;
		public var __root;
		
        public function op($root) {
			__root = $root;
            dco = new DCO("10c690a2-a838-4c39-9ee5-867d26b95902", __root.loaderInfo.parameters);
            dco.addEventListener(Event.COMPLETE, onXMLReady);
            dco.addEventListener(ErrorEvent.ERROR, onLoadingError);
            dco.load();
        }
        private function onXMLReady(e:Event):void{
			trace(dco.returnXML.toString());
           __root.screenXML_txt.appendText("\nXML Returned :::\n"+dco.returnXML.toString());
		   //__root.main.endCopy.endCopyTxt.text = dco.returnXML..FiestaFeatureValues;
        }
        private function onLoadingError(e:ErrorEvent):void{
            __root.screenXML.appendText("\nError :::\n"+e.text);
            trace(e.text);
        }
    }
	
}