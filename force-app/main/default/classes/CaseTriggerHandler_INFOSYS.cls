public with sharing class CaseTriggerHandler_INFOSYS {
    private final TriggerOperation operationType;
    private final String className;

    public CaseTriggerHandler_INFOSYS(TriggerOperation to) {
        this.operationType = to;
        this.className = 'CaseTriggerHandler_INFOSYS.cls';
    }

    public Boolean isValid(List<Case> cases) {
       Boolean result = true;
       if (cases != null) {
           for (Case c : cases) {
               if (String.isBlank(c.Subject)) {
                   c.Subject.addError(System.Label.CASE_SUBJECT_MUST_NOT_BE_BLANK);
                   result = false;
               }
           }
       }
       return result;
    }

    public void run(List<Case> oldCases, List<Case> newCases, Map<Id,Case> oldMap, Map<Id,Case> newMap) {
        switch on this.operationType {
            when BEFORE_INSERT {

            }
            when BEFORE_UPDATE {

            }
            when BEFORE_DELETE {

            }
            when AFTER_INSERT {
                updateParentAccounts(oldCases, newCases, oldMap, newMap);
            }
            when AFTER_UPDATE {
                updateParentAccounts(oldCases, newCases, oldMap, newMap);
            }
            when AFTER_DELETE {
                updateParentAccounts(oldCases, newCases, oldMap, newMap);
            }
            when AFTER_UNDELETE {
                updateParentAccounts(oldCases, newCases, oldMap, newMap);
            }
        }
    }

    private void updateParentAccounts(List<Case> oldCases, List<Case> newCases, Map<Id,Case> oldMap, Map<Id,Case> newMap) {
        List<Account> accounts = new List<Account>();

        for (AggregateResult agr : [SELECT AccountId, COUNT(Id) cases
                                      FROM Case
                                     WHERE Id IN :nvl(oldMap.keySet(), newMap.keySet())
                                       AND IsClosed = true
                                  GROUP BY AccountId
        ]) {
            Account a = new Account(Id=(Id)agr.get('AccountId'), AccountRating__c=accountRating((Integer)agr.get('cases')));
            accounts.add(a);
        }

        if (!accounts.isEmpty()) {
            for (Database.SaveResult sr : Database.update(accounts, false)) {
               if (!sr.isSuccess()) {
                   for (Database.Error e : sr.getErrors()) {
                       System.debug(LoggingLevel.ERROR, (this.className + ': ' + e.getStatusCode() + '|' + e.getMessage()));
                   }
               }
            }
        }
    }

    private String accountRating(Integer closedCases) {
        String result = 'Cold';
        if (closedCases > 100) { result = 'Critical'; } else
        if (closedCases > 50 ) { result = 'Hot';      } else
        if (closedCases > 10 ) { result = 'Warm';     }
        return result;
    }

    private Set<Id> nvl(Set<Id> set1, Set<Id> set2) {
        return (this.operationType == TriggerOperation.AFTER_DELETE ? set1 : set2);
    }
}