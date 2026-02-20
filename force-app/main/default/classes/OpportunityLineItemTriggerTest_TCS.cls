@isTest
private class OpportunityLineItemTriggerTest_TCS {
    @testSetup
    private static void setup() {
        User u = new User(
            Alias = 'stduser',
            Email = 'standarduser@testorg.com',
            EmailEncodingKey = 'UTF-8',
            LastName = 'Testing',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US',
            ProfileId = [SELECT Id FROM Profile WHERE Name = 'Standard User' LIMIT 1].Id,
            TimeZoneSidKey = 'America/Los_Angeles',
            Username = String.valueOf(UUID.randomUUID()) + '@testorg.com'
        );
        insert u;
        Account a = new Account(
            Name = String.valueOf(UUID.randomUUID()),
            Phone = '(555) 555-5555'
        );
        insert a;
        Opportunity o = new Opportunity(
            Name = a.Name,
            AccountId = a.Id,
            StageName = 'Prospecting',
            Probability = 100.00,
            Amount = 1000.00,
            CloseDate = Date.today()
        );
        insert o;
        Product2 product = new Product2(
            Name = 'Test Product',
            IsActive = true
        );
        insert product;
        PricebookEntry pbe = new PricebookEntry(
            Pricebook2Id = Test.getStandardPricebookId(),
            Product2Id = product.Id,
            UnitPrice = 10.0,
            IsActive = true
        );
        insert pbe;
    }

    @isTest
    private static void test01() {
        User u = [SELECT FIELDS(STANDARD) FROM User WHERE Email = 'standarduser@testorg.com' LIMIT 1];
        Account a = [SELECT Id, Name FROM Account LIMIT 1];
        Opportunity o = [SELECT Id, Name, AccountId, ExpectedRevenue FROM Opportunity WHERE AccountId = :a.Id LIMIT 1];
        Test.startTest();
        System.runAs(u) {
            OpportunityLineItem oli = new OpportunityLineItem(
                OpportunityId = o.Id,
                Quantity = 10,
                TotalPrice = o.ExpectedRevenue,
                PricebookEntryId = [SELECT Id FROM PriceBookEntry LIMIT 1].Id
            );
            insert oli;
        }
        Test.stopTest();
        System.assertEquals(o.ExpectedRevenue, [SELECT MaximumExpectedOpportunityRevenue__c FROM Account WHERE Id = :a.Id].MaximumExpectedOpportunityRevenue__c);
    }

    @isTest
    private static void test02() {
        User u = [SELECT FIELDS(STANDARD) FROM User WHERE Email = 'standarduser@testorg.com' LIMIT 1];
        Account a = [SELECT Id, Name FROM Account LIMIT 1];
        Opportunity o = [SELECT Id, Name, AccountId FROM Opportunity WHERE AccountId = :a.Id LIMIT 1];
        Test.startTest();
        System.runAs(u) {
            o.StageName = 'Closed/Won';
            update o;
        }
        Test.stopTest();
        System.assertEquals('Cold' , [SELECT AccountRating__c FROM Account WHERE Id = :a.Id LIMIT 1].AccountRating__c);
    }
}