﻿package com.pointroll.ui{	import flash.display.Sprite;	import flash.display.DisplayObjectContainer;	import flash.display.MovieClip;	import flash.events.MouseEvent;	import flash.events.Event;	import flash.events.IOErrorEvent;		import com.pointroll.abstract.PointRollAbstractUI;		import com.pointroll.utils.PointRollUtils;	import com.pointroll.events.PRProductEvent;	import com.pointroll.events.PRUIEvents;		import com.pointroll.paperboy.ProductBuilder;		import com.pointroll.utils.PRScroller;	import com.pointroll.events.PRScrollerEvents;			public class PointRoll160x600PanelUI extends PointRollAbstractUI {		private var _timeline:DisplayObjectContainer;					//private var _productBuilder:ProductBuilder;		//private var _scroller:PRScroller;				// stage elements		private var clickTag:Sprite;			private var _mask:Sprite;		private var _holder:MovieClip;				private var _background:Background;		private var _leftArrow:LeftArrow;		private var _rightArrow:RightArrow;		//private var _logo:Logo;		private var _closeBtn:CloseBtn;				private var _failSafe:NoProducts;		private var _loadingIcon:LoadingIcon;		public function PointRoll160x600PanelUI(timeline:DisplayObjectContainer) {			_timeline = timeline;			super(timeline);		}		override public function init():void{			_background = new Background();						_logo = new Logo();			_logo.x = 92;			_logo.y = 28;								_loadingIcon = new LoadingIcon();			_loadingIcon.width = _loadingIcon.height = 52;			_loadingIcon.x = 160;			_loadingIcon.y = 294;			_loadingIcon.addEventListener(Event.ENTER_FRAME, onRotate);						_timeline.addChild(_background);			_timeline.addChild(_loadingIcon);									_closeBtn = new CloseBtn();			_closeBtn.name = "closeBtn";			_closeBtn.x = 270;			_closeBtn.y = 3;			_closeBtn.addEventListener(MouseEvent.CLICK, onUIEvent);		}		override public function update(...args):void {					   if(args[0]!="FailSafe"){			  _holder = new MovieClip();			  _holder.name = "holder";			  _holder.y = 100			   			  _leftArrow = new LeftArrow();				  _leftArrow.name = "leftArrow";			  _leftArrow.y = 254;			  _leftArrow.visible = false;			  _leftArrow.addEventListener(MouseEvent.CLICK, onUIEvent);			  		      _rightArrow = new RightArrow();				  _rightArrow.name = "rightArrow";			  _rightArrow.x = 287;			  _rightArrow.y = 254;			  _rightArrow.addEventListener(MouseEvent.CLICK, onUIEvent);			  			  _productBuilder = new ProductBuilder(_timeline, args[0].product, _holder, _timeline.stage.stageWidth, args[1]);			  _productBuilder.addEventListener("onProductBuilderComplete", onProductBuilderComplete);			  _productBuilder.addEventListener(PRProductEvent.ON_PRODUCT_CLICK, onProductClick);			  _productBuilder.buildProducts();			 			  _timeline.addChild(_holder);			  _timeline.addChild(_mask);			  _timeline.addChild(_leftArrow);			  _timeline.addChild(_rightArrow);			  _timeline.removeChild(_closeBtn);			  _timeline.addChild(_closeBtn);		   }else{			   trace("buildFailSafe");			   _failSafe = new NoProducts();			   _failSafe.x = 28;			   _failSafe.y = 276;			   _timeline.addChild(_failSafe);		   }		   _loadingIcon.removeEventListener(Event.ENTER_FRAME, onRotate);		   _timeline.removeChild(_loadingIcon);		}		override public function buildUI(...args):void {						clickTag = PointRollUtils.createClickTag(0,0,getUIWidth(),getUIHeight(),0);			clickTag.name = "clickTag";			clickTag.buttonMode = clickTag.useHandCursor = true;			clickTag.addEventListener(MouseEvent.CLICK, onUIEvent);						_mask = PointRollUtils.createClickTag(0,0,getUIWidth(),getUIHeight(),0);			_mask.name = "mask";			_mask.y = 80						//_timeline.addChild(_background);			_timeline.addChild(_logo);			_timeline.addChild(clickTag);			_timeline.addChild(_closeBtn);					}				//EVENTS		private function onUIEvent(e:MouseEvent):void {			var _dataObject:Object = new Object();			_dataObject.currentTarget = e.currentTarget;						switch(e.currentTarget){				case _leftArrow:					 _scroller.moveRight();					 _rightArrow.visible = true;				break;				case _rightArrow:					 					 _scroller.moveLeft();					 _leftArrow.visible = true;				break;			}			dispatchEvent(new PRUIEvents(PRUIEvents.ON_UI_CLICK, _dataObject));		}		private function onProductClick(e:PRProductEvent):void{			var _dataObject:Object = e.params;			_dataObject.currentTarget = e.currentTarget;			_dataObject.currentTarget.name = "productClick";			dispatchEvent(new PRUIEvents(PRUIEvents.ON_UI_CLICK, _dataObject));					}		private function onProductBuilderComplete(e:Event):void{			_scroller = new PRScroller(_holder,_mask,  _productBuilder.totalProducts, 1);			_scroller.addEventListener(PRScrollerEvents.ON_SCROLL_LEFT_END, onScrollerEvent);			_scroller.addEventListener(PRScrollerEvents.ON_SCROLL_RIGHT_END, onScrollerEvent);		}		private function onScrollerEvent(e:PRScrollerEvents):void{			trace("onScrollerEvent: " + e.type);			switch(e.type){				case "onScrollLeftEnd":					  					  _rightArrow.visible = false;				break;				case "onScrollRightEnd":					  _leftArrow.visible = false;				break;			}		}		private function onRotate(e:Event):void {			e.target.rotation +=  10;		}		// toString		public function printAdSize():void{			trace("Creative Size: " + getUIWidth() +"x"+getUIHeight());			}	}}