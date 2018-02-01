package __load__.Packs.BitmapPack.Internal
{
	import flash.events.Event;
	import flash.display.LoaderInfo;
	import flash.display.Bitmap;
	import flash.utils.ByteArray;

	public dynamic class MDPBitmapDataLoadQueue extends Array
	{
		private var IdleLoaderList = [];

		public function MDPBitmapDataLoadQueue ( _arg1:int = 2 )
		{
			var _local3:* = null;
			var _local2:* = null;
			this.IdleLoaderList = [];
			_local2 = 0;

			while ( _local2 < _arg1 )
			{
				_local3 = new MDPBitmapDataLoader();
				_local3.contentLoaderInfo.addEventListener( Event.COMPLETE, this.loadBitmapDataComplete );
				this.IdleLoaderList.push( _local3 );
				_local2++;
			};
		}

		private function loadBitmapDataComplete ( e:Event ):void
		{
			var _local4:* = null;
			var _local3:* = null;
			var _local2:* = null;
			var info:* = null;
			var ldi:* = LoaderInfo( e.currentTarget );
			var ldr:* = MDPBitmapDataLoader( ldi.loader );
			info = ldr.CurrentLoadInfo;
			var bmp:* = Bitmap( ldi.content );

			try
			{
				info.CallBack( bmp.bitmapData );
			} finally
			{
				ldr.unload();
				bmp.bitmapData = null;
				info.Stream = null;
				info.CallBack = null;

				if ( length > 0 )
				{
					ldr.loadNextRequest( pop());
				} else
				{
					ldr.CurrentLoadInfo = null;
					this.IdleLoaderList.push( ldr );
				};
			};
		}

		public function requestLoadBitmapData ( _arg1:ByteArray, _arg2:int, _arg3:int, _arg4:Function ):void
		{
			var _local7:* = null;
			var _local6:* = null;
			var _local5:* = null;
			_local5 = 0;
			_local6 = null;
			_local7 = new MDPLoadBitmapDataInfo();
			_local7.CallBack = _arg4;
			_local7.Position = _arg2;
			_local7.Size = _arg3;
			_local7.Stream = _arg1;

			if ( this.IdleLoaderList.length )
			{
				_local6 = this.IdleLoaderList.pop();
				_local6.loadNextRequest( _local7 );
				return;
			};
			push( _local7 );
		}

	}
} //package wylib.Packs.BitmapPack.Internal

import flash.display.Loader;
import flash.utils.ByteArray;

class MDPBitmapDataLoader extends Loader
{

	/*private*/
	var Stream;

	public var CurrentLoadInfo;

	public function MDPBitmapDataLoader ()
	{
		this.Stream = new ByteArray();
	}

	public function loadNextRequest ( _arg1:MDPLoadBitmapDataInfo ):void
	{
		this.CurrentLoadInfo = _arg1;
		this.Stream.length = 0;
		this.Stream.writeBytes( _arg1.Stream, _arg1.Position, _arg1.Size );
		loadBytes( this.Stream );
		_arg1.Stream = null;
	}

}

class MDPLoadBitmapDataInfo
{

	public var Stream;

	public var Size:int;

	public var CallBack;

	public var Position:int;

}
