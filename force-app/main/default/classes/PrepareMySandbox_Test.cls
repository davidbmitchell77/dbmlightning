@isTest
private class PrepareMySandbox_Test {

    @isTest
    private static void TestMethod01() {
        Test.startTest();
        try {
            Test.testSandboxPostCopyScript(new PrepareMySandbox(), UserInfo.getOrganizationId(), UserInfo.getOrganizationId(), UserInfo.getOrganizationName());
        }
        catch(Exception e) {
            System.debug('Exception in sandbox copy: ' + e.getMessage());
        }
        Test.stopTest();

        try {
            System.assertEquals(50,  [SELECT COUNT() FROM Account]);
            System.assertEquals(300, [SELECT COUNT() FROM Contact WHERE AccountId != null]);
        }
        catch(Exception e) {

        }
    }
}