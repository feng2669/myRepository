package __load__.Packs.BitmapPack
{
    public class MDPSWFBitmapPackage extends MDPBitmapPackage 
    {

        public function MDPSWFBitmapPackage(_arg1:Class=null, _arg2:Class=null)
        {
            if (!_arg1)
            {
                _arg1 = MDPBitmapData;
            };
            if (!_arg2)
            {
                _arg2 = MDPSWFBitmapDirectory;
            };
            super(_arg1, _arg2);
        }

    }
}