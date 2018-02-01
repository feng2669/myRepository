package utils
{
	import flash.events.KeyboardEvent;
	import flash.events.TextEvent;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	import flash.ui.Keyboard;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;
	
	public class PasswordText extends TextField
	{
		public static const DELAY:Number = 1000;
		
		private var _password:String = "";
		private var _passwordChar:String = "*";
		private var idList:Array = [];

		public function PasswordText ()
		{
			super();
			border = true;
			type = TextFieldType.INPUT;
			width = 120;
			height = 22;
			addEventListener( KeyboardEvent.KEY_DOWN, keyDownHandler );
			addEventListener( TextEvent.TEXT_INPUT, textInputHandler );
		}

		public function get password ():String
		{
			return _password;
		}

		public function set password ( value:String ):void
		{
			_password = ( value ? value : "" );
			text = getDisplayText( _password.length );
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

			if ( selectionEndIndex - selectionBeginIndex > 0 )
			{
				_password = _password.substr( 0, selectionBeginIndex ) +
					_password.substr( selectionEndIndex );
			} else
			{
				if ( backspaceKey )
					_password = _password.substr( 0, selectionBeginIndex - 1 ) +
						_password.substr( selectionEndIndex );
				else
					_password = _password.substr( 0, selectionBeginIndex ) +
						_password.substr( selectionEndIndex + 1 );
			}
			idList.unshift( setTimeout( showPassword, DELAY ));
		}

		private function showPassword ():void
		{
			var displayText:String = getDisplayText( text ? text.length : 0 );
			var id:uint = idList[ 0 ];
			clearTimeout( id );
			idList.shift();
			text = displayText;
		}

		private function textInputHandler ( event:TextEvent ):void
		{
			_password = _password.substr( 0, selectionBeginIndex ) + event.text +
				_password.substr( selectionEndIndex );
			idList.unshift( setTimeout( showPassword, DELAY ));
		}
	}

}