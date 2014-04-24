package com.pointroll 
{
	/**
	 * ...
	 * @author slee@pointroll
	 */
	
	import com.pointroll.factory.PRBannerAnimationFactory;
	 
	public class PRBanner_300x250 extends PRBannerMain 
	{
		
		public function PRBanner_300x250() 
		{
			super();
 		}
		
		override protected function setAdSize():void {
 			//implemented in sublclasses
			//failsafe set here
			adWidth = 300;
			adHeight = 250;
 		}
		
		
		
		
	}

}