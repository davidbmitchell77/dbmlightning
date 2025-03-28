global with sharing class SoapServices
{
    private static final Integer maxQuerySize = 200;
    
    webservice static List<Opportunity> getOpportunities(String searchExpression)
    {
        return ([SELECT Id,
                        Name,
                        Type,
                        LeadSource,
                        Amount,
                        StageName,
                        Account.Name,
                        Account.BillingCity,
                        Account.BillingState,
                        Account.BillingPostalCode,
                        Account.BillingCountry,
                        Account.Phone,
                        CreatedDate,
                        CreatedBy.Name,
                        CreatedBy.Title,
                        CreatedBy.Email,
                        CreatedBy.Profile.Name,
                        CreatedBy.UserRole.Name,
                        LastModifiedDate,
                        LastModifiedBy.Name,
                        LastModifiedBy.Title,
                        LastModifiedBy.Email,
                        LastModifiedBy.Profile.Name,
                        LastModifiedBy.UserRole.Name
                   FROM Opportunity
                  WHERE Name LIKE :formatQuery(searchExpression)
                     OR Account.BillingState LIKE :formatQuery(searchExpression)
                     OR Account.BillingCity LIKE :formatQuery(searchExpression)
                   WITH SECURITY_ENFORCED
               ORDER BY Name ASC
                  LIMIT :maxQuerySize
        ]);
    }
    
    private static String formatQuery(String s) {
        return ('%' + s + '%');
    }
}