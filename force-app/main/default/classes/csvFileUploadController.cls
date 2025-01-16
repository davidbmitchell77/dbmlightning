public class csvFileUploadController
{
    @AuraEnabled
    public static List<ContentDocument> getFiles(String recordId)
    {
        List<ContentDocument> DocumentList = new List<ContentDocument>();  
        Set<Id> documentIds = new Set<Id>();
        List<ContentDocumentLink> cdl = [SELECT Id, LinkedEntityId, ContentDocumentId FROM ContentDocumentLink WHERE LinkedEntityId = :recordId];  
        for (ContentDocumentLink cdLink : cdl) {
            documentIds.add(cdLink.ContentDocumentId);
        }
        DocumentList = [SELECT Id, Title, FileType, ContentSize, Description FROM ContentDocument WHERE Id IN :documentIds];
        return DocumentList;
    }

    @AuraEnabled
    public static List<ContentDocument> updateFiles(String documentId, String title, String recordId)
    {
        System.debug('title: ' + title);
        ContentDocument cd = [SELECT Id, Title FROM ContentDocument WHERE Id = :documentId]; // Getting files from Parent record
        cd.Title = title;  // Changing file Title with user entered title
        try {
            update cd;
        }
        catch(DMLException e) {
            System.debug('Exception has occurred! ' + e.getMessage());
        }
        List<ContentDocument> DocumentList = new List<ContentDocument>();
        Set<Id> documentIds = new Set<Id>();
        List<ContentDocumentLink> cdl = [SELECT Id, LinkedEntityId, ContentDocumentId FROM ContentDocumentLink WHERE LinkedEntityId = :recordId];
        for (ContentDocumentLink cdLink : cdl) {
            documentIds.add(cdLink.ContentDocumentId);
        }
        DocumentList = [SELECT Id, Title, FileType, ContentSize, Description FROM ContentDocument WHERE Id IN :documentIds];
        return DocumentList;
   }
}