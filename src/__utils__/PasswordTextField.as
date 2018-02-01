package utils
{
	import flash.events.FocusEvent;
	import flash.events.KeyboardEvent;
	import flash.events.TextEvent;
	import flash.text.TextField;
	import flash.ui.Keyboard;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;
	
	/**
	 * 密码输入框：输入密码 1 秒后用符号 * 替代！
	 * @author zhufeng
	 */	
	public class PasswordTextField
	{
		public static const DELAY:Number = 100;
		
		private var _password:String = "";
		private var _passwordChar:String = "*";
		
		private var timerID:Array = [];
		
		private var _textField:TextField;
		private var _text:String;
		private var _func:Function;

		public function PasswordTextField (textField:TextField, callBack:Function=null)
		{
			this._textField = textField;
			this._text = this._textField.text;
			this._func = callBack;
			
			this._textField.addEventListener( KeyboardEvent.KEY_DOWN, keyDownHandler );
			this._textField.addEventListener( TextEvent.TEXT_INPUT, textInputHandler );
			this._textField.addEventListener(FocusEvent.FOCUS_IN, focus_in);
			this._textField.addEventListener(FocusEvent.FOCUS_OUT, focus_out);
		}
		
		private function focus_in (evt:FocusEvent):void
		{
			if (this._textField.text == this._text)
			{
				this._textField.text = "";
			}
		}
		
		private function focus_out (evt:FocusEvent):void
		{
			if (this._textField.text == "")
			{
				this._textField.text = this._text;
			}
		}

		public function get password ():String
		{
			return _password;
		}

		public function set password ( value:String ):void
		{
			_password = ( value ? value : "" );
			this._textField.text = getDisplayText( _password.length );
		}

		public function get passwordChar ():String
		{
			return _passwordChar;
		}

		public function set passwordChar ( value:String ):void
		{
			_passwordChar = value;
		}

		private function getDisplayText ( length:uint ):String
		{
			var displayText:String = "";
			for ( var i:int = 0; i < length; i++ )
				displayText = displayText + passwordChar;
			return displayText;
		}

		private function keyDownHandler ( event:KeyboardEvent ):void
		{
			var backspaceKey:Boolean = ( event.keyCode == Keyboard.BACKSPACE );
			var deleteKey:Boolean = ( event.keyCode == Keyboard.DELETE );

			if ( !backspaceKey && !deleteKey )
				return;

			if ( this._textField.selectionEndIndex - this._textField.selectionBeginIndex > 0 )
			{
				_password = _password.substr( 0, this._textField.selectionBeginIndex ) +
					_password.substr( this._textField.selectionEndIndex );
			} else
			{
				if ( backspaceKey )
					_password = _password.substr( 0, this._textField.selectionBeginIndex - 1 ) +
						_password.substr( this._textField.selectionEndIndex );
				else
					_password = _password.substr( 0, this._textField.selectionBeginIndex ) +
						_password.substr( this._textField.selectionEndIndex + 1 );
			}
			timerID.unshift( setTimeout( showPassword, DELAY ));
		}

		private function showPassword ():void
		{
			var displayText:String = getDisplayText( this._textField.text ? this._textField.text.length : 0 );
			var id:uint = timerID[ 0 ];
			clearTimeout( id );
			timerID.shift();
			this._textField.text = displayText;
			if ( this._func )
			{
				this._func(this.password, this._text);
			}
		}

		private function textInputHandler ( event:TextEvent ):void
		{
			var str:String = "";
			str = _password.substr( 0, this._textField.selectionBeginIndex ) + event.text +
				_password.substr( this._textField.selectionEndIndex );
			if (str.length > this._textField.maxChars)
			{
				return;
			}
			if (str == "")
			{
				_password = this._text;
			}
			_password = str;
			timerID.push( setTimeout( showPassword, DELAY ));
		}
	}

}