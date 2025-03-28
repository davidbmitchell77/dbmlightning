global class mySchedulableApex2 implements System.Schedulable {

    global void execute(SchedulableContext SC) {
        myFutureMethod();
    }

    @future
    private static void myFutureMethod() {
        Logger.debug('Hello from mySchedulableApex2.myFutureMethod()!');
        Logger.saveLog();
    }
}