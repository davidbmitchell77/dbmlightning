@isTest
public class veritoneLeads_Test
{
    @isTest
    private static void testMethod1()
    {
        Campaign c = new Campaign(Name = 'Test Campaign');
        insert c;

        veritoneLeads2.requestHeader h = new veritoneLeads2.requestHeader();
        h.source = 'PWS';
        h.action = 'createLead';

        List<veritoneLeads2.data> dlist = new List<veritoneLeads2.data>();
        for (Integer i=0; i<2; i++)
        {
            veritoneLeads2.data d = new veritoneLeads2.data();
            d.Company = 'Veritone';
            d.Salutation = 'Mr.';
            d.FirstName = 'Ace';
            d.LastName = 'Frehley' + i;
            d.Street = '9669 Saint George St #' + i;
            d.City = 'Spring Valley';
            d.State = 'CA';
            d.PostalCode = '91977';
            d.HealthCloudGA_BirthDate = ((i==0) ? '11/11/1991' : '1991-11-11');
            d.Email = 'sherry.lord' + i + '@outlook.com';
            d.Phone = '6199795512';
            d.MobilePhone = '8585555555d';
            d.MH_Campaign_ID = c.Id;
            d.LeadSource = 'WebLead';
            d.MH_TotalFamilyMembers = '';
            d.Lead_External_Id = '';
            d.MH_MBI = '';
            d.MH_Line_Of_Business = '';
            d.MH_SSN = '';
            d.MH_Date_of_Lezer_Validation = '';
            d.MH_Broker_Rep = '';
            d.MH_Broker_Agency = '';
            d.MH_PCPName = '';
            d.MH_Campaign_Source = '';
            d.MH_Gender = '';
            d.MH_Primary_Language = '';
            d.MH_County = '';
            dlist.add(d);
        }

        veritoneLeads2.request msgBody = new veritoneLeads2.request();
        msgBody.requestHeader = h;
        msgBody.data = dlist;
        String jsonMsg = System.JSON.serialize(msgBody);
        
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        RestContext.request = req;
        RestContext.response= res;
        req.requestURI = '/services/apexrest/create/leads2/';
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueOf(jsonMsg);

        Test.startTest();
        veritoneLeads2.doPost();
        Test.stopTest();
    }
}