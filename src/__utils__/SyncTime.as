package __utils__
{
    public class SyncTime 
    {
        private static var m_nCurTimer:int;

        public static function get currentTimer():int
        {
            return m_nCurTimer;
        }

        public static function setTime(value:int):void
        {
            m_nCurTimer = value;
        }
    }
}