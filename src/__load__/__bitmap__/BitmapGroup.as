package __load__.__bitmap__
{
	import flash.display.Bitmap;
	import flash.utils.Dictionary;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;
	
	import __load__.__loaders__.BmpLoaderQueue;
	
	/**
	 * 图片分组
	 * @author zhufeng
	 * 
	 */	
	public class BitmapGroup
	{
		private var m_Loader:BmpLoaderQueue;
		private var m_sGroupName:String;
		private var m_sDefaultExt:String;
		private var m_BitmapClass:*;
		private var m_Bitmaps:Dictionary;
		private var m_loadTimeoutList:Vector.<uint>;
		
		/**
		 * 
		 * @param queue 共用的图片加载队列
		 * @param groupName 每个组的名称：可以作为相对路径url的一部分；可以作为对象池的key
		 * @param defaultExt 图片的格式：png，jpg等等
		 * @param clas 默认CloneableBitmap；或者CloneableBitmap的子类
		 * 
		 */		
		public function BitmapGroup( queue:BmpLoaderQueue, groupName:String = "", defaultExt:String = ".png", clas:Class = null )
		{
			this.m_Loader = queue;
			this.m_sGroupName = groupName;
			this.m_sDefaultExt = defaultExt;
			this.m_BitmapClass = ( clas ? clas : CloneableBitmap );
			this.m_Bitmaps = new Dictionary();
			this.m_loadTimeoutList = new Vector.<uint>();
		}

		public function destruct():void
		{
			this.m_Bitmaps = null;
			this.m_Loader = null;
		}

		public function disposeAllBitmap():void
		{
			for each (var cBitmap:CloneableBitmap in this.m_Bitmaps)
			{
				if( cBitmap )
				{
					if ( cBitmap.bitmapData )
					{
						cBitmap.bitmapData.dispose();
						cBitmap.bitmapData = null;
					}
					this.m_Bitmaps[ cBitmap.url ] = null;
				}
			}
		}

		public function getBitmap( url:String ):CloneableBitmap
		{
			var cBitmap:CloneableBitmap = this.m_Bitmaps[ url ];
			if( cBitmap == null )
			{
				cBitmap = new this.m_BitmapClass();
				cBitmap.url = url;
				this.m_Bitmaps[ url ] = cBitmap;
				this.m_loadTimeoutList.push( setTimeout( this.loaderLater, ( 30 + this.m_loadTimeoutList.length * 30 ), url, cBitmap, this.loadBitmapComplete ));
			}
			return ( cBitmap ? cBitmap.clone() : null );
		}

		private function loaderLater( url:String, cBitmap:CloneableBitmap, complete:Function ):void
		{
			clearTimeout( this.m_loadTimeoutList.shift());
			this.m_Loader.requestLoad( url, cBitmap, complete );
		}

		private function loadBitmapComplete( cBitmap:CloneableBitmap, bitmap:Bitmap ):void
		{
			if( bitmap )
			{
				cBitmap.bitmapData = bitmap.bitmapData;
			} else
			{
				cBitmap.bitmapData = null;
			}
		}
	}
}