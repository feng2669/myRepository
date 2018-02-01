package __load__.Packs
{
    import flash.utils.ByteArray;

    public class MDPackDirectory extends MDPackItem 
    {

        protected var m_Items;

        public function MDPackDirectory(_arg1:MDPackage, _arg2:MDPackItem, _arg3:int=2)
        {
            super(_arg1, _arg2, _arg3);
        }

        override public function load(Stream:ByteArray, file:String=""):void
        {
            var _local4:* = null;
            var _local3:* = null;
            var dwNameLen:* = 0;
            var nItemCount:* = 0;
            var ItemClass:* = null;
            var SubItem:* = null;
            var dwItemOffset:* = 0;
            var nItemType:* = 0;
            var dwStmPos:* = 0;
            try
            {
                if (Stream.readUnsignedInt() != MDPackage.MDPDIRECTORYRECORDIDENT)
                {
                    throw (new Error(("无效的目录描述头    " + file)));
                };
            }
            catch(e:Error)
            {
                throw (new Error(("目录描述头读取错误    readUnsignedInt()   " + file)));
            };
            dwNameLen = Stream.readUnsignedInt();
            nItemCount = Stream.readInt();
            m_ExtDataRec = readDataRec(Stream);
            Stream.position = (Stream.position + 16);
            m_sName = Stream.readMultiByte(dwNameLen, "GB2312");
            if (nItemCount <= 0)
            {
                return;
            };
            this.m_Items = new Array();
            var i:* = (nItemCount - 1);
            while (i > -1)
            {
                nItemType = Stream.readUnsignedByte();
                Stream.position = (Stream.position + 3);
                dwItemOffset = Stream.readUnsignedInt();
                if (nItemType == FILEITEM)
                {
                    ItemClass = m_Package.fileClass;
                }
                else
                {
                    if (nItemType == DIRECTORYITEM)
                    {
                        ItemClass = m_Package.directoryClass;
                    }
                    else
                    {
                        throw (new Error("无效的子对象类型"));
                    };
                };
                dwStmPos = Stream.position;
                SubItem = new (ItemClass)(m_Package, this, nItemType);
                Stream.position = dwItemOffset;
                SubItem.load(Stream);
                this.m_Items.push(SubItem);
                Stream.position = dwStmPos;
                i = (i - 1);
            };
        }

        override public function destruct():void
        {
            var _local1:* = null;
            _local1 = null;
            if (this.m_Items)
            {
                while (this.m_Items.length)
                {
                    _local1 = this.m_Items.pop();
                    _local1.destruct();
                };
            };
            this.m_Items = null;
            super.destruct();
        }

        public function getItem(_arg1:int):MDPackItem
        {
            return (((this.m_Items) ? MDPackItem(this.m_Items[_arg1]) : null));
        }

        public function get itemCount():int
        {
            return (((this.m_Items) ? this.m_Items.length : 0));
        }

        public function getNamedItem(_arg1:String):MDPackItem
        {
            var _local3:* = null;
            var _local2:* = null;
            _local2 = 0;
            _local3 = null;
            if (!this.m_Items)
            {
                return (null);
            };
            _local2 = (this.m_Items.length - 1);
            while (_local2 > -1)
            {
                _local3 = this.m_Items[_local2];
                if (_local3.name == _arg1)
                {
                    return (_local3);
                };
                _local2--;
            };
            return (null);
        }


    }
}//package wylib.Packs
