/* ------------------------------------------------------------------------------------------------ */
/* Business Use Case : Your company XYZ corp. wants to automate the creation of follow-up tasks for */
/* sales representatives whenever an opportunity’s stage changes in the Salesforce org.             */
/* ------------------------------------------------------------------------------------------------ */
public with sharing class OpportunityTriggerHandler_Capgemini {
    private final TriggerOperation operationType;
    private final String className;
    private final Date today;

    public OpportunityTriggerHandler_Capgemini(TriggerOperation to) {
        this.operationType = to;
        this.className = 'OpportunityTriggerHandler_Capgemini.cls';
        this.today = Date.today();
    }

    public Boolean isValid(List<Opportunity> opportunities) {
        Boolean result = true;
        if (opportunities != null) {
            for (Opportunity o : opportunities) {
                if (String.isBlank(o.Name)) {
                    o.Name.addError(Label.OPPORTUNITY_NAME_IS_REQUIRED);
                    result = false;
                }
            }
        }
        return true;
    }

    public void run(List<Opportunity> oldOptys, List<Opportunity> newOptys, Map<Id,Opportunity> oldMap, Map<Id,Opportunity> newMap) {
        switch on this.operationType {
            when BEFORE_INSERT {

            }
            when BEFORE_UPDATE {

            }
            when BEFORE_DELETE {

            }
            when AFTER_INSERT {

            }
            when AFTER_UPDATE {
                createChildTasks(oldOptys, newOptys, oldMap, newMap);
            }
            when AFTER_DELETE {

            }
            when AFTER_UNDELETE {

            }
        }
    }

    private void createChildTasks(List<Opportunity> oldOptys, List<Opportunity> newOptys, Map<Id,Opportunity> oldMap, Map<Id,Opportunity> newMap) {
        List<Task> tasks = new List<Task>();

        for (Opportunity o : newOptys) {
            Opportunity oldOpty = oldMap.get(o.Id);
            Opportunity newOpty = newMap.get(o.Id);
            if (oldOpty.StageName != newOpty.StageName) {
                Task t = new Task();
                t.WhatId = o.Id;
                t.Subject = 'Auto-Generated Task';
                t.Description = 'This is very important!';
                t.OwnerId = o.OwnerId;
                t.ActivityDate = this.today.addDays(2);
                t.Priority = 'Normal';
                t.Status = 'Not Started';
                tasks.add(t);
            }
        }

        if (!tasks.isEmpty()) {
            for (Database.SaveResult sr : Database.insert(tasks, false)) {
                if (!sr.isSuccess()) {
                    for (Database.Error e : sr.getErrors()) {
                        System.debug(LoggingLevel.ERROR, (this.className + ': ' + e.getStatusCode() + '|' + e.getMessage()));
                    }
                }
            }
        }
    }
}