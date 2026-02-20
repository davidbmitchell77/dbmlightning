@isTest
private class OpportunityTriggerTest {
    @TestSetup
    private static void dataFactory() {
        String convertedStatus = [SELECT ApiName FROM LeadStatus WHERE IsConverted = true LIMIT 1].ApiName;
        String defaultStatus   = [SELECT ApiName FROM LeadStatus WHERE IsDefault = true LIMIT 1].ApiName;
        Lead l = new Lead(
            FirstName     = 'Test',
            LastName      = 'Customer',
            Company       = 'Test Company Inc.',
            Phone         = '(000) 000-0000',
            Email         = 'test.customer@testcompany.com',
            AnnualRevenue = 100000.00,
            Status        = defaultStatus
        );
        insert l;
        Database.LeadConvert lc = new Database.LeadConvert();
        lc.setLeadId(l.Id);
        lc.setConvertedStatus(convertedStatus);
        lc.setDoNotCreateOpportunity(false);
        lc.setOpportunityName(l.Company);
        for (Database.LeadConvertResult lcr : Database.convertLead(new List<Database.LeadConvert>{ lc }, false)) {
            if (!lcr.isSuccess()) {
                for (Database.Error e : lcr.getErrors()) {
                    System.debug(LoggingLevel.Error, ('OpportunityTriggerTest.dataFactory: ' + e.getStatusCode() + '|' + e.getMessage()));
                }
            }
        }
        Opportunity o = [SELECT Id, Name FROM Opportunity LIMIT 1];
        o.Amount = l.AnnualRevenue;
        o.Probability = 100;
        update o;
    }

    @isTest
    private static void test01_insert() {
        Lead l = [SELECT Id, Name, ConvertedDate, ConvertedAccountId, ConvertedContactId, AnnualRevenue FROM Lead WHERE IsConverted = true LIMIT 1];
        Test.startTest();
        Opportunity o = [SELECT Id, Name, AccountId, ContactId, Amount FROM Opportunity LIMIT 1];
        Account a = [SELECT Id, Name, MaximumExpectedOpportunityRevenue__c FROM Account WHERE Id = :o.AccountId];
        Test.stopTest();
        System.assertEquals(o.Amount, l.AnnualRevenue);
        System.assertEquals(o.Amount, a.MaximumExpectedOpportunityRevenue__c);
    }

    @isTest
    private static void test02_update() {
        Opportunity o = [SELECT Id, Name, AccountId, ContactId, Amount FROM Opportunity LIMIT 1];
        Test.startTest();
        o.Amount = 2000000.00;
        update o;
        Test.stopTest();
        Lead l = [SELECT Id, Name, ConvertedDate, ConvertedAccountId, ConvertedContactId, AnnualRevenue FROM Lead WHERE IsConverted = true LIMIT 1];
        Account a = [SELECT Id, Name, MaximumExpectedOpportunityRevenue__c FROM Account WHERE Id = :o.AccountId];
        System.assertNotEquals(o.Amount, l.AnnualRevenue);
        System.assertEquals(o.Amount, a.MaximumExpectedOpportunityRevenue__c);
    }

    @isTest
    private static void test03_delete() {
        Opportunity o = [SELECT Id, Name, AccountId, ContactId, Amount FROM Opportunity LIMIT 1];
        Test.startTest();
        delete o;
        Test.stopTest();
        Account a = [SELECT Id, Name, MaximumExpectedOpportunityRevenue__c FROM Account WHERE Id = :o.AccountId];
        System.assertEquals(0, [SELECT COUNT() FROM Opportunity]);
        System.assertEquals(0, a.MaximumExpectedOpportunityRevenue__c);
    }

    @isTest
    private static void test04_undelete() {
        Opportunity o = [SELECT Id, Name, AccountId, ContactId, Amount FROM Opportunity LIMIT 1];
        Test.startTest();
        delete o;
        undelete o;
        Test.stopTest();
        Account a = [SELECT Id, Name, MaximumExpectedOpportunityRevenue__c FROM Account WHERE Id = :o.AccountId];
        System.assertEquals(1, [SELECT COUNT() FROM Opportunity]);
        System.assertEquals(o.Amount, a.MaximumExpectedOpportunityRevenue__c);
    }

    @isTest
    private static void test05_validate() {
        Opportunity o = [SELECT Id, Name FROM Opportunity LIMIT 1];
        Test.startTest();
        try {
            update (new Opportunity(Id=o.Id, Name=''));
        }
        catch(Exception e) {
            System.debug(LoggingLevel.WARN, ('OpportunityTriggerTest.test05_validate: ' + e.getMessage()));
        }
        Test.stopTest();
        List<Opportunity> opportunities = [SELECT Id, Name FROM Opportunity];
        System.assertNotEquals(null, [SELECT Name FROM Opportunity LIMIT 1].Name);
        System.assertEquals(o.Name, [SELECT Name FROM Opportunity LIMIT 1].Name);
    }
}