global with sharing class SYS_SOAP {

    webservice static List<SObject> query(String s) {
        return Database.query(s);
    }
}