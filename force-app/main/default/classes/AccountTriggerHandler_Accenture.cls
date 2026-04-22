/* ----------------------------------------------------------------------------------------*/
/* Business Use Case:                                                                      */
/* When sales rep is working on an account and marks the Close_All_Optys__c field as true, */
/* Automatically close all opportunties related to the account                             */
/* ----------------------------------------------------------------------------------------*/
public with sharing class AccountTriggerHandler_Accenture {
    private final TriggerOperation operationType;
    private final String className;
    private final Date today;

    public AccountTriggerHandler_Accenture(TriggerOperation to) {
        this.operationType = to;
        this.className = 'AccountTriggerHandler_Accenture.cls';
        this.today = Date.today();
    }

    public Boolean isValid(List<Account> accounts) {
        Boolean result = true;
        if (accounts != null) {
            for (Account a : accounts) {
                if (String.isBlank(a.Name)) {
                    a.Name.addError(System.Label.ACCOUNT_NAME_IS_REQUIRED);
                    result = false;
                }
            }
        }
        return result;
    }

    public void run(List<Account> oldAccounts, List<Account> newAccounts, Map<Id,Account> oldMap, Map<Id,Account> newMap) {
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
                updateChildOpportunities(oldAccounts, newAccounts, oldMap, newMap);
            }
            when AFTER_DELETE {

            }
            when AFTER_UNDELETE {

            }
        }
    }

    private void updateChildOpportunities(List<Account> oldAccounts, List<Account> newAccounts, Map<Id,Account> oldMap, Map<Id,Account> newMap) {
        List<Opportunity> opportunities = new List<Opportunity>();

        for (Opportunity o : [SELECT Id, Name
                                FROM Opportunity
                               WHERE AccountId IN :newMap.keySet()
                                 AND Account.Close_All_Optys__c = true
                                 AND IsClosed = false
        ]) {
            opportunities.add(new Opportunity(Id=o.Id, StageName='Closed/Won', CloseDate=this.today));
        }

        if (!opportunities.isEmpty()) {
            for (Database.SaveResult sr : Database.update(opportunities, false)) {
                if (!sr.isSuccess()) {
                    for (Database.Error e : sr.getErrors()) {
                        System.debug(LoggingLevel.ERROR, (this.className + ': ' + e.getStatusCode() + '|' + e.getMessage()));
                    }
                }
            }
        }
    }
}