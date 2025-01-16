@isTest
private class BusScheduleCache_Test {

    @isTest
    private static void testMethod01() {
        BusScheduleCache busScheduleCache = new BusScheduleCache();
        busScheduleCache.putSchedule('testMethod01', new Time[] {
            Time.newInstance(0,0,0,0),
            Time.newInstance(17,17,17,17)
        });
        Time[] schedule = busScheduleCache.getSchedule('testMethod01');
        System.assertEquals(2, schedule.size());
    }

    @isTest
    private static void testMethod02() {
        BusScheduleCache busScheduleCache = new BusScheduleCache();
        Time[] schedule = busScheduleCache.getSchedule('testMethod02');
        System.assertEquals(null, schedule);
    }
}