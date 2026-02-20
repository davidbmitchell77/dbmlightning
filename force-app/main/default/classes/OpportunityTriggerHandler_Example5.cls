public class OpportunityTriggerHandler_Example5 {
    private final TriggerOperation operationType;
    private final String className;

    public OpportunityTriggerHandler_Example5(TriggerOperation to) {
        this.operationType = to;
        this.className = String.valueOf(this).substring(0,String.valueOf(this).indexOf(':'));
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
                checkUserProfile(oldOptys, newOptys, oldMap, newMap);
            }
            when AFTER_INSERT {
                sendNotificationEmails(oldOptys, newOptys, oldMap, newMap);
            }
            when AFTER_UPDATE {
                sendNotificationEmails(oldOptys, newOptys, oldMap, newMap);
            }
            when AFTER_DELETE {

            }
            when AFTER_UNDELETE {

            }
        }
    }

    private void checkUserProfile(List<Opportunity> oldOptys, List<Opportunity> newOptys, Map<Id,Opportunity> oldMap, Map<Id,Opportunity> newMap) {
        Id sysAdminProfileId = [SELECT Id FROM Profile WHERE Name = 'System Administrator' LIMIT 1].Id;
        for (Opportunity o : oldOptys) {
            if (UserInfo.getProfileId() != sysAdminProfileId) {
                o.addError(System.Label.USER_NOT_AUTHORIZED_TO_DELETE_OPPORTUNITY_RECORDS);
            }
        }
    }

    private void sendNotificationEmails(List<Opportunity> oldOptys, List<Opportunity> newOptys, Map<Id,Opportunity> oldMap, Map<Id,Opportunity> newMap) {
        List<Opportunity> opportunities = new List<Opportunity>();

        for (Opportunity o : [SELECT Id, Name,
                                     OwnerId, Owner.Email,
                                     Account.Name, Account.OwnerId, Account.Owner.Email
                                FROM Opportunity
                               WHERE (Id IN :newMap.keySet())
                                 AND (StageName = 'Closed/Won')
        ]) {
            if (nvl(oldMap, o.Id).get(o.Id).StageName != 'Closed/Won') {
                opportunities.add(o);
            }
        }

        if (!opportunities.isEmpty()) {
            sendEmails(opportunities);
        }
    }

    private void sendEmails(List<Opportunity> opportunities) {
        List<List<Messaging.SingleEmailMessage>> outboxes = new List<List<Messaging.SingleEmailMessage>>();

        for (Integer i=0; i<opportunities.size(); i++) {
            Opportunity o = opportunities[i];
            Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
            if (prefix(o.OwnerId) == '005') {
                email.ToAddresses   = new List<String>{ o.Owner.Email };
                email.Subject       = System.Label.OPPORTUNITY_HAS_BEEN_ASSIGNED_TO_YOU;
                email.HtmlBody      = o.Name;
                email.PlainTextBody = o.Name;
                email.WhatId        = o.Id;
                email.EmailPriority = 'Normal';
                outboxes[((Integer)i/100)].add(email);
            }
            if (prefix(o.Account.OwnerId) == '005') {
                email.ToAddresses   = new List<String>{ o.Account.Owner.Email };
                email.Subject       = System.Label.OPPORTUNITY_HAS_BEEN_ASSIGNED_TO_YOUR_ACCOUNT;
                email.HtmlBody      = (o.Account.Name + '|' + o.Name);
                email.PlainTextBody = (o.Account.Name + '|' + o.Name);
                email.WhatId        = o.Id;
                email.EmailPriority = 'Normal';
                outboxes[((Integer)i/100)].add(email);
            }
        }

        for (List<Messaging.SingleEmailMessage> outbox : outboxes) {
            for (Messaging.SendEmailResult sr : Messaging.sendEmail(outbox, false)) {
                if (!sr.isSuccess()) {
                    for (Messaging.SendEmailError e : sr.getErrors()) {
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

    private Map<Id,Opportunity> nvl(Map<Id,Opportunity> optyMap, Id optyId) {
        Map<Id,Opportunity> theMap = new Map<Id,Opportunity>();
        switch on this.operationType {
            when AFTER_INSERT {
                theMap.put(optyId, new Opportunity(Id=optyId, StageName=''));
            }
            when AFTER_UPDATE {
                theMap = optyMap;
            }
        }
        return theMap;
    }

    private String prefix(Id recordId) {
        return String.valueOf(recordId).substring(0,3);
    }
}