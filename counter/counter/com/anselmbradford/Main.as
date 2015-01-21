﻿/*** @author Anselm Bradford anselmbradford.com*/package com.anselmbradford{	import flash.display.Sprite;	import flash.events.TimerEvent;	import flash.utils.Timer;		public class Main extends Sprite 	{		/**		* Create a new CountDown object, listen for updates and pass it the date to countdown to.		*/		public function Main()		{			var cd:CountDown = new CountDown();			cd.addEventListener( CountDownEvent.UPDATE , _updateDisplay );			cd.init( new Date(2011,7,4,12,00) );		}				/**		* Update the display.		*/		private function _updateDisplay( evt:CountDownEvent ) : void		{			var diff:Number = evt.millisecondsLeft;						var daysLeft:int = Math.floor((diff / (60*60*24)) / 1000);			var daysPortion:Number = (100-(daysLeft*100/30))/100;			diff -= (daysLeft*CountDown.MILLISECONDS_PER_DAY);						var hoursLeft:int = Math.floor((diff / (60*60))/1000);			var hoursPortion:Number = (100-(hoursLeft*100/24))/100;			diff -= (hoursLeft*CountDown.MILLISECONDS_PER_HOUR);						var minutesLeft:int = Math.floor((diff / 60)/1000);			var minutesPortion:Number = (100-(minutesLeft*100/60))/100;			diff -= (minutesLeft*CountDown.MILLISECONDS_PER_MINUTE);						var secondsLeft:int = Math.floor(diff/1000);			var secondsPortion:Number = (100-(secondsLeft*100/60))/100;						days.digit.text = daysLeft;			hours.digit.text = hoursLeft;			minutes.digit.text = minutesLeft;			seconds.digit.text = secondsLeft;						days.alpha = 1;			hours.alpha = 1;			minutes.alpha = 1;			seconds.alpha = 1;		}	}}