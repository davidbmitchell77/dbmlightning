/*--------------------------------------------------------------------------------------------------*/
/* Business Use Case:                                                                               */
/* A Sales Organization wants to track the largest Opportunity associated with each of its Accounts */
/* This information could be used to prioritize sales efforts, allocate resources, or identify      */
/* opportunities for cross-selling or upselling.                                                    */
/*--------------------------------------------------------------------------------------------------*/
public with sharing class OpportunityTriggerHandler_TCS {
    private final TriggerOperation operationType;
    private final String className;

    public OpportunityTriggerHandler_TCS(TriggerOperation to) {
        this.operationType = to;
        this.className = String.valueOf(this).substring(0, String.valueOf(this).indexOf(':')) + '.cls';
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
                updateParentAccounts(newOptys);
            }
            when AFTER_UPDATE {
                updateParentAccounts(newOptys);
            }
            when AFTER_DELETE {
                updateParentAccounts(oldOptys);
            }
            when AFTER_UNDELETE {
                updateParentAccounts(newOptys);
            }
        }
    }

    public void updateParentAccounts(List<Opportunity> opportunities) {
        List<Account> parentAccounts = new List<Account>();

        for (AggregateResult agr : [SELECT Opportunity.AccountId, MAX(ExpectedRevenue) maxRevenue
                                      FROM Opportunity
                                     WHERE AccountId IN :accountIds(opportunities)
                                  GROUP BY Opportunity.AccountId
        ]) {
            parentAccounts.add(new Account(Id=(Id)agr.get('AccountId'), MaximumExpectedOpportunityRevenue__c=(Decimal)agr.get('maxRevenue')));
        }

        if (!parentAccounts.isEmpty()) {
            for (Database.SaveResult sr : Database.update(parentAccounts, false)) {
                if (!sr.isSuccess()) {
                    for (Database.Error e : sr.getErrors()) {
                        System.debug(LoggingLevel.ERROR, (this.className + ': ' + e.getStatusCode() + '|' + e.getMessage()));
                    }
                }
            }
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
}