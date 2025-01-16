@RestResource(urlMapping='/create/leads2/*')
global with sharing class veritoneLeads2
{
    @HttpPost
    global static void doPost()
    {
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        Blob jsonBlob = req.requestBody;
        res.statusCode = 400;
        String jsonString = jsonBlob.toString().replace('__c', '').replace('__', '_');
        request r = (request)System.JSON.deserialize(jsonString, request.class);
        List<responseData> rd = insertLeads(r.data);
        responseHeader rh = new responseHeader();
        rh.message = 'Success';
        response r2 = new response();
        r2.responseHeader = rh;
        r2.data = rd;
        res.responseBody = Blob.valueOf(System.JSON.serialize(r2).replace('Lead_External_Id', 'Lead_External_Id__c'));
        res.addHeader('Content-Type', 'application/json;charset=UTF-8');
        res.statusCode = 200;
    }
    
    global static List<responseData> insertLeads(List<data> dataList)
    {
        List<responseData> result = new List<responseData>();
        List<Lead> leads = new List<Lead>();
        for (data d : dataList)
        {
            Lead l = new Lead();
            l.Company = d.Company;
            l.Salutation = d.Salutation.replace('.', '') + '.';
            l.FirstName = d.FirstName;
            l.LastName = d.LastName;
            l.Street = d.Street;
            l.City = d.City;
            l.State = d.State;
            l.PostalCode = d.PostalCode;
            l.Date_Of_Birth__c = stringToDate(d.HealthCloudGA_BirthDate);
            l.Email = d.Email;
            l.Phone = d.Phone;
            l.MobilePhone = d.MobilePhone;
            l.LeadSource = d.LeadSource;
            leads.add(l);
        }
        if (leads.size() > 0)
        {
            insert leads;
            for (Lead l : leads)
            {
                responseData rd = new responseData();
                rd.SFId = l.Id;
                rd.Lead_External_Id = '';
                result.add(rd);
            }
        }
        return result;
    }

    global static Date stringToDate(String s)
    {
        Date result;
        try {
            result = Date.parse(s.replace('-', '/'));
        } catch(Exception exc) {
            result = Date.valueOf(s.replace('/', '-'));
       }
       return result;
    }

    global class data
    {
        global String Lead_External_Id { get; set; }
        global String MH_MBI { get; set; }
        global String MH_Line_of_Business { get; set; }
        global String Salutation { get; set; }
        global String MH_SSN { get; set; }
        global String MH_Date_of_Lezer_Validation { get; set; }
        global String MH_Broker_Rep { get; set; }
        global String MH_Broker_Agency { get; set; }
        global String MH_PCPName { get; set; }
        global String MH_Campaign_Id { get; set; }
        global String MH_Campaign_Source { get; set; }
        global String LeadSource { get; set; }
        global String MH_TotalFamilyMembers;
        global String MH_Gender { get; set; }
        global String MH_Primary_Language { get; set; }
        global String HealthCloudGA_BirthDate { get; set; }
        global String State { get; set; }
        global String Street { get; set; }
        global String MH_County { get; set; }
        global String City { get; set; }
        global String PostalCode { get; set; }
        global String Email { get; set; }
        global String MobilePhone { get; set; }
        global String Phone { get; set; }
        global String LastName { get; set; }
        global String FirstName { get; set; }
        global String Company { get; set; }
    }

    global class requestHeader
    {
        global String source { get; set; }
        global String action { get; set; }
    }

    global class request
    {
        global requestHeader requestHeader { get; set; }
        global List<data> data { get; set; }
    }

    global class responseData
    {
        global String SFId { get; set; }
        global String Lead_External_Id { get; set; }
    }

    global class responseHeader
    {
        global String message { get; set; }
    }

    global class response
    {
        global responseHeader responseHeader { get; set; }
        global List<responseData> data { get; set; }
    }
}