package __load__.Packs
{
    import wylib.Loaders.BinLoaderQueue;
    import wylib.Packs.BitmapPack.MDPSWFBitmapPackage;
    import flash.utils.Endian;
    import flash.utils.ByteArray;

    public class MDPackGroup 
    {

        private var m_Loader;
        private var m_sGroupName;
        private var m_sPackageExt;
        private var m_Packages;

        public function MDPackGroup(_arg1:BinLoaderQueue, _arg2:String="", _arg3:String=".mdp")
        {
            this.m_sPackageExt = _arg3;
            this.m_sGroupName = _arg2;
            this.m_Loader = _arg1;
            this.m_Packages = new Array();
        }

        public function get groupName():String
        {
            return (this.m_sGroupName);
        }

        public function getPackage(_arg1:int, _arg2:Class=null):MDPackage
        {
            var _local4:* = null;
            var _local3:* = null;
            if (_arg1 < 0)
            {
                throw (new Error(("索引超出预定范围：" + _arg1)));
            };
            if (this.m_Packages[_arg1])
            {
                return (this.m_Packages[_arg1]);
            };
            if (!_arg2)
            {
                _arg2 = MDPSWFBitmapPackage;
            };
            _local3 = new (_arg2)();
            this.m_Packages[_arg1] = _local3;
            _local4 = _arg1.toString();
            while (_local4.length < 5)
            {
                _local4 = ("0" + _local4);
            };
            _local4 = (((this.m_sGroupName + "/") + _local4) + this.m_sPackageExt);
            _local3.file = _local4;
            this.m_Loader.requestLoad(_local4, _local3, this.loadPackageComplete);
            return (_local3);
        }

        public function destruct():void
        {
            while (this.m_Packages.length > 0)
            {
                this.m_Packages.pop().destruct();
            };
            this.m_Loader = null;
        }

        private function loadPackageComplete(_arg1:MDPackage, _arg2:ByteArray):void
        {
            if (((_arg2) && (!((_arg2.length == 0)))))
            {
                _arg2.endian = Endian.LITTLE_ENDIAN;
                _arg1.load(_arg2);
            };
        }


    }
}//package wylib.Packs
