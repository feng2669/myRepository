package __load__.Packs.BitmapPack
{
    import flash.display.Bitmap;
    import flash.geom.Point;
    import flash.utils.getTimer;

    public class MDPAnimation extends Bitmap 
    {

        protected var m_dwNextFrameTime:uint;
        protected var m_dwInterval:uint;
        protected var m_nFrameIndex:int;
        protected var m_nFrameStart:int;
        protected var m_nFrameEnd:int;
        protected var m_Directory;

        public function MDPAnimation()
        {
            this.m_nFrameIndex = -1;
            this.m_dwInterval = 240;
            this.m_nFrameEnd = -1;
        }

        public function get interval():uint
        {
            return (this.m_dwInterval);
        }

        public function getFrameOffset(_arg1:int):Point
        {
            var _local2:* = null;
            if (((!(this.m_Directory)) || ((this.m_Directory.itemCount <= _arg1))))
            {
                return (null);
            };
            _local2 = MDPBitmapData(this.m_Directory.getItem(_arg1));
            return (new Point(_local2.offsetX, _local2.offsetY));
        }

        protected function getTimer():int
        {
            return (flash.utils.getTimer());
        }

        public function update(_arg1:uint):void
        {
            var _local6:* = null;
            var _local5:* = null;
            var _local4:* = null;
            var _local3:* = null;
            var _local2:* = null;
            _local2 = 0;
            _local3 = null;
            _local4 = 0;
            if (!this.m_Directory)
            {
                return;
            };
            if (_arg1 >= this.m_dwNextFrameTime)
            {
                _local2 = (((this.m_nFrameEnd)==-1) ? (this.m_Directory.itemCount - 1) : this.m_nFrameEnd);
                this.m_nFrameIndex++;
                if (this.m_dwInterval > 0)
                {
                    _local4 = (_arg1 - this.m_dwNextFrameTime);
                    if (_local4 >= this.m_dwInterval)
                    {
                        _local4 = (_local4 / this.m_dwInterval);
                        this.m_nFrameIndex = (this.m_nFrameIndex + _local4);
                        this.m_dwNextFrameTime = (this.m_dwNextFrameTime + (this.m_dwInterval * (_local4 + 1)));
                    }
                    else
                    {
                        this.m_dwNextFrameTime = (this.m_dwNextFrameTime + this.m_dwInterval);
                    };
                };
                if (this.m_nFrameIndex > _local2)
                {
                    this.m_nFrameIndex = (this.m_nFrameStart + ((this.m_nFrameIndex - this.m_nFrameStart) % ((_local2 - this.m_nFrameStart) + 1)));
                };
                _local3 = (this.m_Directory.getItem(this.m_nFrameIndex) as MDPBitmapData);
                if (!_local3)
                {
                    return;
                };
                bitmapData = _local3.bitmapData;
                this.setOffsetXY(_local3.offsetX, _local3.offsetY);
            };
        }

        public function set interval(_arg1:uint):void
        {
            this.m_dwInterval = _arg1;
        }

        public function setFrameRange(_arg1:int, _arg2:int):void
        {
            var _local3:* = null;
            _local3 = 0;
            this.m_nFrameStart = _arg1;
            if (_arg2 != -1)
            {
                this.m_nFrameEnd = ((_arg1 + _arg2) - 1);
            }
            else
            {
                this.m_nFrameEnd = -1;
            };
            if (this.m_Directory)
            {
                _local3 = this.m_Directory.itemCount;
                if (this.m_nFrameStart >= _local3)
                {
                    this.m_nFrameStart = (_local3 - 1);
                };
                if (_local3 <= this.m_nFrameEnd)
                {
                    this.m_nFrameEnd = (_local3 - 1);
                };
            };
        }

        public function destruct():void
        {
            this.bitmapData = null;
            this.m_Directory = null;
        }

        public function getFrameSize(_arg1:int):Point
        {
            var _local2:* = null;
            if (((!(this.m_Directory)) || ((this.m_Directory.itemCount <= _arg1))))
            {
                return (null);
            };
            _local2 = MDPBitmapData(this.m_Directory.getItem(this.m_nFrameIndex));
            if (!_local2.bitmapData)
            {
                return (null);
            };
            return (new Point(_local2.bitmapData.width, _local2.bitmapData.height));
        }

        public function set frameIndex(_arg1:int):void
        {
            var _local2:* = null;
            _local2 = null;
            this.m_nFrameIndex = _arg1;
            if (this.m_Directory)
            {
                _local2 = MDPBitmapData(this.m_Directory.getItem(this.m_nFrameIndex));
                if (_local2)
                {
                    bitmapData = _local2.bitmapData;
                    this.setOffsetXY(_local2.offsetX, _local2.offsetY);
                };
            };
            this.m_dwNextFrameTime = (this.getTimer() + this.m_dwInterval);
        }

        public function set directory(_arg1:MDPackDirectory):void
        {
            this.m_Directory = _arg1;
            if (((!(_arg1)) || ((this.m_nFrameIndex >= _arg1.itemCount))))
            {
                this.m_nFrameIndex = 0;
                bitmapData = null;
            };
        }

        public function set frameEnd(_arg1:int):void
        {
            this.m_nFrameEnd = _arg1;
            this.setFrameRange(this.m_nFrameStart, (((_arg1)!=-1) ? (_arg1 - this.m_nFrameStart) : _arg1));
        }

        protected function setOffsetXY(_arg1:int, _arg2:int):void
        {
            if (rotationY == 0)
            {
                super.x = _arg1;
            }
            else
            {
                super.x = -(_arg1);
            };
            super.y = _arg2;
        }

        public function get frameIndex():int
        {
            return (this.m_nFrameIndex);
        }

        public function get frameCount():int
        {
            return (((this.m_Directory) ? this.m_Directory.itemCount : 0));
        }

        public function set frameStart(_arg1:int):void
        {
            this.setFrameRange(_arg1, (_arg1 - this.m_nFrameStart));
        }

        public function get directory():MDPackDirectory
        {
            return (this.m_Directory);
        }

        public function get frameEnd():int
        {
            return (this.m_nFrameEnd);
        }

        public function get frameStart():int
        {
            return (this.m_nFrameStart);
        }


    }
}//package wylib.Packs.BitmapPack
