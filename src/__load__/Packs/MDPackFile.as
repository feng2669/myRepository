package __load__.Packs
{
    import flash.utils.ByteArray;

    public class MDPackFile extends MDPackItem 
    {

        protected var m_btCompressType:int;
        protected var m_FileDataRec;
        protected var m_btCompressVer:int;

        public function MDPackFile(_arg1:MDPackage, _arg2:MDPackItem, _arg3:int=2)
        {
            super(_arg1, _arg2, _arg3);
        }

        public function get fileSize():uint
        {
            return (((this.m_FileDataRec) ? this.m_FileDataRec.dwSize : 0));
        }

        override public function load(_arg1:ByteArray, _arg2:String=""):void
        {
            var _local3:* = null;
            _local3 = 0;
            if (_arg1.readUnsignedInt() != MDPackage.MDPFILERECORDIDENT)
            {
                throw (new Error("非有效的文件标识头"));
            };
            _local3 = _arg1.readUnsignedInt();
            this.m_FileDataRec = readDataRec(_arg1);
            m_ExtDataRec = readDataRec(_arg1);
            this.m_btCompressType = _arg1.readUnsignedByte();
            this.m_btCompressVer = _arg1.readUnsignedByte();
            _arg1.position = (_arg1.position + 6);
            m_sName = _arg1.readMultiByte(_local3, "GB2312");
        }

        override public function destruct():void
        {
            this.m_FileDataRec = null;
            super.destruct();
        }

        public function loadFileData(_arg1:ByteArray):uint
        {
            if (this.m_FileDataRec)
            {
                _arg1.writeBytes(m_Package.stream, this.m_FileDataRec.dwOffset, this.m_FileDataRec.dwSize);
                return (this.m_FileDataRec.dwSize);
            };
            return (0);
        }

        public function get fileOffset():uint
        {
            return (((this.m_FileDataRec) ? this.m_FileDataRec.dwOffset : 0));
        }


    }
}//package wylib.Packs
