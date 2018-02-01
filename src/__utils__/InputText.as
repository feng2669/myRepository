package __utils__
{
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.filters.GlowFilter;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import flash.ui.Keyboard;
	import flash.utils.getDefinitionByName;

	/**
	 * 游戏聊天输入框图文混排完美实现
	 * 没用到任何第三方类，看import就知道
	 * 已添加一百多行注释，实际代码大概三百行
	 * 主要测试点：
	 * 1.选中一部分图文，再按删除，或插入表情，或Ctrl+X，或Ctrl+V等
	 * 2.文本框满行后，按住左右键或鼠标拖选左右移动，触发横向滚动的情况
	 * 用以上两点测试，很多第三方控件，或页游中都会出现问题。
	 * 另外，本实现不会做成像RichTextField那样的通用的类库，
	 * 越是通用的东西，效率越低，建议根据实际对代码做相应调整，Good Luck！
	 * @since 2014.6.26
	 * @email cceevv@163.com
	 */
	public class InputText extends Sprite
	{
		/*表情占位符，看起来像空格，但不是空格；
		 输入框一般不能屏蔽空格输入，但可以屏蔽此符号的输入，因此用来做占位符很合适*/
		private const PLACEHOLDER:String = String.fromCharCode( 12288 );

		public var textField:TextField; //文本输入框

		private var mcLayer:Sprite; //用于放置表情的容器，在文本框上面一层

		private var dataList:Vector.<Express>; //存储表情信息的VO

		private var begin:int = 0; //输入框中选中文本的开始索引

		private var end:int = 0; //输入框中选中文本的结束索引，若无选择文本，则 begin==end，并且等于caretIndex

		private var scrollH:int = 0; //文本框满行后向左滚动的距离

		private var keyCode:uint = 0; //上一次所按的键盘码

		private var defaultFormat:TextFormat; //文本默认格式

		private var placeFormat:TextFormat; //表情占位符的格式

		/**
		 * 游戏聊天输入框图文混排
		 * @param w 输入框宽度
		 * @param h 输入框高度
		 */
		public function InputText ( w:Number = 170, h:Number = 20 )
		{
			defaultFormat = new TextFormat();
			defaultFormat.color = 0xFFFFFF;
			defaultFormat.size = 12;
			defaultFormat.letterSpacing = 0; //此处不能省略 
			defaultFormat.align = TextFormatAlign.LEFT;
			defaultFormat.font = "SimSun"; //宋体 //调整占位符的宽度，使之比表情的宽度大一点点
			//不要用占位符的大小(size)去调整宽度，除非你的表情和字体差不多大小，多么痛的领悟 
			placeFormat = new TextFormat();
			placeFormat.letterSpacing = 16;

			textField = new TextField();
			textField.width = w;
			textField.height = h;
			textField.type = TextFieldType.INPUT;
			textField.defaultTextFormat = defaultFormat;
			/*
			   设置为单行文本框，不建议像《仙侠道》那样用多行文本框，事情会变得更复杂，相信我
			   《仙侠道》没有加密，去把代码弄来看看就知道了，用了多行还要处理上下键滚行的恶心问题
			   而一般游戏中都会用上下键来处理聊天缓存功能，即上下键翻看前几次已发送的聊天内容，以避免重复输入
			 */
			textField.multiline = false;
			textField.wordWrap = false;

			textField.mouseWheelEnabled = false;
			textField.restrict = "^" + PLACEHOLDER; //屏蔽占位符，让玩家不能输入此符号 
			textField.filters = [ new GlowFilter( 0x0, 1, 3, 3, 3 )];
			textField.maxChars = 100;
			textField.addEventListener( Event.SCROLL, onTextScroll );
			textField.addEventListener( Event.CHANGE, afterChange );
			textField.addEventListener( KeyboardEvent.KEY_DOWN, onKeyDown );
			this.addChild( textField );
			//遮罩很有必要，满行向左滚动后表情可能只显示一半 
			var mask:Shape = new Shape();
			mask.graphics.beginFill( 0 );
			mask.graphics.drawRect( 0, 0, w, h );
			mask.graphics.endFill();
			this.addChild( mask );

			mcLayer = new Sprite();
			mcLayer.mask = mask;
			this.addChild( mcLayer );
			dataList = new Vector.<Express>();
		}

		/**
		 * 文本框滚动事件，主要是处理横向滚动
		 */
		private function onTextScroll ( e:Event ):void
		{
			//只处理横向滚动，差异化处理很有必要，不加此判断可能导致递归堆栈溢出
			if ( textField.scrollH != scrollH )
			{
				scrollH = textField.scrollH;
				render();
			}
		}

		/**
		 * 键盘事件，不要在此处理Backspace、Delete等事件，相信我
		 */
		private function onKeyDown ( e:KeyboardEvent ):void
		{
			begin = textField.selectionBeginIndex;
			end = textField.selectionEndIndex;
			keyCode = e.keyCode; //发送聊天数据

			if ( keyCode == Keyboard.ENTER )
			{
				if ( textField.length > 0 )
				{
					var chatContent:String = this.srcContent; //TODO: 这里是向服务端发送数据的逻辑
				}
			}
		}

		/**
		 * 文本内容改变事件， 此处是精华所在，理解了就会发现其实很简单
		 */
		private function afterChange ( e:Event = null ):void
		{
			var $begin:int = begin;

			if ( begin == end )
			{
				if ( keyCode == Keyboard.BACKSPACE )
				{
					delExpress( begin - 1 );
					$begin = ( begin > 0 ) ? begin - 1 : 0;
				} else if ( keyCode == Keyboard.DELETE )
				{
					delExpress( begin );
				}
			} else //选中了一部分文本，删除其中可能包含的表情 
			{
				for ( var i:int = begin; i < end; i++ )
				{
					delExpress( i );
				}
			} //删除表情后，更新表情索引 
			updateExpressIndex( $begin );
			render();
			keyCode = 0;
		}

		/**
		 * 图文混排渲染，此处是难点所在，理解了就会发现其实没那么简单
		 */
		private function render ():void
		{
			if ( textField.length == 0 )
			{
				clear();
				return;
			}
			/*设置表情占位符的宽度，上文已解释过，不赘述*/
			textField.setTextFormat( defaultFormat, 0, textField.length );
			var textStr:String = textField.text;

			for ( var i:int = 0; i < textStr.length; i++ )
			{
				var char:String = textStr.charAt( i );

				if ( char == PLACEHOLDER )
				{
					textField.setTextFormat( placeFormat, i, i + 1 );
				}
			}

			/*先清理所有的表情，此处有优化空间，但建议不要折腾，除非纯粹研究*/
			while ( mcLayer.numChildren > 0 )
			{
				mcLayer.removeChildAt( 0 );
			}
			/*下面这一段是处理文本满行后，按左右键或鼠标拖选左右移动，触发横向滚动的情况*/
			var showBegin:int = -1; //输入框中能看到的第一个字符索引 
			var showEnd:int = -1; //输入框中能看到的最后一个字符索引 
			const sRight:int = textField.scrollH + textField.width; //输入框中能看到的第一个字符在「整个」文本行中的横坐标

			/*遍历每个字符的坐标以找出showBegin和showEnd的值*/
			for ( i = 0; i < textField.length; i++ )
			{
				//此处值得一提的是，不管文本横向怎么滚动，所有字符的坐标都是正数，你知道为什么吗？ 
				var rect:Rectangle = textField.getCharBoundaries( i );

				if ( showBegin == -1 && rect.right > textField.scrollH )
				{
					showBegin = i;
				}

				if ( showEnd == -1 && rect.left > sRight )
				{
					showEnd = i - 1;
					break;
				}
			}

			//未满行的情况，所有字符都显示 
			if ( showEnd == -1 )
			{
				showEnd = textField.length - 1;
			}

			/*把文本框中能看到的表情占位符都加上实际表情*/
			for each ( var data:Express in dataList )
			{
				if ( data.index >= showBegin && data.index <= showEnd )
				{
					rect = textField.getCharBoundaries( data.index ); //根据表情和文字大小，微调坐标，使表情在文本中居中 
					data.mc.x = rect.x + 2 - textField.scrollH;
					data.mc.y = rect.y - 6;
					mcLayer.addChild( data.mc );
				}
			}
		}

		/**
		 * 在文本框当前光标处插入表情
		 * @param sign 表情符号，据此符号能够创建出表情显示对象
		 */
		public function insertExpression ( sign:String ):void
		{
			if ( textField.length >= textField.maxChars )
			{
				return;
			}
			//此处需要重新获取选中文本的开始和结束索引，文本框失去焦点后的怪异问题
			begin = textField.selectionBeginIndex;
			end = textField.selectionEndIndex; //删除选中文本中可能包含的表情 

			for ( var i:int = begin; i < end; i++ )
			{
				delExpress( i );
			}
			//把选中的文本替换为表情占位符，没有选中则是插入
			textField.replaceText( begin, end, PLACEHOLDER ); //创建表情数据并保存，保持有序 
			var $i:int = -1;

			for ( i = 0; i < dataList.length; i++ )
			{
				var data:Express = dataList[ i ];

				if ( data.index >= begin )
				{
					$i = i;
					break;
				}
			}
			var mc:MovieClip = getMovieClip( sign );

			if ( $i == -1 )
			{
				dataList.push( new Express( begin, sign, mc ));
			} else
			{
				dataList.splice( $i, 0, new Express( begin, sign, mc ));
			}
			//插入表情后，更新表情索引 
			updateExpressIndex( begin );
			render();
			textField.setSelection( begin + 1, begin + 1 );
		}

		/**
		 * 更新表情数据索引，索引为占位符的索引
		 * @param $begin 只更新第$begin个字符后面的数据，前面的不变
		 */
		private function updateExpressIndex ( $begin:int ):void
		{
			var $i:int = -1;

			for ( var i:int = 0; i < dataList.length; i++ )
			{
				if ( dataList[ i ].index >= $begin )
				{
					$i = i;
					break;
				}
			}

			if ( $i != -1 )
			{
				var textStr:String = textField.text;

				for ( i = $begin; i < textStr.length; i++ )
				{
					if ( textStr.charAt( i ) == PLACEHOLDER )
					{
						dataList[ $i++ ].index = i;
					}
				}
			}
		}

		/**
		 * 取指定索引处的表情数据
		 * @param index 表情索引，即占位符索引
		 * @return 表情数据
		 */
		private function getExpress ( index:int ):Express
		{
			for each ( var data:Express in dataList )
			{
				if ( data.index == index )
				{
					return data;
				}
			}
			return null;
		}

		/**
		 * 删除指定索引处的表情数据，并移除表情显示对象
		 * @param index 表情索引
		 */
		private function delExpress ( index:int ):void
		{
			for ( var i:int = 0; i < dataList.length; i++ )
			{
				var data:Express = dataList[ i ];

				if ( data.index == index )
				{
					dataList.splice( i, 1 );

					if ( mcLayer.contains( data.mc ))
					{
						mcLayer.removeChild( data.mc );
					}
					return;
				}
			}
		}

		/**
		 * 用插入的表情符号创建表情动画
		 * @param sign 表情符号
		 * @return 表情动画
		 */
		private function getMovieClip ( sign:String ):MovieClip
		{
			/*
			   此处符号可根据实际游戏做些处理，
			   比如符号为 /:01，重新构造为 chat_expression_01 等
			   只要构造后的字符串为你在fla里导出的表情类即可
			 */
			var $_class:Class = getDefinitionByName( sign ) as Class;
			var $_item:MovieClip = new $_class();
			$_item.mouseChildren = false;
			$_item.mouseEnabled = false;
			return $_item;
		}

		/**
		 * 获取图文混排原始数据，用于发向服务端，并广播回来
		 */
		public function get srcContent ():String
		{
			var charArr:Array = [];
			var textStr:String = textField.text;

			for ( var i:int = 0; i < textStr.length; i++ )
			{
				var char:String = textStr.charAt( i );

				if ( char == PLACEHOLDER )
				{
					var data:Express = getExpress( i );
					charArr.push( data.sign );
				} else
				{
					charArr.push( char );
				}
			}
			return charArr.join( "" );
		}

		/**
		 * 设置图文混排原始数据，主要用于上下键翻看聊天历史记录时解析表情用
		 * 输出面板的图文混排由于没有键鼠操作，更简单，不在本文讨论之列；
		 * 不过，相信你看到这里也早知道该怎么做了
		 */
		public function set srcContent ( content:String ):void
		{
			clear(); //这里的chat_expression_xx是我的游戏里的表情导出类，根据你的游戏自由调整 
			var reg:RegExp = new RegExp( "chat_expression_[0-9]{2}", "ig" );
			var signArr:Array = content.match( reg );
			content = content.replace( reg, PLACEHOLDER );

			if ( content.length > textField.maxChars )
			{
				content = content.substr( 0, textField.maxChars );
			}

			for ( var i:int = 0; i < content.length; i++ )
			{
				var char:String = content.charAt( i );

				if ( char == PLACEHOLDER )
				{
					var sign:String = signArr.shift() as String;
					var mc:MovieClip = getMovieClip( sign );
					dataList.push( new Express( i, sign, mc ));
				}
			}
			textField.text = content;
			render();
		}

		/**
		 * 清空文本框即相关数据
		 */
		public function clear ():void
		{
			textField.htmlText = "";
			begin = end = scrollH = keyCode = 0;
			dataList = new Vector.<Express>();

			if ( mcLayer != null )
			{
				while ( mcLayer.numChildren > 0 )
				{
					mcLayer.removeChildAt( 0 );
				}
			}
		}

	}
}
/*===============================================*/
import flash.display.MovieClip;

class Express // 内部类，不用新建类文件
{
	public var index:int;

	public var sign:String;

	public var mc:MovieClip;

	/**
	 * 表情数据
	 * @param index 表情索引，即表情占位符在文本中的索引
	 * @param sign 表情符号，用于创建表情动画显示对象
	 * @param mc 表情动画，已经用sign创建好的显示对象
	 */
	public function Express ( index:int, sign:String, mc:MovieClip )
	{
		this.index = index;
		this.sign = sign;
		this.mc = mc;
	}
}