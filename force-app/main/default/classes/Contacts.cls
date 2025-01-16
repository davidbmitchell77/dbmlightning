public with sharing class Contacts {

    private static final Integer maxRecords = 200;

    @AuraEnabled(cacheable=true)
    public static List<Contact> getRecords(String searchExpr) {
        return [
            SELECT Id,
                   Name,
                   FirstName,
                   LastName,
                   Email,
                   Phone,
                   Account.Name
              FROM Contact
             WHERE Account.Name LIKE :('%' + searchExpr + '%')
              WITH SECURITY_ENFORCED
          ORDER BY Name ASC
             LIMIT :maxRecords
        ];
    }
}