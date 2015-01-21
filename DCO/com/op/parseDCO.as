package com.op {
	
	import com.API.Global;
	
	public class parseDCO {
		private var dcoXML:XML;
		private var dcoObj:Object = new Object();
		private var global:Object;
		private var nameArray:Array;
		private var depthCount:Number = 0;
		
		public function parseDCO(dcoXML) {
			
			global = Global.vars;
			global.dcoObj = dcoObj;
			dcoXML = dcoXML;
			nameArray = new Array();
			enumNodes(dcoXML.children());			
		}
		
		private function enumNodes(dcoChildren):void{
			depthCount++;
			
			for(var c:Number=0;c<dcoChildren.length();c++){
				if(dcoChildren[c].children()..*.length() < 1){
					
					global.dcoObj[nameArray.join("/") + "/"+ dcoChildren[c].name()] = dcoChildren[c];
					trace("     >>DCO Value: " + nameArray.join("/") + "/"+ dcoChildren[c].name() + " = " + global.dcoObj[nameArray.join("/") + "/"+ dcoChildren[c].name()]);
					//trace("");
					
				}else{
					nameArray.push(dcoChildren[c].name());
					enumNodes(dcoChildren[c].children());
				}
			}
			nameArray.pop();
		}
	}
}