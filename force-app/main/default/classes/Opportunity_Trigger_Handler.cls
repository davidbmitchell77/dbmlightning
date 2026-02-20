public with sharing class Opportunity_Trigger_Handler {
    private final TriggerOperation operationType;
    private final String apexClassName;

    public Opportunity_Trigger_Handler(TriggerOperation to) {
        this.operationType = to;
        this.apexClassName = String.valueOf(this).substring(0,String.valueOf(this).indexOf(':'));
    }

    public Boolean isValid(List<Opportunity> opportunities) {
        Boolean result = true;
        if (opportunities != null) {
            for (Opportunity o : opportunities) {
                if (String.isBlank(o.Name)) {
                  o.Name.addError(System.Label.OPPORTUNITY_NAME_IS_REQUIRED);
                  result = false;
                }
            }
        }
        if (result == false) {
            if (SYS_UTILS.isBatch() || SYS_UTILS.isTest()) {
                throw new SYS_UTILS.SYS_EXCEPTION(System.Label.OPPORTUNITY_RECORD_DATA_IS_NOT_VALID);
            }
        }
        return result;
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
                createChildTasks(null, newOptys, null, newMap);
                updateAccountsMaxRevenue(null, newOptys, null, newMap);
            }
            when AFTER_UPDATE {
                updateAccountsMaxRevenue(oldOptys, newOptys, oldMap, newMap);
            }
            when AFTER_DELETE {
                updateAccountsMaxRevenue(oldOptys, null, oldMap, null);
            }
            when AFTER_UNDELETE {
                updateAccountsMaxRevenue(null, newOptys, null, newMap);
            }
        }
        updateProcessedRecordIds(this.operationType, oldOptys, newOptys);
    }

    private void createChildTasks(List<Opportunity> oldOptys, List<Opportunity> newOptys, Map<Id,Opportunity> oldMap, Map<Id,Opportunity> newMap) {
        List<Task> tasks = new List<Task>();
        if (newOptys != null) {
            for (Opportunity o : newOptys) {
                if (o.Id != null) {
                    if (!alreadyInvoked(this.operationType, o.Id)) {
                        if (isNewOpportunity(o)) {
                            tasks.add(newTask(o));
                        }
                    }
                }
            }
        }
        if (!tasks.isEmpty()) {
            DB_UTILS.ins(tasks);
        }
    }

    private void updateAccountsMaxRevenue(List<Opportunity> oldOptys, List<Opportunity> newOptys, Map<Id,Opportunity> oldMap, Map<Id,Opportunity> newMap) {
        Map<Id,Account> accounts = new Map<Id,Account>();
        for (Opportunity o : nvl(newoptys, oldOptys)) {
            accounts.put(o.AccountId, new Account(Id=o.AccountId, MaximumExpectedOpportunityRevenue__c=0.00));
        }

        for (AggregateResult agr : [SELECT AccountId, MAX(ExpectedRevenue) maxExpectedRevenue
                                      FROM Opportunity
                                     WHERE AccountId IN :accountIds(nvl(newOptys, oldOptys))
                                      WITH SYSTEM_MODE
                                  GROUP BY AccountId
        ]) {
            Account a = new Account(Id=(Id)agr.get('AccountId'), MaximumExpectedOpportunityRevenue__c=(Decimal)agr.get('maxExpectedRevenue'));
            accounts.put(a.Id, a);
        }

        if (!accounts.values().isEmpty()) {
            DB_UTILS.ups(accounts.values());
        }
    }

    private Set<Id> accountIds(List<Opportunity> opportunities) {
        Set<Id> results = new Set<Id>();
        if (opportunities != null) {
            for (Opportunity o : opportunities) {
                if (o.AccountId != null) {
                    if (!results.contains(o.AccountId)) {
                        results.add(o.AccountId);
                    }
                }
            }
        }
        return results;
    }

    private Boolean alreadyInvoked(TriggerOperation to, Id opportunityId) {
        return Opportunity_Trigger_Recursion.alreadyInvoked(to, opportunityId);
    }

    private Boolean isNewOpportunity(Opportunity o) {
        Boolean result = false;
        switch on o.StageName {
            when 'Needs Analysis'    { result = true; }
            when 'Prospecting'       { result = true; }
            when 'Qualification'     { result = true; }
            when 'Value Proposition' { result = true; }
        }
        return result;
    }

    private Task newTask(Opportunity o) {
        return new Task(
            Subject  = o.Name,
            Status   = 'Open',
            Priority = 'Normal',
            WhatId   = o.Id,
            OwnerId  = ((o.Account != null) ? o.Account.OwnerId : o.OwnerId)
        );
    }

    private void updateProcessedRecordIds(TriggerOperation to, List<Opportunity> oldOpportunities, List<Opportunity> newOpportunities) {
        Opportunity_Trigger_Recursion.updateProcessedRecordIds(to, oldOpportunities, newOpportunities);
    }

    private List<Opportunity> nvl(List<Opportunity> list1, List<Opportunity> list2) {
        return ((list1 != null) ? list1 : list2);
    }
}