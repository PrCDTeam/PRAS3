﻿package com {	import pointroll.*;	import com.Global;	import pointroll.trackNonUIActivityWithNoun;	import com.greensock.TweenNano;	import com.greensock.easing.*;	import flash.display.MovieClip;	import flash.events.MouseEvent;	import flash.display.MovieClip;	import flash.events.Event;	import flash.text.TextFormat;	import flash.text.TextField;	import flash.system.Security;			public class Built_In_America_CTA extends MovieClip {				public var global:Object;			public var format:TextFormat;							public function Built_In_America_CTA() {			Security.allowDomain("*");			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);        }		private function onAddedToStage(e:Event):void {			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);			init();		}		private function init() {			pointroll.initAd(this);			global = Global.vars;			//vehicleTxt.alpha = 0;			if (this.loaderInfo.url.indexOf("http") == -1) {/*				global.MY14TundraCTA1 = "Find a Dealer";				global.MY14TundraCTA2 = "See It";				global.CTA1URL = "http://www.gulfstates.buyatoyota.com/Advanced/Pages/VehicleLandingPage.aspx?style=Trucks&";				global.CTA2URL = "http://www.gulfstates.buyatoyota.com/Advanced/Pages/VehicleLandingPage.aspx?style=Trucks&";				global.MY14TundraGeneralBannerClick = "http://www.gulfstates.buyatoyota.com/Advanced/Pages/DealerSearch.aspx?";*/			}			setCTAs();		}				public function setCTAs() {						cta1.buttonMode = true;			cta2.buttonMode = true;			cta1.addEventListener(MouseEvent.CLICK, eventHandlers);			cta2.addEventListener(MouseEvent.CLICK, eventHandlers);			genCTA.addEventListener(MouseEvent.CLICK, eventHandlers);									if (global.MY14TundraCTA1 != "") cta1.txt.text = global.MY14TundraCTA1.toUpperCase();			if (global.MY14TundraCTA2 != "") cta2.txt.text = global.MY14TundraCTA2.toUpperCase();					}		public function eventHandlers(e:MouseEvent) {			trace(e.currentTarget.name);			switch (e.currentTarget.name) {				case "cta1":					trace('----------cta1 clicked');					pointroll.launchURL(global.clickTag2 + escape(global.CTA1URL+"&"+global.appendGA), true, cta1.txt.text+" "+global.MY14TundraVehicleColor);					break;				case "cta2":					trace('----------cta2 clicked');					pointroll.launchURL(global.clickTag3 + escape(global.CTA2URL+"&model="+global.vehTrim+"&color="+getColorCode(global.MY14TundraVehicleColor)+"&year="+global.vehYear+"&"+global.appendGA), true, cta2.txt.text +" "+global.MY14TundraVehicleColor);					break;				case "genCTA":					trace('----------genCTA clicked');					pointroll.launchURL(global.clickTag1 + escape(global.MY14TundraGeneralBannerClick+"&model="+global.vehTrim+"&color="+getColorCode(global.MY14TundraVehicleColor)+"&year="+global.vehYear+"&"+global.appendGA), true, "General Click "+global.MY14TundraVehicleColor);					break;			} 		}		public function getColorCode(colorName:String) {			var colorCode:String;			switch (colorName) {				case "AttitudeBlack":					colorCode = "";					break;				case "BlueRibbon":					colorCode = "8T5";					break;				case "MagneticGray":					colorCode = "1G3";					break;				case "RadiantRed":					colorCode = "3R3";					break;				case "SunsetBronze":					colorCode = "";					break;			}			return colorCode;		}			}	}