public class BusScheduleCache {

    private Cache.OrgPartition part;

    public BusScheduleCache() {
        part = Cache.Org.getPartition('local.BusSchedule');
    }

    public void putSchedule(String busLine, Time[] schedule) {
        part.put(busLine, schedule);
    }

    public Time[] getSchedule(String busLine)
    {
        Time[] cachedSchedule = (Time[])part.get(busline);

        if (cachedSchedule == null) {
            logCacheMiss(busLine);
        }

        return ((cachedSchedule != null) ? cachedSchedule : null);
    }
    
    private void logCacheMiss(String keyName) {
            System.debug(LoggingLevel.WARN, 'Cached value not found for key "' + keyName + '" in org partition ' + part.getName() + '.');
            Logger.warn('Cached value not found for key "' + keyName + '" in org partition ' + part.getName() + '.');
            Logger.saveLog();
    }
}