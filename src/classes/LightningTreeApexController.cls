public class LightningTreeApexController {  

   @AuraEnabled  
   public static List<items> getAccountHierarchy(Id accountId) {  
       
     //Wrapper instance  
     List<items> finalWrp = new List<items>();  
       
    map<Id,List<Contact>> accountContactMap = new map<id,List<Contact>>();    
    List<Account> lstAccount = [SELECT Id, name, (SELECT Id, Name FROM Contacts) FROM Account
                               where Id IN ('00190000024O9IP', '00190000024O9IF', '00190000024O9I0')];    
    for(Account acc : lstAccount)
    {
        accountContactMap.put(acc.id, acc.Contacts);
    }       
       
       //Going upto 2 level only as per SOQL limit  
       for(Account acc : [ Select Id, Name, ParentId, Parent.Name, Parent.ParentId, Parent.Parent.Name From Account Where Id =: accountId]) {  
           
           //populating wrapper  
           List<items> trP1 = new List<items>();           
          /* list<Contact> Acc3Contacts = accountContactMap.get(acc.Id);
           for(contact c: Acc3Contacts){
               trP1.add(new items(c.Name, c.Name, true, null));
           } */
           trP1.add(new items(acc.Name, acc.Name, true, null));        
           
           List<items> trP2 = new List<items>();
          /* list<Contact> Acc2Contacts = accountContactMap.get(acc.ParentId);
           for(contact c: Acc2Contacts){
               trP2.add(new items(c.Name, c.Name, true, null));
           } */
           trP2.add(new items(acc.Parent.Name, acc.Parent.Name, true, trP1));
           
          /* list<Contact> Acc1Contacts = accountContactMap.get(acc.Parent.ParentId);
           for(contact c: Acc1Contacts){
               finalWrp.add(new items(c.Name, c.Name, true, null));
           } */
           finalWrp.add(new items(acc.Parent.Parent.Name, acc.Parent.Parent.Name, true, trP2));
           
       }             
       
       System.debug('finalWrp:::' + finalWrp);  
       // return wrapper  
       return finalWrp;    
   }  
     
     
     
 public class items {  
     
   @AuraEnabled  
   public string label { get; set; }  
     
   @AuraEnabled  
   public string name { get; set; }  
     
   @AuraEnabled  
   public Boolean expanded { get; set; }  
     
   @AuraEnabled  
   public List<items> items { get; set; }  
     
   public items( String name, String label, Boolean expanded, List<items> items) {  
     this.label = label;  
     this.name = name;  
     this.expanded = expanded;  
     this.items = items;   
   }  
 }  

     
 }