/**********************************************************
* AUTHOR: TOBI ECHEVARRIA
* COMPANY: POINTROLL
* 
* CLASS: PRBannerMain
*
* DESCRIPTION: 
*
**********************************************************/
package com.pointroll{
 	import flash.display.Loader;
	import flash.display.SimpleButton;
	import flash.net.URLRequest;
	import pointroll.*;
	import pointroll.info.*;
	
	import flash.display.MovieClip;
	import flash.display.Stage;

	import flash.events.Event;
	import flash.events.MouseEvent;

	import com.pointroll.abstract.PRAnimationAbstract;
	
	import com.pointroll.factory.PRBannerAnimationFactory;
	import com.pointroll.data.PRDataLoader;
	import com.pointroll.data.PRXMLParser;
	import com.pointroll.events.PRProductEvent;
	import com.pointroll.events.PRParserEvents;

	import com.pointroll.api.data.AdControl;
	import com.pointroll.api.events.AdControlEvent;
	import com.pointroll.events.DataStorageEvents;
	import com.pointroll.data.*;
	import com.pointroll.data.PRDataStorage;
	import com.pointroll.api.utils.net.isLocal;
	import flash.errors.*
	import flash.events.*
	
	import utils.align.*;
	import com.pointroll.api.utils.string.replace;
	public class PRBannerMain extends MovieClip {
		private var _animation:PRAnimationAbstract;
		public var ct:SimpleButton;	
		public var cta:SimpleButton;
		public var ctaRollOver:SimpleButton;
		public var copy2:MovieClip;
		public var smallTag:MovieClip;
		public var bigTag:MovieClip;
		public var kitchen:MovieClip;
		public var storeLogo:MovieClip;
		public var availableAt:MovieClip;
		public var gradientBG:MovieClip;
		public var copy1:MovieClip;
		public var oven:MovieClip;
		public var stove:MovieClip;
		public var adWidth:uint;
		public var adHeight:uint;
		
		// // ************for ADCONTROL ************ //
		private var _adControl:AdControl;
		private var _xmlLoader:PRDataLoader;
		private var _parser:PRXMLParser;
		public var _xmlPath:String;
		private var _flightNumber:String;
		private var _ds:PRDataStorage;
		
		
		//public function get animation():PRAnimationAbstract{ return _animation; }
		//public function set (anim:PRAnimationAbstract):void 
		//{
			//_animation = anim
		//}
		
		public function PRBannerMain() {
			this.alpha = 0;
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}

  		private function onDataStorageLoad(e:DataStorageEvents):void{
			trace("BANNER---------------onDataStorageLoad-----------------");
			//
			_ds.removeEventListener(DataStorageEvents.ON_DATA_STORAGE_LOAD, onDataStorageLoad);
			_ds.removeEventListener(DataStorageEvents.ON_DATA_STORAGE_FAIL, onDataStorageFail);
			
			makeAC();
 			
		}
		
		private function onDataStorageFail(e:DataStorageEvents):void{
			trace("---------------onDataStorageFail-----------------");
 				
			_ds.removeEventListener(DataStorageEvents.ON_DATA_STORAGE_LOAD, onDataStorageLoad);
			_ds.removeEventListener(DataStorageEvents.ON_DATA_STORAGE_FAIL, onDataStorageFail);	
			
		}
		
		
 		protected function init():void {
			pointroll.initAd(this);
			
			ct.addEventListener(MouseEvent.CLICK, onBannerEvent);
			cta.addEventListener(MouseEvent.ROLL_OVER, onBannerEvent);
			//ctaRollOver.addEventListener(MouseEvent.ROLL_OVER, onBannerEvent);
			
			//determine the ad size using this class
			setAdSize();
			
 			_ds = new PRDataStorage();
			_ds.addEventListener(DataStorageEvents.ON_DATA_STORAGE_LOAD, onDataStorageLoad);
			_ds.addEventListener(DataStorageEvents.ON_DATA_STORAGE_FAIL, onDataStorageFail);
			//trace("\n isLocal(): " + isLocal())
			_ds.checkAvailability(200, 10);
			//
			
			if (isLocal()) {
				makeAC();
				ctaRollOver.addEventListener(MouseEvent.ROLL_OVER, onBannerEvent);
			}else {
				_ds.startTimer();
			}
 		}
	
		
		//private function onDSAvail():void 
		//{
			//makeAC();
		//}
		//
 		
		public function makeAC():void 
		{
			_flightNumber = (pointroll.getFlashVar("flightNumber")) ? pointroll.getFlashVar("flightNumber") : "1";
			_flightNumber += ".xml";
			_xmlPath = "";
			
			if(isLocal()){
				_xmlPath = "../xml/";
			}else{
				_xmlPath = (pointroll.getFlashVar("mediaPath")) ? pointroll.getFlashVar("mediaPath") :
				"http://media.pointroll.com/PointRoll/Media/Panels/Electrolux/857958/";
			}
			_adControl = new AdControl();
			_adControl.interfaceID = (pointroll.getFlashVar("acid")) ? pointroll.getFlashVar("acid") : "3facd272-63f1-4a2d-99db-7093501d30e8";
			_adControl.localTestFile = "../xml/frigidaire2014.xml";
			_adControl.addEventListener(AdControlEvent.LOAD_COMPLETE, onAdControlEvent);
			_adControl.addEventListener(AdControlEvent.LOAD_FAIL, onAdControlEvent);

			_parser = new PRXMLParser();

			//_ui = PRPanelUIFactory.createUIPage(stage.stageWidth, this);
			//_ui.addEventListener(PRUIEvents.ON_UI_CLICK , onPanelEvents);
			
			_adControl.load();
		}
		
		
		private function onAdControlEvent(e:AdControlEvent):void{
			trace("\n BANNER onAdControlEvent: " + _adControl.getXMLData());
			
			
			_ds.setVariable("ac_xml", _adControl.getXMLData() );
			ctaRollOver.addEventListener(MouseEvent.ROLL_OVER, onBannerEvent);
			trace("\n ****** adding OPEN PANEL listener - ctaRollOver: " + ctaRollOver);
			switch(e.type){
				case "onComplete":
					if(_adControl.getXMLData().store != "no_store"){
						var fileName:String;
						if(String(_adControl.getXMLData().store.@Name) != "NoValue"){
							fileName = FrigidaireData._storesDictionary[String(_adControl.getXMLData().store.@Name)];
						}else{
							trace("getFileName");
							fileName = FrigidaireData._storesDictionary[String(_adControl.getXMLData().store)];
						}
						_xmlLoader = new PRDataLoader(_xmlPath+fileName+_flightNumber,_parser);
						_xmlLoader.addEventListener(PRParserEvents.ON_PARSER_COMPLETE, onDataLoaderEvent);						  
						_xmlLoader.getServiceData();
						
						this.alpha = 1;
						//_ui.buildUI();
					}else {
						//_ui.buildUI("FailSafe");
						//_ui.update("FailSafe");
						trace("\n :show banner failsafe");
						var _Loader:Loader = new Loader();
						addChildAt(_Loader, getChildIndex(ct) - 1);
						
						_Loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onDFT_Loaded);
						_Loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
						var dftJPG:String = getFlashVar("bannerDFT") || "140318_728x90_static.jpg";//"140318_160x600_static.jpg";
						trace("\n dftJPG: " + dftJPG)
						_Loader.load( new URLRequest(getFolderPath() + dftJPG))
						cta.visible = false;
						this.alpha = 1;
					}				
				break;
				case "onLoadFail":
					  //_ui.buildUI("FailSafe");
					  //_ui.update("FailSafe");
				break;
			}
		}
		
		private function onDFT_Loaded(e:Event):void 
		{
			trace("\n : banner failsafe is now showing");
		}
		
		var ac_xml:XML
		
		private function onDataLoaderEvent(e:PRParserEvents):void {
			//trace("onDataLoaderEvent: " + e.params);
			//ac_xml = XML(e.params);
			
  			var logoURL:String = XML(e.params).product[0].logourl;
			
			storeLogo.removeChildAt(0);
			
			var _Loader:Loader = new Loader();
				_Loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onImageLoaded);
 				_Loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
				
				if (isLocal()) {
					_Loader.load(new URLRequest( logoURL));
				}else {
					//logoURL = _mediaPath + replace(String(_productData[i].logourl),"assets/","");
					_Loader.load(new URLRequest (_xmlPath + replace(logoURL,"assets/","")));
				}
				
			storeLogo.addChildAt(_Loader, 0);			
						
 			
			trace("\n logoURL: " + logoURL)
			trace("\ adWidth: " + adWidth)
			
 			
			
			draw();
		}
		
		private function onImageLoaded(e:Event):void 
		{
			//reposition /size the dynamic logo
			//kitchen.x = adWidth - kitchen.width;
			//trace("\n kitchen.x: " + kitchen.x)
			
			
			switch (adWidth) 
			{
				case 728:
					storeLogo.getChildAt(0).width = 80;
				break;
				case 160:
					
				break;
				case 300:
					storeLogo.getChildAt(0).width = 70;
 				break;
 				
			}
			
			storeLogo.getChildAt(0).scaleY = storeLogo.getChildAt(0).scaleX ;
			xAlignCenter(storeLogo, availableAt);
		}
		
		private function ioErrorHandler(e:Event):void 
		{
			trace("\n err event: " + e )
		}
		
		
		//implemented in sublclasses
		protected function setAdSize():void 
		{ 	}
		
 		
		protected function draw():void {
 			_animation = PRBannerAnimationFactory.createAnimationPage(adWidth, this);	
			//
			if(adWidth==300){
				oven.alpha = 0;
				stove.alpha = 0;
				gradientBG.alpha = 0;
				bigTag.alpha = 0;
				
				_animation.duration = 1;
				_animation.addAnimationObject("oven", oven);
				_animation.addAnimationObject("stove", stove);
				_animation.addAnimationObject("gradientBG", gradientBG);				
				_animation.addAnimationObject("bigTag", bigTag);
				_animation.addAnimationObject("smallTag", smallTag);
				_animation.addAnimationObject("kitchen", kitchen);
			}else if(adWidth==728){
				copy2.alpha = 0;
				
				_animation.duration = .5;
				_animation.addAnimationObject("copy1",copy1);
				_animation.addAnimationObject("copy2", copy2);
				
			}else{
				oven.alpha = 0;
				_animation.addAnimationObject("oven", oven);
				_animation.addAnimationObject("stove", stove);				
			}
			
			_animation.startAnimation();
			trace("\n _animation: " + _animation)
			
		}


		// EVENTS
		protected function onAddedToStage(e:Event):void {
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			init();
		}
		protected function onBannerEvent(e:MouseEvent):void{
			//trace("onPanelEvents: " + e.params.eventType);
			switch(e.currentTarget){
				case ct:
					 pointroll.launchURL(pointroll.getFlashVar("clickTag1"));
				break;
				case cta:
				case ctaRollOver:
					 pointroll.openPanel(1);
				break;
			}
		}
	}
}