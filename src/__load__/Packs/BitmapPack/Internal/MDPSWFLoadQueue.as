package __load__.Packs.BitmapPack.Internal
{
    import flash.events.Event;
    import flash.utils.ByteArray;
    import flash.display.LoaderInfo;

    public dynamic class MDPSWFLoadQueue extends Array 
    {

        private var IdleLoaderList;

        public function MDPSWFLoadQueue(_arg1:int=2)
        {
            var _local3:* = null;
            var _local2:* = null;
            _local2 = 0;
            _local3 = null;
            super();
            this.IdleLoaderList = new Array();
            _local2 = 0;
            while (_local2 < _arg1)
            {
                _local3 = new MDPSWFLoader();
                _local3.contentLoaderInfo.addEventListener(Event.COMPLETE, this.loadSWFComplete);
                this.IdleLoaderList.push(_local3);
                _local2++;
            };
        }

        public function requestLoadSWF(_arg1:ByteArray, _arg2:int, _arg3:int, _arg4:Function):void
        {
            var _local7:* = null;
            var _local6:* = null;
            var _local5:* = null;
            _local5 = 0;
            _local6 = null;
            _local7 = new MDPLoadSWFInfo();
            _local7.CallBack = _arg4;
            _local7.Position = _arg2;
            _local7.Size = _arg3;
            _local7.Stream = _arg1;
            if (this.IdleLoaderList.length)
            {
                _local6 = this.IdleLoaderList.pop();
                _local6.loadNextRequest(_local7);
                return;
            };
            push(_local7);
        }

        private function loadSWFComplete(e:Event):void
        {
            var _local4:* = null;
            var _local3:* = null;
            var _local2:* = null;
            var ldi:* = LoaderInfo(e.currentTarget);
            var ldr:* = MDPSWFLoader(ldi.loader);
            var info:* = ldr.CurrentLoadInfo;
            try
            {
                info.CallBack(ldi, info.Stream);
            }
            finally
            {
                info.Stream = null;
                info.CallBack = null;
                ldr.unloadAndStop(true);
                if (length > 0)
                {
                    ldr.loadNextRequest(pop());
                }
                else
                {
                    ldr.CurrentLoadInfo = null;
                    this.IdleLoaderList.push(ldr);
                };
            };
        }


    }
}//package wylib.Packs.BitmapPack.Internal

import flash.display.Loader;
import flash.utils.ByteArray;
import flash.system.LoaderContext;
import flash.system.ApplicationDomain;

class MDPSWFLoader extends Loader 
{

    /*private*/ var Stream;
    public var CurrentLoadInfo;

    public function MDPSWFLoader()
    {
        this.Stream = new ByteArray();
    }

    public function loadNextRequest(_arg1:MDPLoadSWFInfo):void
    {
        var _local2:* = null;
        this.CurrentLoadInfo = _arg1;
        this.Stream.length = 0;
        this.Stream.writeBytes(_arg1.Stream, _arg1.Position, _arg1.Size);
        _local2 = new LoaderContext(false, new ApplicationDomain());
        if (_local2.hasOwnProperty("allowLoadBytesCodeExecution"))
        {
            _local2["allowLoadBytesCodeExecution"] = true;
        };
        loadBytes(this.Stream, _local2);
    }


}
class MDPLoadSWFInfo 
{

    public var Stream;
    public var Size:int;
    public var CallBack;
    public var Position:int;


}
