package __utils__
{
	import flash.display.Bitmap;
	import flash.display.Sprite;
	
	import __utils__.TextFactory;

	public class CustomButton extends Sprite
	{
		protected var m_caption:String;
		protected var m_data:*;
		
		private var _bitmap:Bitmap;
		
		public function CustomButton()
		{
			this._bitmap = new Bitmap();
			addChild(this._bitmap);
		}
		
		public function get caption():String
		{
			return this.m_caption;
		}
		
		public function set caption(value:String):void
		{
			if (this.m_caption != value)
			{
				this.m_caption = value;
				if (this._bitmap.bitmapData)
				{
					this._bitmap.bitmapData.dispose();
					this._bitmap.bitmapData = null;
				}
				this._bitmap.bitmapData = TextFactory.createText(value, 0xFFFFFF);
			}
		}
		
		public function set userData(data:*):void
		{
			this.m_data = data;
		}
		
		public function get userData():*
		{
			return this.m_data;
		}
		
	}
}