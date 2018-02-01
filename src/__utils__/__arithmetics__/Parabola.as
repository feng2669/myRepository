package __utils__.__arithmetics__
{
	import flash.geom.Point;

	/**
	 * 抛物线
	 * @author zhufeng
	 * 
	 */	
	public class Parabola
	{
		public static const g:Number = 10;//重力加速度

		/**
		 * 
		 * @param start_x
		 * @param start_y
		 * @param end_x
		 * @param end_y
		 * @param time 运动时间
		 * @param total 抛物线的点的数量
		 * @param g
		 * @return 抛物线的点
		 * 
		 */		
		public static function MakeParabolaPoints ( start_x:Number, start_y:Number, 
																				end_x:Number, end_y:Number, 
																				time:int, total:int, g:Number = 0 ):Vector.<Point>
		{
			var index:int;
			var offset_x:Number;
			var offset_y:Number;;
			var offset:Number;
			var position:Number;
			var points:Vector.<Point>;
			if ( g == 0 )
			{
				g = Parabola.g;
			}
			points = new Vector.<Point>( total );
			offset_x = (( end_x - start_x ) / time );
			offset_y = ((( start_y - end_y ) + (( g * ( time * time )) >> 1 )) / time );
			offset = 0;
			position = ( time / total );//total=time * 2 取中心点
			index = 0;
			while ( index < total )
			{
				offset = ( offset + position );
				points[ index ] = new Point(( start_x + ( offset_x * offset )), ( start_y - (( offset_y * offset ) - (( g * ( offset * offset )) >> 1 ))));
				index++;
			}
			return ( points );
		}
		
	}
}