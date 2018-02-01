package __utils__
{
	import flash.filters.ColorMatrixFilter;
	import flash.filters.DropShadowFilter;
	import flash.filters.GlowFilter;
	
	public class FilterUtils
	{
		public static const BlackGlowFilter:GlowFilter = new GlowFilter( 0, 1, 2, 2, 10 );
		public static const BlueGlowFilter:GlowFilter = new GlowFilter( 0xFF0000, 1, 1, 1, 10, 1 );
		public static const PinkGlowFilter:GlowFilter = new GlowFilter( 0xCC5200, 1, 10, 10, 3 );
		public static const WhiteGlowFilter:GlowFilter = new GlowFilter( 0xFFFFFF, 1, 10, 10, 1 );
		public static const OriginalColorFilter:ColorMatrixFilter = new ColorMatrixFilter([ 1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1, 0 ]);
		public static const ShadowFilter:DropShadowFilter = new DropShadowFilter( 2, 90 );
		
		public static const CellSelectedFilters:Array = [ new GlowFilter( 0xFFCC00, 1, 6, 6, 2, 4, false )];
		public static const NavButtonTextFilters:Array = [ new GlowFilter( 8999, 1, 2, 2, 10, 1, false, false )];
		public static const RoleSelectedFilters:Array = [ new GlowFilter( 0xFFFF00, 0.75 )];
		public static const DefaultGrayFilters:Array = [ new ColorMatrixFilter([ 0.3086, 0.6094, 0.082, 0, 0, 0.3086, 0.6094, 0.082, 0, 0, 0.3086, 0.6094, 0.082, 0, 0, 0, 0, 0, 1, 0 ])];
		public static const DownGrayFilters:Array = [ new ColorMatrixFilter([ 1, 0, 0, 0, -30, 0, 1, 0, 0, -30, 0, 0, 1, 0, -30, 0, 0, 0, 1, -102 ])];
		public static const DefaultTextFilters:Array = [ BlackGlowFilter ];
		public static const ShowyNoticeFilters:Array = [ BlueGlowFilter ];

		public static function createColorFilter( color:int ):ColorMatrixFilter
		{
			var cmf:ColorMatrixFilter = null;
			var arr:Array = [];
			cmf = ( OriginalColorFilter.clone() as ColorMatrixFilter );
			arr = OriginalColorFilter.matrix.concat();
			arr[ 4 ] = ((( color & 0xFF0000 ) >> 16 ) - 0xFF );
			arr[ 9 ] = ((( color & 0xFF00 ) >> 8 ) - 0xFF );
			arr[ 14 ] = (( color & 0xFF ) - 0xFF );
			cmf.matrix = arr;
			return ( cmf );
		}
		
	}
}