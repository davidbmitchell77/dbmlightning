@RestResource(urlMapping='/create/leads/*')
global with sharing class veritoneLeads
{
    @HttpPost
    global static Integer create(leads leads)
    {
        Integer result = -1;
        requestheader rh = leads.requestHeader;
        data d = leads.data[0];
        Lead l = new Lead();
        l.FirstName = d.FirstName;
        l.LastName = d.LastName;
        l.Company = d.Company;
        insert l;
        result = 200;
        return result;
    }

    global class leads
    {
        requestheader requestHeader { get; set; }
        List<data> data { get; set; }
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
}