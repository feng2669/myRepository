package __load__.Packs.BitmapPack
{
    import wylib.Packs.MDPackDirectory;
    import wylib.Packs.MDPackage;
    import wylib.Packs.MDPackItem;
    import flash.utils.ByteArray;
    import wylib.Packs.MDPackFile;
    import flash.utils.Endian;

    public class MDPBitmapDirectory extends MDPackDirectory 
    {

        public function MDPBitmapDirectory(_arg1:MDPackage, _arg2:MDPackItem, _arg3:int=2)
        {
            super(_arg1, _arg2, _arg3);
        }

        override public function load(_arg1:ByteArray, _arg2:String=""):void
        {
            var _local9:* = null;
            var _local8:* = null;
            var _local7:* = null;
            var _local6:* = null;
            var _local5:* = null;
            var _local4:* = null;
            var _local3:* = null;
            _local3 = null;
            _local4 = null;
            _local5 = 0;
            _local6 = 0;
            _local7 = 0;
            _local8 = 0;
            _local9 = null;
            super.load(_arg1);
            if (m_Items)
            {
                _local3 = m_Items[(m_Items.length - 1)];
                if (((!(_local3.isDirectory)) && ((_local3.name == "offset"))))
                {
                    _local4 = new ByteArray();
                    MDPackFile(_local3).loadFileData(_local4);
                    _local4.endian = Endian.LITTLE_ENDIAN;
                    _local4.position = 0;
                    m_Items.pop();
                };
                _local8 = m_Items.length;
                _local7 = 0;
                while (_local7 < _local8)
                {
                    _local9 = (m_Items[_local7] as MDPBitmapData);
                    if (_local9)
                    {
                        _local9.loadBitmapData();
                        _local5 = _local4.readShort();
                        _local6 = _local4.readShort();
                        _local9.setOffsetXY(_local5, _local6);
                    };
                    _local7++;
                };
                if (!m_ParentItem)
                {
                    m_Package.releaseStream();
                };
            };
        }


    }
}//package wylib.Packs.BitmapPack
