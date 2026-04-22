/**
* @File Name: CaseTriggerDuplicatesHandler.cls
* @Description: Detect and flag possible duplicate customer complaint case records
* @Author: David B. Mitchell
* @Last Modified By :
* @Last Modified On :
* @Modification Log :
*==============================================================================
* Ver | Date | Author | Modification
*==============================================================================
* 1.0 | September 22, 2025 | David B. Mitchell | Initial Version
**/
public with sharing class CaseTriggerDuplicatesHandler {

    private final TriggerOperation operationType;
    private final Integer maxRecords;

    public CaseTriggerDuplicatesHandler(TriggerOperation to) {
        this.operationType = to;
        this.maxRecords = 5000;
    }

    public Boolean isValid(List<Case> cases) {
        Boolean result = true;
        if (cases != null) {
            for (Case c : cases) {
                if (String.isBlank(c.CaseType__c)) {
                    c.CaseType__c.addError('Case Type is required.');
                    result = false;
                }
            }
        }
        return result;
    }

    public void run(List<Case> oldCases, List<Case> newCases, Map<Id,Case> oldMap, Map<Id,Case> newMap) {
        switch on this.operationType {
            when BEFORE_INSERT {
                checkForDuplicateCaseRecords(oldCases, newCases, oldMap, newMap);
            }
        }
    }

    private void checkForDuplicateCaseRecords(List<Case> oldCases, List<Case> newCases, Map<Id,Case> oldMap, Map<Id,Case> newMap) {
        Map<String,Case> existingCases = new Map<String,Case>();
        for (Case c : [SELECT Id,
                              CaseNumber,
                              RecordType.Name,
                              RecordType.DeveloperName,
                              Subject,
                              CaseType__c,
                              CaseSubType__c,
                              AccountId,
                              ContactId
                         FROM Case
                        WHERE (RecordType.DeveloperName = 'Customer_Complaints')
                          AND (CreatedDate >= :Datetime.now().addHours(-48))
                          AND (AccountId IN :accountIds(newCases) OR ContactId IN :contactIds(newCases))
                          AND (IsClosed = false)
                         WITH SYSTEM_MODE
                     ORDER BY CreatedDate DESC
                        LIMIT :maxRecords
        ]) {
            existingCases.put(dupKey(c), c);
        }
        Map<Id,Contact> contacts = new Map<Id,Contact>([SELECT Id, AccountId FROM Contact WHERE Id IN :contactIds(newCases) AND AccountId != null]);
        for (Case c : newCases) {
            if (c.RecordTypeId != null) {
                c.AccountId = nvl(c.AccountId, (contacts.containsKey(c.ContactId) ? contacts.get(c.ContactId).AccountId : null));
                if (existingCases.containsKey(dupKey(c))) {
                    c.Description = duplicateCaseMessage(c, existingCases.get(dupKey(c))) + '\n\n' + nvl(c.Description, '');
                }
            }
        }
    }

    private Set<Id> accountIds(List<Case> cases) {
        Set<Id> results = new Set<Id>();
        if (cases != null) {
            for (Case c : cases) {
                if (c.AccountId != null) {
                    if (!results.contains(c.AccountId)) {
                        results.add(c.AccountId);
                    }
                }
            }
        }
        return results;
    }

    private Set<Id> contactIds(List<Case> cases) {
        Set<Id> results = new Set<Id>();
        if (cases != null) {
            for (Case c : cases) {
                if (c.ContactId != null) {
                    if (!results.contains(c.ContactId)) {
                        results.add(c.ContactId);
                    }
                }
            }
        }
        return results;
    }

    private String dupKey(Case c) {
        String s = '';
        s += nvl(c.RecordTypeId, '');
        s += '.' + nvl(c.CaseType__c, '').replaceAll('\\.', '');
        s += '.' + nvl(c.CaseSubType__c, '').replaceAll('\\.', '');
        s += '.' + nvl(c.AccountId, '');
        s += '.' + nvl(c.ContactId, '');
        s = s.replaceAll(' ', '_').toLowerCase();
        return s;
    }

    private String duplicateCaseMessage(Case newCase, Case existingCase) {
        String s = '';
        s += 'NOTE: This ' + recordTypeName(newCase.RecordTypeId) + ' may have already been submitted under ';
        s += 'case number ' + existingCase.CaseNumber + '.';
        return s;
    }

    private String nvl(String s, String defaultValue) {
        return ((String.isBlank(s)) ? defaultValue : s);
    }

    private String recordTypeName(Id recordTypeId) {
        return nvl(SObjectType.Case.getRecordTypeInfosById().get(recordTypeId).getName().toLowerCase().replace('customer complaints', 'customer complaint'), 'issue');
    }
}