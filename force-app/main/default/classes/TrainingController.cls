public class TrainingController
{
    private static final Integer querySize = 200;

    @AuraEnabled(cacheable=true)
    public static List<Training__c> getTrainings(String courseType)
    {
        List<Training__c> results = new List<Training__c>();

        results =
        [
            SELECT Id,
                   Name,
                   CourseName__c,
                   CourseDescription__c,
                   CourseSource__c,
                   CourseType__c,
            	   CourseUrl__c,
                   CourseImage__c,
                   ApplicableFor__c
              FROM Training__c
             WHERE Status__c = 'Active'
          ORDER BY Name
             LIMIT :querySize
        ];

        return results;
    }
}