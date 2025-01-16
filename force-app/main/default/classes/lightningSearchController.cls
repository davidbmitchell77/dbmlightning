public class lightningSearchController
{
    private static final Integer maxRecords = 255;

    @auraEnabled
    public static Map<String, List<sObject>> getMap(String searchString)
    {
        List<Account> accounts = new List<Account>();
        List<Contact> contacts = new List<Contact>();

        accounts = Database.query(getAccountQuery(searchString));
        contacts = Database.query(getContactQuery(searchString));

        Map<String, List<sObject>> result = new Map<String, List<sObject>>();
        result.put('accounts', accounts);
        result.put('contacts', contacts);

        return result;
    }

    private static String getAccountQuery(String s)
    {
        String result = '';
        result += 'SELECT Id, Name, BillingStreet, BillingCity, BillingState, BillingPostalCode';
        result += ', Phone ';
        result += 'FROM Account ';
        result += ((s > '') ? 'WHERE Name LIKE \'%' + s + '%\' ' : '');
        result += 'ORDER BY Name ';
        result += 'LIMIT ' + String.valueOf(maxRecords);
        return result;
    }

    private static String getContactQuery(String s)
    {
        String result = '';
        result += 'SELECT Id, Name, MailingStreet, MailingCity, MailingState, MailingPostalCode ';
        result += ', Phone ';
        result += 'FROM Contact ';
        result += ((s > '') ? 'WHERE Name LIKE \'%' + s + '%\' ' : '');
        result += 'ORDER BY Name ';
        result += 'LIMIT ' + String.valueOf(maxRecords);
        return result;
    }
}