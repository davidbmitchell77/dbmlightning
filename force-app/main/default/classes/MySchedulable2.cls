global class MySchedulable2 implements Schedulable {

    global MySchedulable2() {
    }

    global void execute(System.SchedulableContext sc) {
        doTheNeedful('Hello from MySchedulable2 apex class!');
    }

    @future(callout=true)
    private static void doTheNeedful(String s) {
        Logger.debug(s);
        Logger.saveLog();
    }
}