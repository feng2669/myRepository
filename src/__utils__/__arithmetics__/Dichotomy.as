package __utils__.__arithmetics__
{
	/**
	 * 二分法
	 * @author zhufeng
	 *
	 */
	public class Dichotomy
	{
		/**
		 * 
		 * @param source 必须按某个key进行了排序！！！
		 * @param compare 自定义的比较函数
		 * @param obj 要查找的对象
		 * @param start_index
		 * @param end_index
		 * @return 
		 * 
		 */		
		public static function searchIndex ( source:Array, compare:Function, obj:Object, start_index:int = 0, end_index:int = 2147483647 ):int
		{
			var offset:int = 0;
			var index:int = 0;
			if ( end_index == 2147483647 )
			{
				end_index = ( source.length - 1 );
			}
			while ( start_index <= end_index )
			{
				index = (( start_index + end_index ) >> 1 ); //中间值
				offset = compare( obj, source[ index ]);
				if ( offset != 0 )
				{
					if ( offset < 0 )
					{
						end_index = ( index - 1 ); //查找的目标可能在下半区
					} else
					{
						start_index = ++index; //查找的目标可能在上半区
					}
				} else
				{
					return ( index ); //找到目标
				}
			}
			return ( -1 ); //不在查找列表中
		}

	}
}