package __load__.CBP
{
	import flash.utils.ByteArray;
	import flash.utils.Endian;

	public class CBPReader
	{
		public static const v_null:int = 0;
		public static const v_boolean:int = 1;
		public static const v_number:int = 2;
		public static const v_string:int = 3;
		public static const v_object:int = 4;

		private var m_TopSign:Boolean = true;
		private var m_sNamePath:String;
		private var m_TypeNames:Vector.<NamedType>;
		private var m_oTopObject;

		public function CBPReader ()
		{
			this.m_sNamePath = "";
			this.m_TypeNames = new Vector.<NamedType>();
		}
		
		public function clearTypes ():void
		{
			this.m_TypeNames.length = 0;
		}

		public function registeType ( reg:RegExp, clas:Class ):void
		{
			this.m_TypeNames.push( new NamedType( reg, clas ));
		}

		protected function CreateObject ( s:String ):Object
		{
			var index:int = 0;
			var nt:NamedType = null;
			index = ( this.m_TypeNames.length - 1 );
			while ( index > -1 )
			{
				nt = this.m_TypeNames[ index ];
				if ( nt.name.test( s ))
				{
					return ( new nt.type());
				}
				index--;
			}

			if ( s != "" )
			{
				trace(( "尚未注册类型“" + s ) + "”，将使用动态类型Object创建" );
			}
			return {};
		}

		protected function readObject ( byteArray:ByteArray, obj:Object ):void
		{
			var index:int;
			var sub_obj:Object;
			var value:*;
			var key:String;
			var key_len:int;
			var value_type:int;
			key_len = byteArray.readUnsignedByte();//key的长度
			value_type = byteArray.readUnsignedByte();//value的类型
			switch ( value_type )
			{
				case v_null:
					value = null;
					byteArray.position = ( byteArray.position + 8 );
					key = byteArray.readUTFBytes( key_len );
					obj[ key ] = value;
					return;
				case v_boolean:
					value = byteArray.readBoolean();
					byteArray.position = ( byteArray.position + 7 );
					key = byteArray.readUTFBytes( key_len );
					obj[ key ] = value;
					return;
				case v_number:
					value = byteArray.readDouble();
					key = byteArray.readUTFBytes( key_len );
					obj[ key ] = value;
					return;
				case v_string:
					value = byteArray.readUnsignedInt();
					byteArray.position = ( byteArray.position + 4 );
					key = byteArray.readUTFBytes( key_len );
					obj[ key ] = byteArray.readUTFBytes( int( value ));
					return;
				case v_object:
					value = byteArray.readUnsignedInt();
					byteArray.position = ( byteArray.position + 4 );
					key = byteArray.readUTFBytes( key_len );
					if ( this.m_sNamePath.length > 0 )
					{
						this.m_sNamePath = ( this.m_sNamePath + ( "." + key ));
					} else
					{
						this.m_sNamePath = key;
					}
					sub_obj = this.CreateObject( this.m_sNamePath );//递归。。。
					obj[ key ] = sub_obj;
					index = 0;
					while ( index < value )
					{
						this.readObject( byteArray, sub_obj );
						index++;
					}
					if ( this.m_sNamePath.length == key_len )
					{
						this.m_sNamePath = "";
					} else
					{
						this.m_sNamePath = this.m_sNamePath.substr( 0, (( this.m_sNamePath.length - key_len ) - 1 ));
					}
					return;
			}
		}

		public function readCBP ( byteArray:ByteArray, obj:Object = null ):Object
		{
			var byte:ByteArray;
			var len:int;
			var header:int;
			var version:int;
			this.m_sNamePath = "";
			byteArray.endian = Endian.LITTLE_ENDIAN;//二进制数据编码格式
			header = byteArray.readUnsignedInt();
			if ( header != 5259843 )
			{
				throw( new Error( "Stream does not include CBP header" ));
			}
			version = byteArray.readUnsignedInt();
			if ( version != 17435658 )
			{
				throw( new Error( "invalid CBP version" ));
			}
			byteArray.readUnsignedInt();
			len = byteArray.readUnsignedInt();
			byteArray.position = ( byteArray.position + 48 );
			if ( byteArray.bytesAvailable < len )
			{
				throw( new Error( "CBP steam is not ready" ));
			}
			byte = new ByteArray();
			byte.writeBytes( byteArray, byteArray.position, len );
			byte.position = 0;
			byte.uncompress();//二进制数据的解压
			byte.endian = Endian.LITTLE_ENDIAN;//二进制数据编码格式
			obj = {};
			this.readObject( byte, obj );
			return ( obj[ "" ]);//返回处理后的数据
		}

	}
}

class NamedType
{
	public var name:RegExp;
	public var type:Class;

	public function NamedType ( reg:RegExp, clas:Class )
	{
		this.name = reg;
		this.type = clas;
	}
}