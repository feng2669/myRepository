package __load__.Packs.BitmapPack
{
    import wylib.Packs.MDPackage;

    public class MDPBitmapPackage extends MDPackage 
    {

        public function MDPBitmapPackage(_arg1:Class=null, _arg2:Class=null)
        {
            if (!_arg1)
            {
                _arg1 = MDPBitmapData;
            };
            if (!_arg2)
            {
                _arg2 = MDPBitmapDirectory;
            };
            super(_arg1, _arg2);
        }

    }
}//package wylib.Packs.BitmapPack
