public with sharing class AccountController {
    private static final Integer maxRecords = 5;

    @AuraEnabled(cacheable=true)
    public static List<Account> getAccountList() {
        List<Account> results = new List<Account>();
        try {
            results = [SELECT Id,
                              Name,
                              Type,
                              Industry
                         FROM Account
                         WITH SECURITY_ENFORCED
                     ORDER BY Name ASC
                        LIMIT :maxRecords
            ];
        }
        catch(Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
        return results;
    }

    @AuraEnabled(cacheable=true)
    public static List<Account> getAccountListByType(String type) {
        List<Account> results = new List<Account>();
        try {
            results = [SELECT Id,
                              Name,
                              Type,
                              Industry
                         FROM Account
                        WHERE Type = :type
                         WITH SECURITY_ENFORCED
                        LIMIT :maxRecords
            ];
        }
        catch(Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
        return results;
    }

    @AuraEnabled(cacheable=true)
    public static List<Account> getAccountListBySearchKey(String searchKey) {
        List<Account> results = new List<Account>();
        try {
            results = [SELECT Id,
                              Name,
                              Type,
                              Industry
                         FROM Account
                        WHERE Name LIKE :('%' + searchKey + '%')
                         WITH SECURITY_ENFORCED
                        LIMIT :maxRecords
            ];
        }
        catch(Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
        return results;
    }

    @AuraEnabled(cacheable=true)
    public static List<Contact> getContacts(String accountId) {
        return [SELECT Id,
                       Name,
                       Title,
                       Email,
                       AccountId,
                       Account.Name
                  FROM Contact
                  WHERE AccountId = :accountId
                  WITH SECURITY_ENFORCED
                 LIMIT 200
        ];
    }
}