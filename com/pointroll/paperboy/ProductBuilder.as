package com.pointroll.paperboy{
	import flash.events.EventDispatcher;
	import utils.align.xAlignCenter;
	import utils.align.yAlignCenter;

	import com.pointroll.paperboy.Product;
	import com.pointroll.events.PRProductEvent;

	import flash.display.*;
	import flash.display.DisplayObjectContainer;

	import com.pointroll.paperboy.events.ProductEvents;

	import flash.events.MouseEvent;
	import flash.events.Event;
	import flash.display.Sprite;

	import flash.net.URLRequest;
	import flash.display.Loader;

	import com.pointroll.api.utils.net.isLocal;
	import com.pointroll.api.utils.string.replace;

	public class ProductBuilder extends Sprite {
		private var _productData:XMLList;

		private var _productHolder:MovieClip;

		private var _totalProducts:int;
		private var _productCount:int = 0;
		private var _textPadding:int = 10;
		private var _stageSize:int;

		private var _imageLoader:Loader;
		private var _logoLoader:Loader;
		
		private var _timeline:DisplayObjectContainer;
		
		private var _mediaPath:String;

		public var _products:Array = new Array();

		public function ProductBuilder(timeline:DisplayObjectContainer, xmlData:XMLList, container:MovieClip, stageSize:int, mediaPath:String) {
			_timeline = timeline;
			_productData = xmlData;
			_productHolder = container;
			_stageSize = stageSize;
			_mediaPath = mediaPath;
		}
		public function buildProducts():void {
			_totalProducts = _productData.length();			
			trace("\n ProductBuilder: " + this)
			//trace(_timeline.stage.stageWidth);
			
			if (hasChildren) {
				removeChildren();
			}
			for (var i:int = 0; i < _totalProducts; i++) {
				var slide:Slide = new Slide();
				var imageURL:String;
				var logoURL:String;
				_imageLoader = new Loader();
				_logoLoader = new Loader();
				
				
				_logoLoader.contentLoaderInfo.addEventListener(Event.COMPLETE,onImageLoaded);
				
				slide.x = i * slide.width;
				slide.bg.alpha = 0;
				slide.prodID.text = _productData[i]. @ id;
				slide.prodname.htmlText = _productData[i].model;
				slide.prodfeatures.htmlText = _productData[i].features;
				slide.buyNow = _productData[i].cta;
				
				slide.bg.buttonMode = slide.bg.useHandCursor = true;
				
				slide.btn_shop.addEventListener(MouseEvent.CLICK, onProductClick);
				slide.bg.addEventListener(MouseEvent.CLICK, onProductClick);

 				
				if (isLocal()) {
					if (_timeline.stage.stageWidth == 320 ||_timeline.stage.stageWidth == 728) 
					{
						imageURL = replace(String(_productData[i].imageurl),".png","_LRG.png");
					}else 
					{
						imageURL = _productData[i].imageurl;
					}
					//trace("\n imageURL: " + imageURL)
					logoURL = _productData[i].logourl;
				}
				else {
					if (_timeline.stage.stageWidth == 320 ||_timeline.stage.stageWidth == 728) 
					{
						imageURL = _mediaPath + replace(String(_productData[i].imageurl), "assets/", "");
						imageURL = replace(imageURL,".png","_LRG.png");
					}else 
					{
						
					imageURL = _mediaPath + replace(String(_productData[i].imageurl),"assets/","");
					}
					logoURL = _mediaPath + replace(String(_productData[i].logourl),"assets/","");				
				}
				trace("imageURL: " +  imageURL);
				//trace("logoURL: " + logoURL);
				try{
					_imageLoader.load(new URLRequest(imageURL));
					_logoLoader.load(new URLRequest(logoURL));
				}catch(e:Error){trace(e)};
				
				setImageLocation(_stageSize)

				_products.push(slide);				
				
				
				slide.addChild(_imageLoader);
				
				//if (_timeline.stage.stageWidth == 728) 
					//{
						//_logoLoader.content.width = 100;
						//yAlignCenter(_imageLoader, _timeline);
					//}
			//
				//if (_timeline.stage.stageWidth == 320) 
					//{
						//xAlignCenter(_imageLoader, _timeline);
						//_imageLoader.scaleX = _imageLoader.scaleY = .95;
						//_imageLoader.x -= 30;
						//_imageLoader.y -= 100;
					//}
			
				
				
				slide.addChild(_logoLoader);
				
				slide.setChildIndex(slide.bg, slide.numChildren-1);
				slide.setChildIndex(slide.btn_shop, slide.numChildren-1);

				_productHolder.addChild(slide);
				_productCount++;
			}
			dispatchEvent(new Event("onProductBuilderComplete"));
		}
		
		private function onImageLoaded(e:Event):void 
		{
			trace("\n _logoLoader.content: " + _logoLoader.content)
 			
			switch(_timeline.stage.stageWidth){
				case 320:
 											
				break;
				
				case 500:
				
 				break;
				
				case 728: 					
					e.currentTarget.content.width = 90;
					e.currentTarget.content.scaleY = e.currentTarget.content.scaleX ;
					Bitmap(e.currentTarget.content).smoothing = true;
					trace("\n e.currentTarget.content.width: " + e.currentTarget.content.width)
 				break;
			}
			
			
		}
		
		
		
		public function setImageLocation(stageSize:int):void{
			switch(stageSize){
				case 320:
					_imageLoader.x = 70;
					_imageLoader.y = -50;

					_logoLoader.x = 168;
					_logoLoader.y = 406;								
				break;
				case 500:
					_imageLoader.x = 208;
					_imageLoader.y = 45;

					_logoLoader.x = 345;
					_logoLoader.y = 180;				
				break;
				case 728:
					_imageLoader.x = 255;
					_imageLoader.y = 42;

					_logoLoader.x = 600;
					_logoLoader.y = 109;
					
					
					
					//xAlignCenter(_imageLoader, slide.availTag)
				break;
			}
		}
		private function onLoaderEvent(e:Event):void {
			trace("onLoaderEvent: " + e);
		}
		private function removeChildren():void {
			while (_productHolder.numChildren > 0) {
				_productHolder.removeChildAt(0);
			}
		}

		// EVENTS
		private function onProductClick(e:MouseEvent):void {
			var _dataObject:Object = new Object();
			_dataObject.buyNow = e.currentTarget.parent.buyNow;
			dispatchEvent(new PRProductEvent(PRProductEvent.ON_PRODUCT_CLICK, _dataObject));
		}
		private function onProductImageLoad(e:Event):void {
		}
		// GETTERS & SETTERS
		public function get totalProducts():int {
			return _productCount;
		}
		public function get hasChildren():Boolean {
			trace("hasChildren " + _productHolder.numChildren);
			if (_productHolder.numChildren) {
				return true;
			}
			return false;
		}

	}
}