package com.op 
{	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.external.ExternalInterface;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	/**
	 * DCO class allows a developer the ability to pass all of the flash vars in order to retrieve XML data from the server based on a selected rule set 
	 * @author Todd Coulson
	 * 
	 */
	public class DCO extends EventDispatcher
	{
		protected const queryParams:Object =  
			{
				campid: "PRCampID",
				pub: "PRPubID",
				pid: "PRPID",
				cid: "PRCID",
				imp: "PRImpID",
				countryid: "PRGeoCountryID",
				regionid: "PRGeoRegionID",
				metroid: "PRGeoMetroID"
			};

		public var returnXML:XML;
		public var localTestFile:String;
		public var dateSent:Date;
		
		//"http://ptr-kopwebdev08/adserver1/search/getOutputxml/?"
		private var baseURL:String = "http://dco.pointroll.com/search/getoutputxml/?";
		
		private var _ruleSetID:String;
		private var _advertiserID:int = 0;
		private var _creativeID:int;
		private var _loader:URLLoader;
		private var _finalURL:String;
		private var _flashVarsObject:Object;
		
		/**
		 * DCO constructor requires an object to be passed in. 
		 * @param flashVarsObject represents the Flash Vars to be used in the project.
		 * to get the flashVars from the project you are working on, use root.loaderInfo.parameters;
		 */		
		public function DCO(rulesetid:String, flashVarsObject:Object)
		{
			ruleSetID = rulesetid;
			_flashVarsObject = flashVarsObject;
			
			_finalURL = baseURL;
			
		}
		
		/**
		 * @private
		 * onError gets called if there is a problem with the load call.
		 * @param e ErrorEvent
		 * 
		 */		
		private function onError(e:ErrorEvent):void{
			
			_loader.removeEventListener(Event.COMPLETE, onCompleteXML);
			_loader.removeEventListener(ErrorEvent.ERROR, onError);
			dispatchEvent(new ErrorEvent(ErrorEvent.ERROR));
			trace(e.toString());
		}
		
		/**
		 * @private
		 * onComplete for load method, pass xml object onto return XML
		 * @param e Complete event for load
		 * 
		 */		
		private function onCompleteXML(e:Event):void{
			returnXML = new XML(e.target.data);
			
			_loader.removeEventListener(Event.COMPLETE, onCompleteXML);
			_loader.removeEventListener(ErrorEvent.ERROR, onError);
			
			dispatchEvent(new Event(Event.COMPLETE));
		}
		
		/**
		 * call this load method in order to load in the Flash Vars you pass into the project. 
		 * Upon completion of method (listen to COMPLETE event on DCO class), xml will be available in returnXML property of this class.  
		 * 
		 */		
		public function load():void
		{
			returnXML = null;
			if(!_ruleSetID){
				throw new Error("no ruleset id exists");
			}
			
			var dataStorageValue:String = getVariable("DCO_" + _ruleSetID.toLowerCase());
			//use the DS data only if it is valid AND we are not on the DCO test page 
			if (validateDSString(dataStorageValue)  &&  createXMLFromDataStorage(dataStorageValue))
			{
				
				dispatchEvent(new Event(Event.COMPLETE));
			}else{


				_finalURL = buildURLString();
				
				dateSent = new Date();
				
				_finalURL = addParameterToURL("date", String(dateSent.time), _finalURL);
				_finalURL = addParameterToURL("rulesetid", _ruleSetID, _finalURL);
		
				launchLoad();
			}
		}
		
		/**
		 * @private
		 */
		protected function validateDSString( dataStorageValue:String ):Boolean
		{
			//ridiculously long list of conditions must be met
			return (dataStorageValue != "undefined" && dataStorageValue != null && dataStorageValue != "null" && dataStorageValue != "")
		}
		
		protected function createXMLFromDataStorage(str:String):Boolean{
			try{
				returnXML = new XML(str);
				return true;
			}catch(e:Error){
				return false;
			}
			return false;
		}
		
		protected function launchLoad():void{
			_loader = new URLLoader();
			_loader.addEventListener(Event.COMPLETE, onCompleteXML);
			_loader.addEventListener(ErrorEvent.ERROR, onError);
			
			_loader.load(new URLRequest(_finalURL));
		}
		
		
		
		/**
		 * @private
		 * convenience method created to build a url string that includes all available FlashVars as URL parameters. 
		 * @return a url string
		 * 
		 */		
		protected function buildURLString():String{
			var str:String = baseURL;
			for (var s:String in queryParams){
				str = addParameterToURL(s, _flashVarsObject[ queryParams[s]], str);
			}
			return str;
		}
		
		/**
		 * @private
		 * Convenience method allows the user to pass a name, value, and url for a single parameter and return a url with the parameter attached.
		 * @param name name of the parameter to add to url
		 * @param value value of the parameter added.
		 * @param urlString a url string without the parameter
		 * @return a url with the parameter added to the end of the original url string.
		 * 
		 */		
		protected function addParameterToURL(name:String, value:String, urlString:String):String
		{
			if (value != null && value != "")
			{
				value = escape(value);
				if (!endsWith(urlString, "?"))
				{
					urlString += "&";
				}
				
				urlString += name + "=" + value;	
			}
			return urlString;
		}
		
		/**
		 * @private
		 * convenience method can pass two strings and tell if it is at the end of the other string. 
		 * @param string original string
		 * @param searchTerm term that should appear at the end of the string.
		 * @return boolean of true if searchTerm is indeed at the end of the string.
		 * 
		 */	
		protected function endsWith(string:String, searchTerm:String):Boolean
		{
			return (string.lastIndexOf(searchTerm) == string.length-searchTerm.length);
		}
		
		/**
		 * setting a new rulesetid at anytime with this getter, will also update the flashVarsObject upon setting the variable.
		 */
		public function get ruleSetID():String{
			return _ruleSetID;
		}
		
		public function set ruleSetID(rs:String):void{
			_ruleSetID = rs;
		}
		
		/**
		 * flashVarsObject getter setter allows the user to enter a new FlashVarsObject at any time during the class' existence. 
		 * Loading new FlashVars and running load will send new parameters, without creating a new instance of DCO.
		 */
		public function get flashVarsObject():Object{
			return _flashVarsObject;
		}
		
		public function set flashVarsObject(flashVars:Object):void{
			_flashVarsObject = flashVars;
		}
		
		/**
		 * getter for retriving the value of the url used in the load call.
		 */
		public function get finalURL():String{
			return _finalURL;
		}
		
		
		
		//Functions needed for JavaScript implementation.
		protected function sendJS(...arguments) : * {
			if(ExternalInterface.available)
			{
				return ExternalInterface.call.apply(null,arguments);
			}
			
			return null;
		}
		
		
		/**
		 * @private
		 * Returns the current value of the variable.
		 * @param	name The name of the variable. Must match the <code>name</code> parameter used in the <code>setVariable()</code> method.
		 * @return Returns the value of the variable.
		 */
		protected function getVariable(name:String):String{
			if (!available)
			{
				return null;
			}
			return String(sendJS("prGet", name));
		}
		
		/**
		 * @private
		 * property of the class which evaluates <code>true</code> if DataStorage is available in the current environment, false otherwise.
		 */
		protected function get available():Boolean{
			var f:Object = sendJS("function() {return typeof(prGet);}");
			return f == "function";
			
		}
		
		

	}
}