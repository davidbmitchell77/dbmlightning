public with sharing class ExpensesController {
    @AuraEnabled
    public static List<Expense__c> getExpenses() {

      //Perform isUpdateable() checking first
        if (!isUpdateable()) {
            throw new System.NoAccessException();
        }

      //OK, they're cool, let 'em through
        return [SELECT Id,
                       Name,
                       Amount__c,
                       Client__c,
                       Date__c, 
                       Reimbursed__c,
                       CreatedDate
                  FROM Expense__c
                 LIMIT 255];
    }

    @AuraEnabled
    public static Expense__c saveExpense(Expense__c expense) {
        if (!isUpdateable()) {
            throw new System.NoAccessException();
        }
        upsert expense;
        return expense;
    }

    private static Boolean isUpdateable() {
        Boolean result = true;

      //Check to make sure all fields are accessible to this user
        String[] fieldsToCheck = new String[] {
            'Id',
            'Name',
            'Amount__c',
            'Client__c',
            'Date__c', 
            'Reimbursed__c',
            'CreatedDate'
        };        

        Map<String,Schema.SObjectField> fieldDescribeTokens = Schema.SObjectType.Expense__c.fields.getMap();

        for(String field : fieldsToCheck) {
            if(!fieldDescribeTokens.get(field).getDescribe().isAccessible()) {
                result = false;
            }
        }

        return result;
    }
}