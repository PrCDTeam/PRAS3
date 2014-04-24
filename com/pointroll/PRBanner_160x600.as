package com.pointroll 
{
	/**
	 * ...
	 * @author slee@pointroll
	 */
	
	import com.pointroll.factory.PRBannerAnimationFactory;
	 
	public class PRBanner_160x600 extends PRBannerMain 
	{
		
		public function PRBanner_160x600() 
		{
			super();
 		}
		
		override protected function setAdSize():void {
 			//implemented in sublclasses
			//failsafe set here
			adWidth = 160;
			adHeight = 600;
 		}
		
		
		
		
	}

}