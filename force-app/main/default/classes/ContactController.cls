public with sharing class ContactController {
    private static final Integer cacheSize = 50;

    @AuraEnabled(cacheable=true)
    public static List<Contact> getContactList() {
        return [SELECT Id,
                       Name,
                       Title,
                       Email
                  FROM Contact
                  WITH SECURITY_ENFORCED
                 LIMIT :cacheSize
        ];
    }
    
    @AuraEnabled(cacheable=true)
    public static List<Contact> getContacts(String accountName, String lwcName) {
        return [SELECT Id,
                       Name,
                       Title,
                       Email,
                       AccountId,
                       Account.Name
                  FROM Contact
                  WHERE AccountId IN (SELECT Id FROM Account WHERE Name LIKE :('%' + accountName + '%'))
                  WITH SECURITY_ENFORCED
                 LIMIT :cacheSize
        ];
    }
}