public class importDataFromCSVController
{
    public Blob csvFileBody { get; set; }
    public String filename { get; set; }
    public String csvAsString { get; set; }
    public String[] csvFileLines { get; set; }
    public List<Account> accounts { get; set; }

    public importDataFromCSVController() {
        csvFileLines = new String[]{};
        accounts = new List<Account>();
    }

    public void importCSVFile()
    {
        try
        {
            csvAsString = csvFileBody.toString();
            csvFileLines = csvAsString.split('\n');

            for (Integer i=1; i<csvFileLines.size(); i++)
            {
                String[] columns = csvFileLines[0].split(',');
                Map<String,String> data = new Map<String,String>();
                for (Integer j=0; j<columns.size(); j++) {
                    data.put(columns[j], null);
                }

                String[] values = csvFileLines[i].split(',');
                for (Integer k=0; k<values.size(); k++) {
                    data.put(columns[k], values[k].replaceAll('&#44', ','));
                }

                Account a = new Account();
                a.Name = data.get('Name');    
                a.AccountNumber = data.get('AccountNumber');
                a.Type = data.get('Type');
                a.AccountSource = data.get('AccountSource');
                a.Industry = data.get('Industry');                                                              
                accounts.add(a);
            }

            insert accounts;

            ApexPages.Message successMessage = new ApexPages.Message(ApexPages.Severity.INFO, 'Successfully imported ' + (csvFileLines.size() - 1) + ' rows from ' + filename + '.');
            ApexPages.addMessage(successMessage);
        }
        catch (Exception e) {
            ApexPages.Message errorMessage = new ApexPages.Message(ApexPages.Severity.ERROR, 'An error occured while importing file "' + filename + '":\n' + e.getMessage());
            ApexPages.addMessage(errorMessage);
        }
    }
}