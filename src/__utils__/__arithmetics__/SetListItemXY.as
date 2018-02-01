package __utils__.__arithmetics__
{
	public class SetListItemXY
	{
		/**
		 * 设置列表中item的坐标
		 * @param item	显示对象
		 * @param index	下标
		 * @param col		列数
		 * @param refer	约束（width：宽；height：高；offsetX：水平间隔；offsetY：垂直间隔）
		 * 
		 */
		public static function set_XY(item:*, index:int, col:int, refer:Object):void
		{
			var xx:Number = (refer.width + refer.offsetX) * (index % col);
			var yy:Number = (refer.height + refer.offsetY) * (int(index / col));
//			trace("index=" + index + "    x=" + xx + "    y=" + yy);
			if (item)
			{
				item.x = xx;
				item.y = yy;
			}
		}
		
		/**
		 * 获取列表中item的坐标
		 * @param index	下标
		 * @param col		列数
		 * @param refer	约束（width：宽；height：高；offsetX：水平间隔；offsetY：垂直间隔）
		 * 
		 */
		public static function get_XY(index:int, col:int, refer:Object):Object
		{
			var xx:Number = (refer.width + refer.offsetX) * (index % col);
			var yy:Number = (refer.height + refer.offsetY) * (int(index / col));
			return {"x": xx, "y": yy};
		}
		
	}
}