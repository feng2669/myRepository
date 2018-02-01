package __utils__
{
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.utils.Dictionary;
	
	public class DebuggerWin extends Sprite
	{
		public static const MAX_NUMLINES:int = 1000;
		
		public static const TEXTFIELD_INIT_Y:int = 30;
		public static const TEXTFIELD_W:int = 250;
		public static const TEXTFIELD_H:int = 500;
		
		public static const TYPE_COMMON:int = 0;
		public static const TYPE_MOVE:int = 1;
		public static const TYPE_KEY:int = 2;
		public static const TYPE_FONT:int = 3;
		public static const TYPE_ERROR:int = 4;
		public static const TYPE_EVENT:int = 5;
		public static const TYPE_NPC_TALK:int = 6;
		public static const TYPE_SOCKET:int = 7;
		public static const TYPE_SKILL:int = 8;
		public static const TYPE_EVENT_LOGIC:int = 9;
		public static const TYPE_LOOP_EFFECT:int = 10;
		
		private static var _instance:DebuggerWin;
		private static var _traceState:int = 1;
		
		public static function getTraceState ( state:int ):Boolean
		{
			return ( Boolean(( _traceState >> state ) & 1 ));
		}
		
		public static function init ( parent:DisplayObjectContainer ):void
		{
			if ( !_instance )
			{
				_instance = new DebuggerWin();
				visible = false;
				traceMsg( "输出面板" );
			}
			parent.addChild( _instance );
		}
		
		public static function switchAllTraceState ( boo:Boolean ):void
		{
			_traceState = ( boo ? 0xFFFFFF : 0 );
		}
		
		public static function switchTraceState ( state:int ):void
		{
			var boo:Boolean;
			
			if ( state < 0 )
			{
				switchAllTraceState(((( state == -1 )) ? true : false ));
				return;
			}
			boo = !(( _traceState >> state ) & 1 );
			
			if ( boo )
			{
				_traceState = (( 1 << state ) | _traceState );
			} else
			{
				_traceState = ((( 1 << state ) ^ 0xFFFFFF ) & _traceState );
			}
		}
		
		public static function toggleVisible ():void
		{
			if ( _instance )
			{
				visible = !( _instance.visible );
			}
		}
		
		public static function traceEachIn ( obj:Object ):void
		{
			if ( !_instance )
			{
				return;
			}
			var index:* = null;
			var msg:String = "";
			
			for ( index in obj )
			{
				msg = ( msg + ( "<font color='#00FF00'>" + index + "</font>=" + obj[ index ] + "<BR>" ));
			}
			traceMsg( msg );
		}
		
		public static function traceMsg ( _arg1:String, state:int = 0, _arg3:String = "FFFFFF" ):void
		{
			if ( !_instance )
			{
				_instance = new DebuggerWin();
			}
			
			if ( !getTraceState( state ))
			{
				return;
			}
			_instance.addMsg( _arg1, state, _arg3 );
		}
		
		public static function set visible ( boo:Boolean ):void
		{
			if ( _instance )
			{
				_instance.visible = boo;
				
				if ( boo )
				{
					if ( _instance.parent )
					{
						_instance.parent.setChildIndex( _instance, ( _instance.parent.numChildren - 1 ));
					}
				}
			}
		}
		
		public function DebuggerWin ()
		{
			this._clearBtnList = new Dictionary();
			this._titleList = new Dictionary();
			this._txtList = [];
			
			addEventListener( MouseEvent.MOUSE_DOWN, this.onMouseDown );
			addEventListener( MouseEvent.MOUSE_UP, this.onMouseUp );
		}
		
		private var _clearBtnList:Dictionary;
		private var _titleList:Dictionary;
		private var _txtList:Array;
		
		private var m_boDraging:Boolean;
		
		private function addMsg ( value:String, index:int = 0, color:String = "FFFFFF" ):void
		{
			var text:TextField = null;
			
			if ( !this._txtList[ index ])
			{
				this.createTestField( index );
			}
			text = this._txtList[ index ];
			text.htmlText = ( text.htmlText + ( "<font color='#" + color + "'>" + value + "</font><BR>" ));
			
			if ( text.numLines >= MAX_NUMLINES )
			{
				text.htmlText = "";
			}
			text.scrollV = ( text.scrollV + Math.ceil(( value.length / 16 )));
		}
		
		private function createTestField ( index:int ):void
		{
			var btn:* = null;
			var bitmap:Bitmap = null;
			var text:TextField = null;
			text = new TextField();
			text.width = TEXTFIELD_W;
			text.height = TEXTFIELD_H;
			text.y = TEXTFIELD_INIT_Y;
			text.wordWrap = true;
			text.multiline = true;
			text.name = index.toString();
			this.addChild( text );
			this._txtList[ index ] = text;
			bitmap = new Bitmap( TextFactory.createHtmlText( this.getFieldTitleByType( index ), FilterUtils.DefaultTextFilters ));
			bitmap.y = 5;
			this.addChild( bitmap );
			this._titleList[ index ] = bitmap;
			btn = new CustomButton();
			btn.y = bitmap.y;
			btn.userData = index;
			btn.caption = "清除";
			btn.addEventListener( MouseEvent.CLICK, this.onClear );
			this.addChild( btn );
			this._clearBtnList[ index ] = btn;
			this.updateLayout();
		}
		
		private function getFieldTitleByType ( type:int ):String
		{
			switch ( type )
			{
				case TYPE_COMMON:
					return ( "<font color='#FFCC00'>普通输出</font>" );
				case TYPE_MOVE:
					return ( "<font color='#FFCC00'>移动输出</font>" );
				case TYPE_KEY:
					return ( "<font color='#FFCC00'>键值输出</font>" );
				case TYPE_FONT:
					return ( "<font color='#FFCC00'>字体输出</font>" );
				case TYPE_ERROR:
					return ( "<font color='#FFCC00'>错误输出</font>" );
				case TYPE_EVENT:
					return ( "<font color='#FFCC00'>事件输出</font>" );
				case TYPE_NPC_TALK:
					return ( "<font color='#FFCC00'>NPC对话输出</font>" );
				case TYPE_SOCKET:
					return ( "<font color='#FFCC00'>socket输出</font>" );
				case TYPE_SKILL:
					return ( "<font color='#FFCC00'>技能输出</font>" );
				case TYPE_EVENT_LOGIC:
					return ( "<font color='#FFCC00'>逻辑事件输出</font>" );
			}
			return ( "类型" );
		}
		
		private function onClear ( _arg1:MouseEvent ):void
		{
			var text:TextField = null;
			var index:int = int( CustomButton( _arg1.currentTarget ).userData );
			text = this._txtList[ index ];
			
			if ( text )
			{
				text.htmlText = "";
			}
		}
		
		private function onMouseDown ( evt:MouseEvent ):void
		{
			if ( parent )
			{
				parent.setChildIndex( this, ( parent.numChildren - 1 ));
			}
			
			if ( evt.target == this )
			{
				startDrag();
				this.m_boDraging = true;
			}
		}
		
		private function onMouseUp ( evt:MouseEvent ):void
		{
			if ( this.m_boDraging )
			{
				stopDrag();
				this.m_boDraging = false;
				this.x = int( x );
				this.y = int( y );
			}
		}
		
		private function updateLayout ():void
		{
			var index:int = 0;
			var offsetX:Number = 5;
			var text:TextField = null;
			var bitmap:Bitmap = null;
			
			for each ( text in this._txtList )
			{
				if ( text )
				{
					index = int( text.name );
					text.x = offsetX;
					bitmap = ( this._titleList[ index ] as Bitmap );
					
					if ( bitmap )
					{
						bitmap.x = offsetX;
						DisplayObject( this._clearBtnList[ index ]).x = ( offsetX + TEXTFIELD_W - 50 );
					}
					offsetX = ( offsetX + ( TEXTFIELD_W + 5 ));
				}
			}
			this.width = offsetX;
			this.graphics.clear();
			this.graphics.lineStyle( 1, 0xFFFF );
			this.graphics.beginFill( 0, 0.8 );
			this.graphics.drawRect( 0, 0, offsetX, this.height + 5 );
			this.graphics.endFill();
			this.graphics.moveTo( 0, ( TEXTFIELD_INIT_Y - 5 ));
			this.graphics.lineTo( offsetX, ( TEXTFIELD_INIT_Y - 5 ));
		}
	}
}