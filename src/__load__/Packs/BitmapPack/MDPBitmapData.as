package __load__.Packs.BitmapPack
{
    import flash.display.BitmapData;
    
    import __load__.Packs.BitmapPack.Internal.MDPBitmapDataLoadQueue;

    public class MDPBitmapData extends MDPackFile 
    {

        private static var BitmapDataLoadQueue = new MDPBitmapDataLoadQueue(32);

        protected var m_nOffsetX:int;
        protected var m_nOffsetY:int;
        protected var m_BitmapData;

        public function MDPBitmapData(_arg1:MDPackage, _arg2:MDPackItem, _arg3:int=2)
        {
            super(_arg1, _arg2, _arg3);
        }

        private function loadBmpDataComplete(_arg1:BitmapData):void
        {
            this.m_BitmapData = _arg1;
        }

        public function get offsetX():int
        {
            return (this.m_nOffsetX);
        }

        public function get offsetY():int
        {
            return (this.m_nOffsetY);
        }

        public function setOffsetXY(_arg1:int, _arg2:int):void
        {
            this.m_nOffsetX = _arg1;
            this.m_nOffsetY = _arg2;
        }

        public function set bitmapData(_arg1:BitmapData):void
        {
            if (this.m_BitmapData)
            {
                this.m_BitmapData.dispose();
            };
            this.m_BitmapData = _arg1;
            m_ExtDataRec = null;
            m_FileDataRec = null;
        }

        public function get bitmapData():BitmapData
        {
            return (this.m_BitmapData);
        }

        override public function destruct():void
        {
            if (this.m_BitmapData)
            {
                this.m_BitmapData.dispose();
                this.m_BitmapData = null;
            };
            super.destruct();
        }

        public function loadBitmapData():void
        {
            if (((m_FileDataRec) && ((m_FileDataRec.dwSize > 0))))
            {
                BitmapDataLoadQueue.requestLoadBitmapData(m_Package.stream, m_FileDataRec.dwOffset, m_FileDataRec.dwSize, this.loadBmpDataComplete);
            };
            m_ExtDataRec = null;
            m_FileDataRec = null;
        }


    }
}//package wylib.Packs.BitmapPack
