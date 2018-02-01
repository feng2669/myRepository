package __load__.__bitmap__
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.events.Event;

	public class CloneableBitmap extends Bitmap
	{
		public var loaded:Boolean = false;
		public var url:String="";
		
		override public function set bitmapData( bmp:BitmapData ):void
		{
			this.loaded = true;
			super.bitmapData = bmp;
			dispatchEvent( new Event( Event.CHANGE ));
		}

		public function clone():CloneableBitmap
		{
			var cBitmap:CloneableBitmap = new CloneableBitmap();
			if( bitmapData )
			{
				cBitmap.bitmapData = bitmapData;
			} else
			{
				if (this.loaded == false)
				{
					addEventListener( Event.CHANGE, cBitmap.sourceLoadComplete );
				}
			}
			cBitmap.loaded = this.loaded;
			return ( cBitmap );
		}

		private function sourceLoadComplete( evt:Event ):void
		{
			var cBitmap:CloneableBitmap = null;
			cBitmap = CloneableBitmap( evt.target );
			cBitmap.removeEventListener( evt.type, this.sourceLoadComplete );
			this.bitmapData = cBitmap.bitmapData;
		}
	}
}