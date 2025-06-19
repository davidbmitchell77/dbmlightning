@isTest
private class QuoteLineItem_Trigger_Test {
    @isTest
    private static void TestMethod01() {
        Account a = new Account();
        a.Name = 'QuoteLineItem__Trigger_Test.TestMethod01()';
        a.Phone = '(111) 111-1111';
        a.MaximumExpectedOpportunityRevenue__c = 100000;
        insert a;
        Opportunity o = new Opportunity();
        o.Name = 'QuoteLineItem_Trigger_Test.TestMethod01()';
        o.Amount = 1000000;
        o.Probability = 50;
        o.AccountId = a.Id;
        o.StageName = 'Prospecting';
        o.CloseDate = (System.today() + 30);
        insert o;
        Product2 p = new Product2(
            Name = 'Test Product',
            ProductCode = 'TP001',
            IsActive = true
        );
        insert p;
        PricebookEntry pbe = new PricebookEntry();
        pbe.Pricebook2Id = Test.getStandardPricebookId();
        pbe.Product2Id = p.Id;
        pbe.UnitPrice = 100;
        pbe.IsActive = true;
        pbe.CurrencyIsoCode = 'USD';
        insert pbe;
        Quote q = new Quote();
        q.Name = 'Test Quote 1';
        q.ExpirationDate = System.today().addDays(30);
        q.Status = 'Draft';
        q.OpportunityId = o.Id;
        q.Pricebook2Id = Test.getStandardPricebookId();
        insert q;

        Test.startTest();
        QuoteLineItem qli = new QuoteLineItem();
        qli.QuoteId = q.Id;
        qli.PricebookEntryId = pbe.Id;
        qli.Quantity = 5;
        qli.UnitPrice = 7.00;
        qli.Product2Id = p.Id;
        insert qli;
        Test.stopTest();
    }

    @isTest
    private static void TestMethod02() {
        Account a = new Account();
        a.Name = 'QuoteLineItem__Trigger_Test.TestMethod02()';
        a.Phone = '(222) 222-2222';
        a.MaximumExpectedOpportunityRevenue__c = 100000;
        insert a;
        Opportunity o = new Opportunity();
        o.Name = 'QuoteLineItem_Trigger_Test.TestMethod02()';
        o.Amount = 1000000;
        o.Probability = 50;
        o.AccountId = a.Id;
        o.StageName = 'Prospecting';
        o.CloseDate = (System.today() + 30);
        insert o;
        Product2 p = new Product2(
            Name = 'Test Product',
            ProductCode = 'TP001',
            IsActive = true
        );
        insert p;
        PricebookEntry pbe = new PricebookEntry();
        pbe.Pricebook2Id = Test.getStandardPricebookId();
        pbe.Product2Id = p.Id;
        pbe.UnitPrice = 100;
        pbe.IsActive = true;
        pbe.CurrencyIsoCode = 'USD';
        insert pbe;
        Quote q = new Quote();
        q.Name = 'Test Quote 1';
        q.ExpirationDate = System.today().addDays(30);
        q.Status = 'Draft';
        q.OpportunityId = o.Id;
        q.Pricebook2Id = Test.getStandardPricebookId();
        insert q;

        Test.startTest();
        QuoteLineItem qli = new QuoteLineItem();
        qli.QuoteId = q.Id;
        qli.PricebookEntryId = pbe.Id;
        qli.Quantity = 5;
        qli.UnitPrice = 7.00;
        qli.Product2Id = p.Id;
        insert qli;
        qli.UnitPrice = 70.00;
        update qli;
        Test.stopTest();
    }

    @isTest
    private static void TestMethod03() {
        Account a = new Account();
        a.Name = 'QuoteLineItem__Trigger_Test.TestMethod03()';
        a.Phone = '(333) 333-3333';
        a.MaximumExpectedOpportunityRevenue__c = 100000;
        insert a;
        Opportunity o = new Opportunity();
        o.Name = 'QuoteLineItem_Trigger_Test.TestMethod03()';
        o.Amount = 1000000;
        o.Probability = 50;
        o.AccountId = a.Id;
        o.StageName = 'Prospecting';
        o.CloseDate = (System.today() + 30);
        insert o;
        Product2 p = new Product2(
            Name = 'Test Product',
            ProductCode = 'TP001',
            IsActive = true
        );
        insert p;
        PricebookEntry pbe = new PricebookEntry();
        pbe.Pricebook2Id = Test.getStandardPricebookId();
        pbe.Product2Id = p.Id;
        pbe.UnitPrice = 100;
        pbe.IsActive = true;
        pbe.CurrencyIsoCode = 'USD';
        insert pbe;
        Quote q = new Quote();
        q.Name = 'Test Quote 1';
        q.ExpirationDate = System.today().addDays(30);
        q.Status = 'Draft';
        q.OpportunityId = o.Id;
        q.Pricebook2Id = Test.getStandardPricebookId();
        insert q;

        Test.startTest();
        QuoteLineItem qli = new QuoteLineItem();
        qli.QuoteId = q.Id;
        qli.PricebookEntryId = pbe.Id;
        qli.Quantity = 5;
        qli.UnitPrice = 7.00;
        qli.Product2Id = p.Id;
        insert qli;
        delete qli;
        Test.stoptest();
    }

    @isTest
    private static void TestMethod04() {
        Account a = new Account();
        a.Name = 'QuoteLineItem__Trigger_Test.TestMethod04()';
        a.Phone = '(444) 444-4444';
        a.MaximumExpectedOpportunityRevenue__c = 100000;
        insert a;
        Opportunity o = new Opportunity();
        o.Name = 'QuoteLineItem_Trigger_Test.TestMethod04()';
        o.Amount = 1000000;
        o.Probability = 50;
        o.AccountId = a.Id;
        o.StageName = 'Prospecting';
        o.CloseDate = (System.today() + 30);
        insert o;
        Product2 p = new Product2(
            Name = 'Test Product',
            ProductCode = 'TP001',
            IsActive = true
        );
        insert p;
        PricebookEntry pbe = new PricebookEntry();
        pbe.Pricebook2Id = Test.getStandardPricebookId();
        pbe.Product2Id = p.Id;
        pbe.UnitPrice = 100;
        pbe.IsActive = true;
        pbe.CurrencyIsoCode = 'USD';
        insert pbe;
        Quote q = new Quote();
        q.Name = 'Test Quote 1';
        q.ExpirationDate = System.today().addDays(30);
        q.Status = 'Draft';
        q.OpportunityId = o.Id;
        q.Pricebook2Id = Test.getStandardPricebookId();
        insert q;

        Test.startTest();
        QuoteLineItem qli = new QuoteLineItem();
        qli.QuoteId = q.Id;
        qli.PricebookEntryId = pbe.Id;
        qli.Quantity = 5;
        qli.UnitPrice = 7.00;
        qli.Product2Id = p.Id;
        insert qli;
        delete qli;
        undelete qli;
        Test.stoptest();
    }

    @isTest
    private static void TestMethod05() {
        Account a = new Account();
        a.Name = 'QuoteLineItem__Trigger_Test.TestMethod05()';
        a.Phone = '(555) 555-5555';
        a.MaximumExpectedOpportunityRevenue__c = 100000;
        insert a;
        Opportunity o = new Opportunity();
        o.Name = 'QuoteLineItem_Trigger_Test.TestMethod05()';
        o.Amount = 1000000;
        o.Probability = 50;
        o.AccountId = a.Id;
        o.StageName = 'Prospecting';
        o.CloseDate = (System.today() + 30);
        insert o;
        Product2 p = new Product2(
            Name = 'Test Product',
            ProductCode = 'TP001',
            IsActive = true
        );
        insert p;
        PricebookEntry pbe = new PricebookEntry();
        pbe.Pricebook2Id = Test.getStandardPricebookId();
        pbe.Product2Id = p.Id;
        pbe.UnitPrice = 100;
        pbe.IsActive = true;
        pbe.CurrencyIsoCode = 'USD';
        insert pbe;
        Quote q = new Quote();
        q.Name = 'Test Quote 1';
        q.ExpirationDate = System.today().addDays(30);
        q.Status = 'Draft';
        q.OpportunityId = o.Id;
        q.Pricebook2Id = Test.getStandardPricebookId();
        insert q;

        Test.startTest();
        QuoteLineItem qli = new QuoteLineItem();
        qli.QuoteId = q.Id;
        qli.PricebookEntryId = pbe.Id;
        qli.Quantity = 5;
        qli.UnitPrice = 7.00;
        qli.Product2Id = p.Id;
        insert qli;
        qli.UnitPrice = null;
        try {
            update qli;
        }
        catch(Exception exc) {
            
        }
        Test.stopTest();
    }
}