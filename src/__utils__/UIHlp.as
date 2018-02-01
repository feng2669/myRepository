package __utils__
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.InteractiveObject;
	import flash.display.Stage;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	
	public class UIHlp
	{
		/**
		 * 16进制
		 */		
		private static const HexCharTable:Array = [ "0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "A", "B", "C", "D", "E", "F" ];
		
		/**
		 * 毫秒
		 */		
		private static const DayPerMilSec:int = ((( 24 * 60 ) * 60 ) * 1000 );//天：86400000
		/**
		 * 毫秒
		 */		
		private static const HourPerMilSec:int = (( 60 * 60 ) * 1000 );//时：3600000
		/**
		 * 毫秒
		 */		
		private static const MinPerMilSec:int = ( 60 * 1000 ); //分：60000
		/**
		 * 毫秒
		 */		
		private static const secPerMilSec:int = ( 1 * 1000 ); //秒：1000

		public static function HexToInt( value:String ):uint
		{
			var index:int = 0;
			var result:uint = 0;
			var unicode:Number = 0;
			while( index < 8 )
			{
				if( index >= value.length )
				{
					break;
				}
				result = ( result << 4 );
				unicode = value.charCodeAt( index );
				if(( unicode >= 48 ) && ( unicode <= 57 ))
				{
					result = ( result | ( unicode - 48 ));
				} else
				{
					if(( unicode >= 65 ) && ( unicode <= 70 ))
					{
						result = ( result | (( unicode - 65 ) + 10 ));
					} else
					{
						if(( unicode >= 97 ) && ( unicode <= 102 ))
						{
							result = ( result | (( unicode - 97 ) + 10 ));
						} else
						{
							break;
						}
					}
				}
				index++;
			}
			return ( result );
		}

		public static function IntToHex( value:uint ):String
		{
			return ( HexCharTable[(( value >> 28 ) & 15 )] + HexCharTable[(( value >> 24 ) & 15 )] + HexCharTable[(( value >> 20 ) & 15 )] + HexCharTable[(( value >> 16 ) & 15 )] + HexCharTable[(( value >> 12 ) & 15 )] + HexCharTable[(( value >> 8 ) & 15 )] + HexCharTable[(( value >> 4 ) & 15 )] + HexCharTable[( value & 15 )]);
		}

		public static function controlMouseEnabled( display:InteractiveObject ):Boolean
		{
			var parent:DisplayObjectContainer = null;
			if( !display.mouseEnabled )
			{
				return ( false );
			}
			display = display.parent;
			while( display )
			{
				parent = ( display as DisplayObjectContainer );
				if((( parent ) && ( !( parent.mouseChildren ))))
				{
					return ( false );
				}
				display = display.parent;
			}
			return ( true );
		}

		public static function hasInputFocused( stage:Stage ):Boolean
		{
			var text:TextField = null;
			if( !stage )
			{
				return ( false );
			}
			text = ( stage.focus as TextField );
			if( !text )
			{
				return ( false );
			}
			if( text.type != TextFieldType.INPUT )
			{
				return ( false );
			}
			return ( true );
		}

		public static function isDeepChildren( parent:DisplayObjectContainer, child:DisplayObject ):Boolean
		{
			child = child.parent;
			while( child )
			{
				if( child == parent )
				{
					return ( true );
				}
				child = child.parent;
			}
			return ( false );
		}

		public static function isWhitespace( value:String ):Boolean
		{
			if( value.length > 1 )
			{
				return ( false );
			}
			switch( value.charCodeAt( 0 ))
			{
				case 9:
				case 10:
				case 11:
				case 12:
				case 13:
				case 32:
				case 133:
				case 160:
				case 5760:
				case 6158:
				case 8192:
				case 8193:
				case 8194:
				case 8195:
				case 8196:
				case 8197:
				case 8198:
				case 8199:
				case 8200:
				case 8201:
				case 8202:
				case 8232:
				case 8233:
				case 8239:
				case 8287:
				case 12288:
					return ( true );
				default:
					return ( false );
			}
		}

		/**
		 * 
		 * @param value		毫秒
		 * @param flag			按位与运算
		 * @return 
		 * 
		 */		
		public static function tickCountToStr( value:Number, flag:int=30,  format:String=" - "):String
		{
			value = (value < 0) ? ( value * -1 ) : value;
			var result:String = "";
			var remainder:int = 0;
			remainder = int( value / DayPerMilSec );
			if( flag & 16 )
			{
				value = ( value - ( remainder * DayPerMilSec ));
				result = ( result + ( remainder + format ));
			}
			remainder = int( value / HourPerMilSec );
			if( flag & 8 )
			{
				value = ( value - ( remainder * HourPerMilSec ));
				result = ( result + ( remainder + format ));
			}
			remainder = int( value / MinPerMilSec );
			if( flag & 4 )
			{
				value = ( value - ( remainder * MinPerMilSec ));
				result = ( result + ( remainder + format ));
			}
			remainder = int(( value / secPerMilSec ));
			if( flag & 2 )
			{
				value = ( value - ( remainder * secPerMilSec ));
				result = ( result + remainder );
				if( flag & 1 )
				{
					result = ( result + ( "." + int( value )));
				}
			}
			return ( result );
		}

		public static function tickCountToStr2( value:Number ):String
		{
			var result:String = "";
			var remainder:int = 0;
			remainder = int(( value / HourPerMilSec ));
			if( remainder > 0 )
			{
				value = ( value - ( remainder * HourPerMilSec ));
				if( remainder >= 10 )
				{
					result = ( result + ( remainder + ":" ));
				} else
				{
					result = ( result + (( "0" + remainder ) + ":" ));
				}
			} else
			{
				result = ( result + ( "00" + ":" ));
			}
			remainder = int(( value / MinPerMilSec ));
			if( remainder > 0 )
			{
				value = ( value - ( remainder * MinPerMilSec ));
				if( remainder >= 10 )
				{
					result = ( result + ( remainder + ":" ));
				} else
				{
					result = ( result + (( "0" + remainder ) + ":" ));
				}
			} else
			{
				result = ( result + ( "00" + ":" ));
			}
			if( value > 0 )
			{
				remainder = int(( value / 1000 ));
				value = ( value - ( remainder * 1000 ));
				if( remainder >= 10 )
				{
					result = ( result + remainder );
				} else
				{
					result = ( result + ( "0" + remainder ));
				}
			} else
			{
				result = ( result + "00" );
			}
			return ( result );
		}

		public static function trim( value:String ):String
		{
			var index:int = 0;
			var len:int = value.length;;
			var offset:int = 0;
			while( index < len )
			{
				if( isWhitespace( value.charAt( index )))
				{
					offset++;
				} else
				{
					break;
				}
				index++;
			}
			index = ( len - 1 );
			while( index > 0 )
			{
				if( isWhitespace( value.charAt( index )))
				{
					len--;
				} else
				{
					break;
				}
				index--;
			}
			return ( value.substring( offset, len ));
		}
	}
}