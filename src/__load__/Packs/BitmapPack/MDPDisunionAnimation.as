package __load__.Packs.BitmapPack
{
    public class MDPDisunionAnimation extends MDPAnimation 
    {

        protected var m_specialFrameEnable = false;
        protected var m_vIntervals;

        public function MDPDisunionAnimation()
        {
            this.m_vIntervals = [];
        }

        public function clearIntervals():void
        {
            this.m_vIntervals = [];
        }

        protected function getFrameTime(_arg1:int):int
        {
            var _local2:* = null;
            _local2 = this.m_vIntervals[_arg1];
            if (_local2 == 0)
            {
                _local2 = m_dwInterval;
            };
            return (_local2);
        }

        public function get frameIntervals():Array
        {
            return (this.m_vIntervals);
        }

        override public function update(_arg1:uint):void
        {
            var _local8:* = null;
            var _local7:* = null;
            var _local6:* = null;
            var _local5:* = null;
            var _local4:* = null;
            var _local3:* = null;
            var _local2:* = null;
            _local3 = 0;
            _local4 = 0;
            _local5 = null;
            _local6 = 0;
            if (!this.m_specialFrameEnable)
            {
                super.update(_arg1);
                return;
            };
            if (!m_Directory)
            {
                return;
            };
            _local2 = m_nFrameIndex;
            if (_arg1 >= m_dwNextFrameTime)
            {
                _local3 = (((m_nFrameEnd)==-1) ? (m_Directory.itemCount - 1) : m_nFrameEnd);
                _local4 = this.getFrameTime(m_nFrameIndex);
                m_nFrameIndex++;
                if (m_dwInterval > 0)
                {
                    _local6 = (_arg1 - m_dwNextFrameTime);
                    if (_local6 >= _local4)
                    {
                        m_dwNextFrameTime = (m_dwNextFrameTime + (_local6 + this.getFrameTime(m_nFrameIndex)));
                        m_nFrameIndex = this.getNextFrameByTime(m_nFrameIndex, _local3, _local6);
                    }
                    else
                    {
                        m_dwNextFrameTime = (m_dwNextFrameTime + this.getFrameTime(m_nFrameIndex));
                    };
                };
                if (m_nFrameIndex > _local3)
                {
                    m_nFrameIndex = (m_nFrameStart + ((m_nFrameIndex - m_nFrameStart) % ((_local3 - m_nFrameStart) + 1)));
                };
                if (m_nFrameIndex == _local2)
                {
                    return;
                };
                _local5 = (m_Directory.getItem(m_nFrameIndex) as MDPBitmapData);
                if (!_local5)
                {
                    return;
                };
                bitmapData = _local5.bitmapData;
                setOffsetXY(_local5.offsetX, _local5.offsetY);
            };
        }

        public function set specialFrameEnable(_arg1:Boolean):void
        {
            this.m_specialFrameEnable = _arg1;
        }

        protected function getNextFrameByTime(_arg1:int, _arg2:int, _arg3:int):int
        {
            var _local5:* = null;
            var _local4:* = null;
            _local5 = 0;
            _local4 = 0;
            do 
            {
                _local5 = this.m_vIntervals[_arg1];
                if (_local5 == 0)
                {
                    _local5 = m_dwInterval;
                };
                _local4 = (_local4 + _local5);
                if (++_arg1 >= m_nFrameEnd)
                {
                    _arg1 = m_nFrameStart;
                };
            } while (_local4 < _arg3);
            return (_arg1);
        }

        public function setFrameInterval(_arg1:int, _arg2:int):void
        {
            this.m_vIntervals[_arg1] = _arg2;
        }

        protected function getFrameAreaTime(_arg1:int, _arg2:int):int
        {
            var _local8:* = null;
            var _local7:* = null;
            var _local6:* = null;
            var _local5:* = null;
            var _local4:* = null;
            var _local3:* = null;
            _local7 = 0;
            _local3 = m_Directory.itemCount;
            if ((((_arg2 >= _local3)) || ((_arg1 >= _local3))))
            {
                return (m_dwInterval);
            };
            _local4 = Math.abs(((_local3 - _arg1) - (_local3 - _arg2)));
            if (_local4 == 0)
            {
                _local4 = 1;
            };
            _local5 = 0;
            _local6 = _arg1;
            _local8 = 0;
            while (_local8 < _local4)
            {
                if (_local6 >= _local3)
                {
                    _local6 = 0;
                };
                _local7 = this.m_vIntervals[_local6];
                if (_local7 == 0)
                {
                    _local5 = (_local5 + m_dwInterval);
                }
                else
                {
                    _local5 = (_local5 + _local7);
                };
                _local6++;
                _local8++;
            };
            return (_local5);
        }

        override public function destruct():void
        {
            super.destruct();
            this.m_vIntervals = null;
        }

        public function get specialFrameEnable():Boolean
        {
            return (this.m_specialFrameEnable);
        }

        public function getTotleTime():int
        {
            var _local4:* = null;
            var _local3:* = null;
            var _local2:* = null;
            var _local1:* = null;
            _local2 = 0;
            _local3 = 0;
            _local1 = this.m_vIntervals.length;
            _local4 = 0;
            while (_local4 < _local1)
            {
                _local3 = this.m_vIntervals[_local4];
                if (_local3 == 0)
                {
                    _local2 = (_local2 + m_dwInterval);
                }
                else
                {
                    _local2 = (_local2 + _local3);
                };
                _local4++;
            };
            return (_local2);
        }


    }
}//package wylib.Packs.BitmapPack
