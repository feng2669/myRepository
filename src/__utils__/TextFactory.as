package __utils__
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.GradientType;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import flash.text.Font;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import flash.text.TextLineMetrics;
	
	public class TextFactory
	{
		public static var DefalutColors:Array = [ "FFBF20", "FF0000", "00FF00", "FFFFFF" ];
		
		private static var DrawTextField:TextField;
		private static var DrawTextSrcRect:Rectangle;
		private static var DrawTextDestRect:Rectangle;
		private static var DrawTextDestMatrix:Matrix;
		
		private static var GradientTextDefalutAlpha:Array = [ 1, 1 ];
		private static var GradientTextDefalutColors:Array = [ 0xFFCC00, 0xCC6600 ];
		private static var GradientTextMatrix:Matrix = new Matrix();
		private static var GradientTextRatiosArray:Array = [ 0, 0xFF ];
		private static var GradientTextSprite:Sprite = new Sprite();
		private static var GradientTextShape:Shape = new Shape();
		private static var GradientTextSourceBmp:Bitmap = new Bitmap();

		public static function createGradientText( text:String, filters:Array = null, colors:Array = null, rotation:int = 90, gradientType :String = "", spreadMethod :String = "pad", bold:Boolean = false ):BitmapData
		{
			var bmd:BitmapData = createText( text, 0, bold, filters );
			var bmd_2:BitmapData = null;
			rotation = ( Math.PI * ( rotation / 180 ));
			GradientTextSourceBmp.bitmapData = createText( text, 0, bold, null );
			GradientTextMatrix.createGradientBox( bmd.width, bmd.height, rotation );
			if( !GradientTextSourceBmp.parent )
			{
				GradientTextSprite.addChild( GradientTextShape );
				GradientTextShape.cacheAsBitmap = true;
				GradientTextSprite.addChild( GradientTextSourceBmp );
				GradientTextSourceBmp.cacheAsBitmap = true;
				GradientTextShape.mask = GradientTextSourceBmp;
			}
			if( gradientType == "" )
			{
				gradientType = GradientType.LINEAR;
			}
			if( !colors )
			{
				colors = GradientTextDefalutColors;
			}
			GradientTextShape.graphics.clear();
			GradientTextShape.graphics.beginGradientFill( gradientType, colors, GradientTextDefalutAlpha, GradientTextRatiosArray, GradientTextMatrix, spreadMethod  );
			GradientTextShape.graphics.drawRect( 0, 0, bmd.width, bmd.height );
			GradientTextShape.graphics.endFill();
			GradientTextSprite.filters = filters;
			bmd_2 = new BitmapData( bmd.width, bmd.height, true, 0xFFFFFF );
			bmd_2.draw( GradientTextSprite );
			bmd.dispose();
			bmd = null;
			GradientTextSourceBmp.bitmapData.dispose();
			GradientTextSourceBmp.bitmapData = null;
			GradientTextSprite.filters = null;
			return ( bmd_2 );
		}

		public static function createHtmlText( text:String, filters:Array = null ):BitmapData
		{
			var bmd:BitmapData = null;
			rawSetHtmlText( text, filters );
			bmd = new BitmapData( DrawTextSrcRect.width, DrawTextSrcRect.height, true, 0 );
			if( filters )
			{
				DrawTextField.filters = filters;
			}
			bmd.draw( DrawTextField, null, null, null, DrawTextSrcRect );
			if( filters )
			{
				DrawTextField.filters = null;
			}
			return ( bmd );
		}

		public static function createText( text:String, color:int = 16777214, bold:Boolean = false, filters:Array = null ):BitmapData
		{
			var htext:String = "";
			if(( color == 16777214 ) && ( DrawTextField ))
			{
				color = int( DrawTextField.defaultTextFormat.color );
			}
			htext = (( "<FONT COLOR='#" + UIHlp.IntToHex( color )) + "'>" );
			if( bold )
			{
				htext = ( htext + (( "<B>" + text ) + "</B></FONT>" ));
			} else
			{
				htext = ( htext + ( text + "</FONT>" ));
			}
			return ( createHtmlText( htext, filters ));
		}

		public static function get defaultTextFormat():TextFormat
		{
			if( !DrawTextField )
			{
				createDrawTextField();
			}
			return ( DrawTextField.defaultTextFormat );
		}


		public static function set defaultTextFormat( _arg1:TextFormat ):void
		{
			if( !DrawTextField )
			{
				createDrawTextField();
			}
			DrawTextField.defaultTextFormat = _arg1;
		}

		public static function drawHtmlTextOnBitmap( bmd:BitmapData, text:String, rect:Rectangle = null, align:String = null, filters:Array = null ):void
		{
			var rectangle:Rectangle = rawSetHtmlText( text, filters );
			if( !rect )
			{
				rect = DrawTextDestRect;
				rect.x = 0;
				rect.y = 0;
				rect.width = bmd.width;
				rect.height = bmd.height;
				DrawTextDestMatrix.tx = 0;
				DrawTextDestMatrix.ty = 0;
			} else
			{
				DrawTextDestMatrix.tx = rect.x;
				DrawTextDestMatrix.ty = rect.y;
			}
			if( align )
			{
				if( align == TextFormatAlign.CENTER )
				{
					if( rect.width >= rectangle.width )
					{
						DrawTextDestMatrix.tx = ( DrawTextDestMatrix.tx + (( rect.width - rectangle.width ) / 2 ));
					} else
					{
						rectangle.x = ( rectangle.x + (( rectangle.width - rect.width ) / 2 ));
						rectangle.width = rect.width;
					}
				} else
				{
					if( align == TextFormatAlign.RIGHT )
					{
						if( rect.width >= rectangle.width )
						{
							DrawTextDestMatrix.tx = ( DrawTextDestMatrix.tx + ( rect.width - rectangle.width ));
						} else
						{
							rectangle.x = ( rectangle.x + ( rectangle.width - rect.width ));
							rectangle.width = rect.width;
						}
					}
				}
			}
			if( rectangle.width > rect.width )
			{
				rectangle.width = rect.width;
			}
			if( rectangle.height > rect.height )
			{
				rectangle.height = rect.height;
			}
			rectangle.width = ( rectangle.width + DrawTextDestMatrix.tx );
			rectangle.height = ( rectangle.height + DrawTextDestMatrix.ty );
			if( filters )
			{
				DrawTextField.filters = filters;
			}
			bmd.draw( DrawTextField, DrawTextDestMatrix, null, null, rectangle );
			if( filters )
			{
				DrawTextField.filters = null;
			}
		}

		public static function drawTextOnBitmap( bmd:BitmapData, text:String, color:int = 16777214, bold:Boolean = false, rect:Rectangle = null, align:String = null, filters:Array = null ):void
		{
			var htext:String = null;
			if(( color == 16777214 ) && ( DrawTextField ))
			{
				color = int( DrawTextField.defaultTextFormat.color );
			}
			htext = (( "<FONT COLOR='#" + UIHlp.IntToHex( color )) + "'>" );
			if( bold )
			{
				htext = ( htext + (( "<B>" + text ) + "</B></FONT>" ));
			} else
			{
				htext = ( htext + ( text + "</FONT>" ));
			}
			return ( drawHtmlTextOnBitmap( bmd, htext, rect, align, filters ));
		}

		public static function isFontAvailable( fontName:String, flag:Boolean = false ):Boolean
		{
			var font:Font = null;
			var fontList:Array = Font.enumerateFonts( !( flag ));
			for each( font in fontList )
			{
				if( font.fontName.localeCompare( fontName ) == 0 )
				{
					return ( true );
				}
			}
			return ( false );
		}

		public static function get lastText():String
		{
			if( !DrawTextField )
			{
				return ( "" );
			}
			return ( DrawTextField.text );
		}

		private static function createDrawTextField():void
		{
			DrawTextField = new TextField();
			DrawTextField.autoSize = TextFieldAutoSize.LEFT;
			DrawTextField.multiline = true;
			DrawTextSrcRect = new Rectangle();
			DrawTextDestRect = new Rectangle();
			DrawTextDestMatrix = new Matrix();
		}

		private static function rawSetHtmlText( text:String, _arg2:Array ):Rectangle
		{
			var textLineMetrics :TextLineMetrics = null;
			var textLine:int = 0;
			if( !DrawTextField )
			{
				createDrawTextField();
			}
			DrawTextField.htmlText = text;
			DrawTextSrcRect.x = 2147483647;
			DrawTextSrcRect.y = 2;
			DrawTextSrcRect.width = 0;
			DrawTextSrcRect.height = 0;
			while( textLine < DrawTextField.numLines )
			{
				textLineMetrics = DrawTextField.getLineMetrics( textLine );
				if( DrawTextSrcRect.x > textLineMetrics.x )
				{
					DrawTextSrcRect.x = textLineMetrics.x;
				}
				if( DrawTextSrcRect.width < ( textLineMetrics.width + 2 ))
				{
					DrawTextSrcRect.width = ( textLineMetrics.width + 2 );
				}
				DrawTextSrcRect.height = ( DrawTextSrcRect.height + (( textLineMetrics.height + textLineMetrics.descent ) + textLineMetrics.leading ));
				textLine++;
			}
			if( _arg2 )
			{
				DrawTextSrcRect.x--;
				DrawTextSrcRect.y--;
				DrawTextSrcRect.width = ( DrawTextSrcRect.width + 2 );
				DrawTextSrcRect.height = ( DrawTextSrcRect.height + 2 );
			}
			return ( DrawTextSrcRect );
		}
	}
}