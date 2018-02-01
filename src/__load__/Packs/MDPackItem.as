package __load__.Packs
{
    import flash.utils.ByteArray;

    public class MDPackItem 
    {

        public static const FILEITEM:int = 1;
        public static const DIRECTORYITEM:int = 2;

        protected var m_sName;
        protected var m_ParentItem;
        protected var m_Package;
        protected var m_ExtDataRec;
        protected var m_ItemType:int;

        public function MDPackItem(_arg1:MDPackage, _arg2:MDPackItem, _arg3:uint)
        {
            this.m_Package = _arg1;
            this.m_ParentItem = _arg2;
            this.m_ItemType = _arg3;
        }

        public static function readDataRec(_arg1:ByteArray):MDPackDataRec
        {
            var _local4:* = null;
            var _local3:* = null;
            var _local2:* = null;
            _local2 = 0;
            _local3 = 0;
            _local4 = null;
            _local2 = _arg1.readUnsignedInt();
            _local3 = _arg1.readUnsignedInt();
            if (_local3 > 0)
            {
                _local4 = new MDPackDataRec();
                _local4.dwOffset = _local2;
                _local4.dwSize = _local3;
                _local4.CRC32 = _arg1.readUnsignedInt();
                return (_local4);
            };
            _arg1.position = (_arg1.position + 4);
            return (null);
        }


        public function get isDirectory():Boolean
        {
            return ((this.m_ItemType == DIRECTORYITEM));
        }

        public function load(_arg1:ByteArray, _arg2:String=""):void
        {
            throw (new Error("子类必须覆盖文件系统对象抽象类的加载函数"));
        }

        public function get path():String
        {
            var _local2:* = null;
            var _local1:* = null;
            _local1 = this.m_sName;
            _local2 = this.m_ParentItem;
            while (_local2)
            {
                _local1 = ((_local2.m_sName + "/") + _local1);
                _local2 = _local2.parentItem;
            };
            return (_local1);
        }

        public function get parentDirectory():MDPackDirectory
        {
            return (((((this.m_ParentItem) && (this.m_ParentItem.isDirectory))) ? (this.m_ParentItem as MDPackDirectory) : null));
        }

        public function get name():String
        {
            return (this.m_sName);
        }

        public function get itemType():int
        {
            return (this.m_ItemType);
        }

        public function get extendDataSize():uint
        {
            return (((this.m_ExtDataRec) ? this.m_ExtDataRec.dwSize : 0));
        }

        public function destruct():void
        {
            this.m_ParentItem = null;
            this.m_ExtDataRec = null;
            this.m_Package = null;
        }

        public function get parentItem():MDPackItem
        {
            return (this.m_ParentItem);
        }


    }
}//package wylib.Packs
