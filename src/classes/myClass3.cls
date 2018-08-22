public class myClass3 {
    public static void myMethod() {
        Contact con = new Contact(LastName = 'Test Acc 1', FirstName = 'Contact');        
        Account accountReference = new Account(MyExtID__c='SAP111111');                
        con.Account = accountReference;        
        Account parentAccount = new Account(Name='Hallie', MyExtID__c='SAP111111');      
        
        Database.SaveResult[] results = Database.insert(new SObject[] {parentAccount, con });        
    }
}