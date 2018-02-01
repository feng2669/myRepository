package __load__.__loaders__
{
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	
	import __load__.__bitmap__.CloneableBitmap;

	/**
	 * 图片加载队列：
	 * 首先按二进制的格式加载图片；然后转换成Bitmap。
	 * 可以避免在获取LoaderInfo对象时产生的跨域问题！
	 * @author zhufeng
	 * 
	 */	
	public class BmpLoaderQueue
	{
		private var m_SiteURL:String;
		private var m_nLoaderCount:int;
		private var m_Loaders:Vector.<BmpDataLoader>;
		private var m_TaskList:Vector.<BmpLoadDataContext>;

		/**
		 * 
		 * @param steURL 为空是绝对地址，否则是相对地址
		 * @param countNum 最大的加载数量
		 * 
		 */		
		public function BmpLoaderQueue( siteURL:String = "", countNum:uint = 4 )
		{
			this.m_SiteURL = siteURL;
			this.m_nLoaderCount = countNum;
			this.m_Loaders = new Vector.<BmpDataLoader>();
			this.m_TaskList = new Vector.<BmpLoadDataContext>();
			var index:int = 0;
			var urlLoader:BmpDataLoader = null;
			while( index < countNum )
			{
				urlLoader = new BmpDataLoader( this );
				urlLoader.addEventListener( Event.COMPLETE, this.onLoadComplete );
				urlLoader.addEventListener( IOErrorEvent.IO_ERROR, this.onLoadError );
				urlLoader.addEventListener( SecurityErrorEvent.SECURITY_ERROR, this.onLoadError );
				this.m_Loaders.push( urlLoader );
				index++;
			}
		}

		public function destruct():void
		{
			var index:int = 0;
			var urlLoader:BmpDataLoader = null;
			this.m_TaskList.length = 0;
			while( index < this.m_Loaders.length )
			{
				urlLoader = BmpDataLoader( this.m_Loaders[ index ]);
				urlLoader.removeEventListener( Event.COMPLETE, this.onLoadComplete );
				urlLoader.removeEventListener( IOErrorEvent.IO_ERROR, this.onLoadError );
				urlLoader.removeEventListener( SecurityErrorEvent.SECURITY_ERROR, this.onLoadError );
				urlLoader.destruct();
				index++;
			}
			this.m_Loaders.length = 0;
			this.m_Loaders = null;
		}
		
		public function get siteURL():String
		{
			return ( this.m_SiteURL );
		}

		public function get length():int
		{
			return ( this.m_TaskList.length );
		}

		public function push( _arg1:BmpLoadDataContext ):uint
		{
			return ( this.m_TaskList.push( _arg1 ));
		}
		
		public function pop():BmpLoadDataContext
		{
			return ( this.m_TaskList.pop());
		}
		
		public function shift():BmpLoadDataContext
		{
			return ( this.m_TaskList.shift());
		}

		public function requestLoad( url:String, cBitmap:CloneableBitmap, callBack:Function ):void
		{
			var context:BmpLoadDataContext = null;
			context = new BmpLoadDataContext();
			context.m_DataURL = ( this.m_SiteURL + url );
			context.m_RequesterData = cBitmap;
			context.m_LoadCallBack = callBack;
			if( !this.dispatchLoadContent( context ))
			{
				this.m_TaskList.push( context );
			}
		}

		private function dispatchLoadContent( context:BmpLoadDataContext ):Boolean
		{
			var index:* = null;
			var urlLoader:BmpDataLoader = null;
			index = ( this.m_nLoaderCount - 1 );
			while( index > -1 )
			{
				urlLoader = this.m_Loaders[ index ];
				if( urlLoader.m_LoadContext == null )
				{
					urlLoader.loadData( context );
					return ( true );
				}
				index--;
			}
			return ( false );
		}

		private function onLoadComplete( evt:Event ):void
		{
			var urlLoader:BmpDataLoader = null;
			urlLoader = BmpDataLoader( evt.currentTarget );
			urlLoader.loadDataResult( urlLoader.data );
		}

		private function onLoadError( evt:Event ):void
		{
			var urlLoader:BmpDataLoader = null;
			urlLoader = BmpDataLoader( evt.currentTarget );
			urlLoader.loadDataResult( null );
		}
	}
}

/**
 * 
 * @author zhufeng
 * 
 */
class BmpLoadDataContext
{
	public var m_DataURL:String;
	public var m_LoadCallBack:Function;
	public var m_RequesterData:CloneableBitmap;
}

import flash.display.Bitmap;
import flash.display.Loader;
import flash.display.LoaderInfo;
import flash.events.Event;
import flash.events.IOErrorEvent;
import flash.net.URLLoader;
import flash.net.URLLoaderDataFormat;
import flash.net.URLRequest;
import flash.utils.ByteArray;

import __load__.__bitmap__.CloneableBitmap;
import __load__.__loaders__.BmpLoaderQueue;

/**
 * 
 * @author zhufeng
 * 
 */
class BmpDataLoader extends URLLoader
{
	private var m_Queue:BmpLoaderQueue;
	private var m_Loader:Loader;
	
	public var m_LoadContext:BmpLoadDataContext;
	
	public function BmpDataLoader( queue:BmpLoaderQueue )
	{
		this.dataFormat = URLLoaderDataFormat.BINARY;
		
		this.m_Queue = queue;
		this.m_Loader = new Loader();
		this.m_Loader.contentLoaderInfo.addEventListener( Event.COMPLETE, this.loaderWriteCompelte );
		this.m_Loader.contentLoaderInfo.addEventListener( IOErrorEvent.IO_ERROR, onIOError );
	}

	public function destruct():void
	{
		if( this.m_LoadContext )
		{
			this.loadBitmapResult( null );
		}
		this.m_Loader.contentLoaderInfo.removeEventListener( Event.COMPLETE, this.loaderWriteCompelte );
		this.m_Loader.contentLoaderInfo.removeEventListener( IOErrorEvent.IO_ERROR, onIOError );
		this.m_Loader = null;
		this.m_Queue = null;
	}

	public function loadData( context:BmpLoadDataContext ):void
	{
		this.m_LoadContext = context;
		load( new URLRequest( this.m_LoadContext.m_DataURL ));
	}

	public function loadDataResult( byte:ByteArray ):void
	{
		if(( byte ) && ( byte.length > 0 ))
		{
			this.m_Loader.loadBytes( byte );
		} else
		{
			this.loadBitmapResult( null );
		}
	}

	public function onIOError( e:IOErrorEvent ):void
	{
		this.loadBitmapResult( null );
	}
	
	private function loaderWriteCompelte( evt:Event ):void
	{
		var bitmap:Bitmap = null;
		var loaderInfo:LoaderInfo = null;
		loaderInfo = LoaderInfo( evt.currentTarget );
		bitmap = Bitmap( loaderInfo.content );
		loaderInfo.loader.unload();
		this.loadBitmapResult( bitmap );
		bitmap.bitmapData = null;
		bitmap = null;
	}

	private function loadBitmapResult( bitmap:Bitmap ):void
	{
		this.m_LoadContext.m_LoadCallBack( this.m_LoadContext.m_RequesterData, bitmap );
		this.m_LoadContext.m_LoadCallBack = null;
		this.m_LoadContext.m_RequesterData = null;
		this.m_LoadContext.m_DataURL = null;
		this.m_LoadContext = null;
		this.close();
		this.bytesTotal = 0;
		if( this.m_Queue.length > 0 )
		{
			this.loadData( this.m_Queue.shift());
		}
	}
}