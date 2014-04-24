package com.pointroll 
{
	/**
	 * ...
	 * @author slee@pointroll
	 */
	
	import com.pointroll.factory.PRBannerAnimationFactory;
	 
	public class PRBanner_728x90 extends PRBannerMain 
	{
		
		public function PRBanner_728x90() 
		{
			super();
 		}
		
		override protected function setAdSize():void {
 			//implemented in sublclasses
			//failsafe set here
			adWidth = 728;
			adHeight = 90;
 		}
		
		
		
		
	}

}