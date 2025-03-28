public class myQueueableApex implements System.Queueable, System.Finalizer
{
    /*----------------------------------------------------------------------------*/
    /* @class         - myQueueableApex                                           */
    /* @date          - 20-DEC-2021                                               */
    /* @author        - David B. Mitchell (Infosys Limited)                       */
    /* @description   - Sample queueable with finalizer apex class.               */
    /*----------------------------------------------------------------------------*/
    public final Boolean all;
    public final Boolean allOrNone;
    public final Integer batchSize;

    private List<LogMessage__c> logMessages = new List<LogMessage__c>();

    public myQueueableApex()
    {
        all = false;
        allOrNone = true;
        batchSize = 200;
    }

    public void execute(QueueableContext QC)
    {
        String jobId = String.valueof(QC.getJobId());

        System.debug('Begin: executing queueable job ' + jobId + '.');
        myQueueableApex myFinalizer = new myQueueableApex();
        System.attachFinalizer(myFinalizer);

        myFinalizer.addLog(System.now(), 'About to do some work...', jobId);
      //Integer i = (1 / 0);  // Causes "Divide by 0" error.
        System.debug('Completed: execution of queueable job ' + jobId + '.');
        myFutureMethod();
    }

    public void execute(FinalizerContext FC)
    {
        String requestId = FC.getRequestId();
        String parentJobId = FC.getAsyncApexJobId();
        System.debug('Begin: executing finalizer attached to queueable job ' + parentJobId + '.');

        System.debug('Updating job id on ' + logMessages.size() + ' log message records...');
        for (LogMessage__c log : logMessages)
        {
            log.RequestId__c = requestId;
            log.ParentJobId__c = parentJobId;
        }
        System.debug('Log records updated.');

        System.debug('Committing log records to database...');
        Database.insert(logMessages, all);
        System.debug('Log records committed.');

        if (FC.getResult() == ParentJobResult.SUCCESS)
        {
            System.debug('Parent queueable job [' + parentJobId + '] completed successfully.');
            String batchJobId = Database.executeBatch(new mySchedulableApex(), batchSize); // This call fails after 5 retries.
            System.debug('Enqueued retry job: ' + batchJobId + '.');
        }
        else
        {
            System.debug('Parent queueable job [' + parentJobId + '] failed due to unhandled exception: ' + FC.getException().getMessage());
          //String newJobId = System.enqueueJob(new myQueueableApex()); // This call fails after 5 retries.
          //System.debug('Enqueued retry job: ' + newJobId + '.');
        }
 
        System.debug('Completed: execution of finalizer attached to queueable job: ' + parentJobId + '.');
    }

    public void addLog(Datetime logDate, String message, String source)
    {
        LogMessage__c lm = new LogMessage__c();
        lm.LogDate__c = logDate;
        lm.Message__c = message;
        lm.RequestId__c = 'setbeforecommit';
        lm.ParentJobId__c = 'setbeforecommit';
        lm.Source__c = source;
        logMessages.add(lm);
    }

    @future
    public static void myFutureMethod() {
        Logger.debug('This is from the future method.');
        Logger.saveLog();
    }
}