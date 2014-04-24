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
	import pointroll.*;
	import pointroll.panel.*;
	import pointroll.info.getFolderPath;
	import com.pointroll.api.utils.net.isLocal;

	import flash.display.MovieClip;
	import flash.display.Stage;

	import flash.events.Event;
	import flash.events.MouseEvent;

	import com.pointroll.abstract.PointRollAbstractUI;

	import com.pointroll.events.PRUIEvents;

	import com.pointroll.data.PRDataLoader;
	import com.pointroll.data.PRXMLParser;
	import com.pointroll.ui.*;

	import com.pointroll.events.PRProductEvent;
	import com.pointroll.events.PRParserEvents;

	import com.pointroll.api.data.AdControl;
	import com.pointroll.api.events.AdControlEvent;
	
	import com.pointroll.data.FrigidaireData;
	
	import com.pointroll.factory.PRPanelUIFactory;
	import com.pointroll.events.DataStorageEvents;
	import com.pointroll.data.*;
	import com.pointroll.data.PRDataStorage;
	
	public class PRPanelMain extends MovieClip {
		private var _flightNumber:String;
		public var _xmlPath:String;

		private var _ui:PointRollAbstractUI;
		
		private var _adControl:AdControl;

		private var _xmlLoader:PRDataLoader;
		private var _parser:PRXMLParser;
		private var _ds:PRDataStorage;
		private var ac_XML:XML;
		
		
		public function PRPanelMain() {
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}

		// Public Functions http://media.pointroll.com/PointRoll/Media/Panels/Electrolux/857958/

		// Private Functions
		private function init():void {
			pointroll.initAd(this);
			addEventListener(MouseEvent.MOUSE_UP, pinMe);

			_flightNumber = (pointroll.getFlashVar("flightNumber")) ? pointroll.getFlashVar("flightNumber") : "1";
			_flightNumber += ".xml";
			_xmlPath = "";
			_ds = new PRDataStorage();
			_ds.addEventListener(DataStorageEvents.ON_DATA_STORAGE_LOAD, onDataStorageLoad);
			_ds.addEventListener(DataStorageEvents.ON_DATA_STORAGE_FAIL, onDataStorageFail);
			trace("\n _ds: " + _ds)
			
 			
			//_adControl = new AdControl();
			//_adControl.interfaceID = (pointroll.getFlashVar("acid")) ? pointroll.getFlashVar("acid") : "3facd272-63f1-4a2d-99db-7093501d30e8";
			//_adControl.localTestFile = "../xml/frigidaire2014.xml";
			//_adControl.addEventListener(AdControlEvent.LOAD_COMPLETE, onAdControlEvent);
			//_adControl.addEventListener(AdControlEvent.LOAD_FAIL, onAdControlEvent);
//
			_parser = new PRXMLParser();
//
			_ui = PRPanelUIFactory.createUIPage(stage.stageWidth, this);
			_ui.addEventListener(PRUIEvents.ON_UI_CLICK , onPanelEvents);
			
			//_adControl.load();
			if(isLocal()){
				_xmlPath = "../xml/";
				ac_XML = XML('<frigidaire2014><store Name="NoValue" storeid="NoValue"><![CDATA[HH Gregg]]></store></frigidaire2014>');
				
				onAdControlEvent();
					
			}else {
				_ds.checkAvailability(200, 10);
				_ds.startTimer();
				_xmlPath = (pointroll.getFlashVar("mediaPath")) ? pointroll.getFlashVar("mediaPath") :
				"http://media.pointroll.com/PointRoll/Media/Panels/Electrolux/857958/";
			}
		}
		
		private function pinMe(e:MouseEvent):void 
		{
			removeEventListener(MouseEvent.MOUSE_UP, pinMe);
			pinPanel();
		}
		
		private function onDataStorageLoad(e:DataStorageEvents):void{
			trace("PANEL---------------onDataStorageLoad-----------------");

 			_ds.removeEventListener(DataStorageEvents.ON_DATA_STORAGE_LOAD, onDataStorageLoad);
			_ds.removeEventListener(DataStorageEvents.ON_DATA_STORAGE_FAIL, onDataStorageFail);
			
			ac_XML  = XML(_ds.getVariable( "ac_xml" ));
			onAdControlEvent();
			
			//trace("\n ac_XML: " + ac_XML)
			
		}
		
		private function onDataStorageFail(e:DataStorageEvents):void{
			trace("PANEL---------------onDataStorageFail-----------------");
 			//if (isLocal()) {
					//ac_XML = XML('<frigidaire2014>  <store Name="NoValue" storeid="NoValue"><![CDATA[HomeDepot]]></store></frigidaire2014>');
					//onAdControlEvent();
				//}
			
			_ds.removeEventListener(DataStorageEvents.ON_DATA_STORAGE_LOAD, onDataStorageLoad);
			_ds.removeEventListener(DataStorageEvents.ON_DATA_STORAGE_FAIL, onDataStorageFail);	
			
		}

		// EVENTS 1001_HHGregg_46240
		
		private function onAddedToStage(e:Event):void {
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			init();
		}
		
		
		private function onPanelEvents(e:PRUIEvents):void {
			 trace("\n e.params: " + e.params.currentTarget)
			switch(e.params.currentTarget.name){
				case "closeBtn":
					 pointroll.panel.closePanel();
				break;
				case "clickTag":
					 pointroll.launchURL(pointroll.getFlashVar("clickTag1"));
					
				break;
				case "leftArrow":
					 pointroll.trackActivity(1);
					  setProductConditions();
				break;
				case "rightArrow":
					 pointroll.trackActivity(2);
					 //trace("\n curretn PROD OBJ: " +  _ui._productBuilder._products[_ui._scroller._currentPage - 1])
					 //trace("\ _ui._scroller._currentPage : " +  (_ui._scroller._currentPage) )
 					 setProductConditions();
				break;
				case "productClick":
					 pointroll.launchURL(pointroll.getFlashVar("clickTag2")+e.params.buyNow);
				break;
			}
		}
		
		
		
		private function onDataLoaderEvent(e:PRParserEvents):void {
			//trace("onDataLoaderEvent: " + e.params);
			_ui.update(e.params, _xmlPath);
			
			trace("\n curretn PROD OBJ: " +  (_ui._productBuilder._products[_ui._scroller._currentPage].prodID.text))
			trace("\ _ui._scroller._currentPage : " +  (_ui._scroller._currentPage) )
			
			//check conditional
			setProductConditions()
		}
		
		private function setProductConditions():void 
		{
			var currentProdId:String = _ui._productBuilder._products[_ui._scroller._currentPage - 1].prodID.text;
			trace("\n currentProdId: " + currentProdId)
			if (currentProdId == "FFGF3053LS" && String(ac_XML.store) == "HomeDepot" ) 
			//if (currentProdId == "FFGF3053LS"  ) 
			{
				_ui._logo.gotoAndStop(2);
				//trace( "found FFGF3053LS --- _logo currentFrame: " + MovieClip(PointRoll728x90PanelUI(_ui)._logo).currentFrame)
			}else 
			{
				_ui._logo.gotoAndStop(1);
				
			}
		}
		
		
		//private function onAdControlEvent(e:AdControlEvent):void{
		private function onAdControlEvent():void{
			trace("onAdControlEvent  ac_XML: " + ac_XML);
			//switch(e.type){
				//case "onComplete":
					if(ac_XML.store != "no_store"){
						var fileName:String;
						
						//stage.stageWidth
						
						if(String(ac_XML.store.@Name) != "NoValue"){
							fileName = FrigidaireData._storesDictionary[String(ac_XML.store.@Name)];
						}else{
							trace("getFileName");
							fileName = FrigidaireData._storesDictionary[String(ac_XML.store)];
						}
						trace("\n fileName: " + fileName)
						trace("\ _xmlPath: " + _xmlPath + fileName + _flightNumber)
						
						var xpath_str:String = _xmlPath+fileName+_flightNumber
						
						_xmlLoader = new PRDataLoader(xpath_str,_parser);
						_xmlLoader.addEventListener(PRParserEvents.ON_PARSER_COMPLETE, onDataLoaderEvent);						  
						_xmlLoader.getServiceData();
						_ui.buildUI();
						//_ui.update();
						//_ui.addEventListener("onProductBuilderComplete", onProductBuilderComplete);
						
 						
					}else{
						_ui.buildUI("FailSafe");
						_ui.update("FailSafe");
					}				
				//break;
				//case "onLoadFail":
					  //_ui.buildUI("FailSafe");
					  //_ui.update("FailSafe");
				//break;
			//}
			
			
		}
		
		private function onProductBuilderComplete(e:Event):void 
		{
			//trace("\n curretn PROD OBJ: " +  (_ui._productBuilder))
		}
		
		
		
	}
}