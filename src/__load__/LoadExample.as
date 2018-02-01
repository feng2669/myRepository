package __load__
{
	import __load__.__bitmap__.BitmapGroup;
	import __load__.__bitmap__.CloneableBitmap;
	import __load__.__loaders__.BmpLoaderQueue;
	
	/**
	 * 加载的例子
	 * @author zhufeng
	 * 
	 */	
	public class LoadExample
	{
		public static var defaultResource:LoadExample;
		
		private var m_BitmapLoader:BmpLoaderQueue;
		
		private var m_bannerGroup:BitmapGroup;
		
		public function LoadExample(url:String="")
		{
			this.m_BitmapLoader = new BmpLoaderQueue(url);
			
			//绑定一个图片加载队列
			this.m_bannerGroup = new BitmapGroup(this.m_BitmapLoader, "banner", "");
		}
		
		/**
		 * 
		 * @param url
		 * 
		 */		
		public static function initialize(url:String=""):void
		{
			if (!defaultResource)
			{
				defaultResource = new LoadExample(url);
			}
		}
		
		public function getBannerImage(url:String):CloneableBitmap
		{
			return (this.m_bannerGroup.getBitmap(url));
		}
		
	}
}