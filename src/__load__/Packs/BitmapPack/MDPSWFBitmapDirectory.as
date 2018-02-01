package __load__.Packs.BitmapPack
{
    import wylib.Packs.MDPackDirectory;
    import flash.geom.Point;
    import wylib.Packs.BitmapPack.Internal.MDPSWFLoadQueue;
    import wylib.Packs.MDPackage;
    import wylib.Packs.MDPackItem;
    import flash.geom.Rectangle;
    import flash.display.BitmapData;
    import flash.display.LoaderInfo;
    import flash.utils.ByteArray;
    import flash.utils.Endian;
    import wylib.Packs.MDPackFile;

    public class MDPSWFBitmapDirectory extends MDPackDirectory 
    {

        private static const ZeroPoint = new Point();

        private static var SWFLoadQueue = new MDPSWFLoadQueue(32);
        private static var ReadOffsetBytes;

        public function MDPSWFBitmapDirectory(_arg1:MDPackage, _arg2:MDPackItem, _arg3:int=2)
        {
            super(_arg1, _arg2, _arg3);
        }

        private function onLoadSWFComplete(_arg1:LoaderInfo, _arg2:ByteArray):void
        {
            var _local17:* = null;
            var _local16:* = null;
            var _local15:* = null;
            var _local14:* = null;
            var _local13:* = null;
            var _local12:* = null;
            var _local11:* = null;
            var _local10:* = null;
            var _local9:* = null;
            var _local8:* = null;
            var _local7:* = null;
            var _local6:* = null;
            var _local5:* = null;
            var _local4:* = null;
            var _local3:* = null;
            _local6 = 0;
            _local11 = null;
            _local12 = null;
            _local15 = null;
            _local3 = (_arg1.applicationDomain.getDefinition("AMImage") as Class);
            if (_local3 == null)
            {
                throw (new Error("资源包中的SWF不是通过有效的工具或规则打包的SWF文件！"));
            };
            _local4 = new (_local3)();
            _local5 = m_Items[2];
            _local7 = (_local5.fileSize / 16);
            _local8 = new Rectangle();
            _local9 = ZeroPoint;
            _local10 = m_Package.fileClass;
            _arg2.position = _local5.fileOffset;
            _local6 = 0;
            while (_local6 < _local7)
            {
                _local8.x = _arg2.readInt();
                _local8.y = _arg2.readInt();
                _local8.width = _arg2.readInt();
                _local8.height = _arg2.readInt();
                _local12 = new BitmapData(_local8.width, _local8.height, true, 0xFFFF0000);
                _local12.copyPixels(_local4, _local8, _local9);
                _local11 = new (_local10)(m_Package, this, FILEITEM);
                _local11.bitmapData = _local12;
                m_Items.push(_local11);
                _local6++;
            };
            _local4.dispose();
            _local13 = m_Items.splice(0, 3);
            _local14 = _local13[1];
            this.readOffsetFile(_local14);
            for each (_local15 in _local13)
            {
                _local15.destruct();
            };
        }

        protected function readOffsetFile(_arg1:MDPackItem):void
        {
            var _local7:* = null;
            var _local6:* = null;
            var _local5:* = null;
            var _local4:* = null;
            var _local3:* = null;
            var _local2:* = null;
            _local2 = null;
            _local3 = 0;
            _local4 = 0;
            _local5 = 0;
            _local6 = 0;
            _local7 = null;
            if (!ReadOffsetBytes)
            {
                ReadOffsetBytes = new ByteArray();
                ReadOffsetBytes.endian = Endian.LITTLE_ENDIAN;
            };
            _local2 = ReadOffsetBytes;
            _local2.position = 0;
            MDPackFile(_arg1).loadFileData(_local2);
            _local2.position = 0;
            _local6 = m_Items.length;
            _local5 = 0;
            while (_local5 < _local6)
            {
                _local7 = (m_Items[_local5] as MDPBitmapData);
                if (_local7)
                {
                    _local3 = _local2.readShort();
                    _local4 = _local2.readShort();
                    _local7.setOffsetXY(_local3, _local4);
                };
                _local5++;
            };
        }

        override public function load(_arg1:ByteArray, _arg2:String=""):void
        {
            var _local7:* = null;
            var _local6:* = null;
            var _local5:* = null;
            var _local4:* = null;
            var _local3:* = null;
            _local3 = null;
            _local4 = null;
            _local5 = 0;
            _local6 = 0;
            _local7 = null;
            super.load(_arg1);
            if (m_Items)
            {
                if ((((((((m_Items.length >= 3)) && ((MDPackItem(m_Items[0]).name == "!media.swf")))) && ((MDPackItem(m_Items[1]).name == "!offset")))) && ((MDPackItem(m_Items[2]).name == "!rect"))))
                {
                    _local3 = m_Items[0];
                    SWFLoadQueue.requestLoadSWF(_arg1, _local3.fileOffset, _local3.fileSize, this.onLoadSWFComplete);
                }
                else
                {
                    _local4 = m_Items[(m_Items.length - 1)];
                    if (((!(_local4.isDirectory)) && ((_local4.name == "offset"))))
                    {
                        m_Items.pop();
                    }
                    else
                    {
                        _local4 = null;
                    };
                    _local6 = m_Items.length;
                    _local5 = 0;
                    while (_local5 < _local6)
                    {
                        _local7 = (m_Items[_local5] as MDPBitmapData);
                        if (_local7)
                        {
                            _local7.loadBitmapData();
                        };
                        _local5++;
                    };
                    if (_local4)
                    {
                        this.readOffsetFile(_local4);
                    };
                    if (!m_ParentItem)
                    {
                        m_Package.releaseStream();
                    };
                };
            };
        }


    }
}//package wylib.Packs.BitmapPack
