package __load__.Packs
{
    import flash.events.EventDispatcher;
    import flash.utils.ByteArray;
    import flash.events.Event;

    public class MDPackage extends EventDispatcher 
    {

        public static const MDPFILEHEADERIDENT:uint = 5260365;
        public static const MDPFILERECORDIDENT:uint = 16860237;
        public static const MDPDIRECTORYRECORDIDENT:uint = 16925773;
        public static const MDPFILEVERSION_100116:uint = 655632;
        public static const MDPFILEVERSION_CURRENT:uint = MDPFILEVERSION_100116;//655632

        protected var m_DataStream;
        private var m_FileClass;
        protected var m_RootDir;
        public var file;
        private var m_DirectoryClass;

        public function MDPackage(_arg1:Class=null, _arg2:Class=null)
        {
            this.m_FileClass = ((_arg1) ? _arg1 : MDPackFile);
            this.m_DirectoryClass = ((_arg2) ? _arg2 : MDPackDirectory);
        }

        public function get stream():ByteArray
        {
            return (this.m_DataStream);
        }

        protected function dispatchLoadCompleteEvent():void
        {
            var _local1:* = null;
            _local1 = new Event(Event.COMPLETE);
            dispatchEvent(_local1);
        }

        public function load(_arg1:ByteArray):void
        {
            this.loadHead(_arg1);
            if (this.m_RootDir)
            {
                this.m_RootDir.destruct();
                this.m_RootDir = null;
            };
            this.m_DataStream = _arg1;
            this.m_RootDir = new this.m_DirectoryClass(this, null, MDPackItem.DIRECTORYITEM);
            this.m_RootDir.load(_arg1, this.file);
            this.dispatchLoadCompleteEvent();
        }

        public function releaseStream():void
        {
            this.m_DataStream = null;
        }

        public function get rootDir():MDPackDirectory
        {
            return (this.m_RootDir);
        }

        public function get directoryClass():Class
        {
            return (this.m_DirectoryClass);
        }

        protected function loadHead(_arg1:ByteArray):void
        {
            if (_arg1.readUnsignedInt() != MDPFILEHEADERIDENT)
            {
                throw (new Error(("非有效的资源包文件      " + this.file)));
            };
            if (_arg1.readUnsignedInt() != MDPFILEVERSION_CURRENT)
            {
                throw (new Error(("资源包文件有效，但需要在更新后才可使用！    " + this.file)));
            };
            _arg1.position = _arg1.readUnsignedInt();
        }

        public function destruct():void
        {
            this.m_DataStream = null;
        }

        public function get fileClass():Class
        {
            return (this.m_FileClass);
        }


    }
}//package wylib.Packs
