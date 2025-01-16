global with sharing class MySOAPWebService
{
    webservice static Account getRecord(String Id)
    {
        return [SELECT Id, Name FROM Account LIMIT 1];
    }
}