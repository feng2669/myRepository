package __load__.__loaders__
{
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;

	public dynamic class BinLoaderQueue extends Array
	{
		private var m_SiteURL:String;
		private var m_nLoaderCount:int;
		private var m_Loaders:Array;

		public function BinLoaderQueue ( siteURL:String, countNum:uint = 4 )
		{
			this.m_SiteURL = siteURL;
			this.m_nLoaderCount = countNum;
			this.m_Loaders = [];
			var index:int = 0;
			var urlLoader:BinDataLoader = null;
			while ( index < countNum )
			{
				urlLoader = new BinDataLoader();
				urlLoader.addEventListener( Event.COMPLETE, this.onLoadComplete );
				this.m_Loaders.push( urlLoader );
				index++;
			}
		}
		
		private function onLoadComplete ( evt:Event ):void
		{
			var urlLoader:BinDataLoader = null;
			urlLoader = BinDataLoader( evt.currentTarget );
			urlLoader.loadDataResult( urlLoader.data );
			if ( length > 0 )
			{
				urlLoader.loadData( this.shift());
			}
		}

		private function onLoadError ( evt:Event ):void
		{
			var urlLoader:BinDataLoader = null;
			urlLoader = BinDataLoader( evt.currentTarget );
			urlLoader.loadDataResult( null );
			if ( length > 0 )
			{
				urlLoader.loadData( this.shift());
			}
		}

		public function requestLoad ( url:String, _arg2:Object, callBack:Function ):void
		{
			var context:BinLoadDataContext = null;
			context = new BinLoadDataContext();
			context.m_DataURL = ( this.m_SiteURL + url );
			context.m_RequesterData = _arg2;
			context.m_LoadCallBack = callBack;
			if ( !this.dispatchLoadContent( context ))
			{
				this.push( context );
			}
		}

		private function dispatchLoadContent ( context:BinLoadDataContext ):Boolean
		{
			var index:int = 0;
			var urlLoader:BinDataLoader = null;
			index = ( this.m_nLoaderCount - 1 );
			while ( index > -1 )
			{
				urlLoader = this.m_Loaders[ index ];
				if ( urlLoader.m_LoadContext == null )
				{
					urlLoader.loadData( context );
					return ( true );
				}
				index--;
			}
			return ( false );
		}

		public function destruct ():void
		{
			var index:int = 0;
			var urlLoader:BinDataLoader = null;
			while ( index < this.m_Loaders.length )
			{
				urlLoader = BinDataLoader( this.m_Loaders[ index ]);
				urlLoader.removeEventListener( Event.COMPLETE, this.onLoadComplete );
				urlLoader.removeEventListener( IOErrorEvent.IO_ERROR, this.onLoadError );
				urlLoader.removeEventListener( SecurityErrorEvent.SECURITY_ERROR, this.onLoadError );
				urlLoader.destruct();
				index++;
			}
			this.m_Loaders.length = 0;
			this.m_Loaders = null;
			this.length = 0;
		}

	}
}

class BinLoadDataContext
{
	public var m_DataURL;
	public var m_RequesterData;
	public var m_LoadCallBack;
}

import flash.net.URLLoader;
import flash.net.URLLoaderDataFormat;
import flash.net.URLRequest;

class BinDataLoader extends URLLoader
{
	public var m_LoadContext;

	public function BinDataLoader ()
	{
		this.dataFormat = URLLoaderDataFormat.BINARY;
	}

	public function loadData ( context:BinLoadDataContext ):void
	{
		this.m_LoadContext = context;
		load( new URLRequest( context.m_DataURL ));
	}

	public function loadDataResult ( _arg1:Object ):void
	{
		this.m_LoadContext.m_LoadCallBack( this.m_LoadContext.m_RequesterData, _arg1 );
		this.m_LoadContext.m_RequesterData = null;
		this.m_LoadContext.m_LoadCallBack = null;
		this.m_LoadContext.m_DataURL = null;
		this.m_LoadContext = null;
		this.bytesTotal = 0;
		this.close();
	}

	public function destruct ():void
	{
		if ( this.m_LoadContext )
		{
			this.loadDataResult( null );
		}
	}

}