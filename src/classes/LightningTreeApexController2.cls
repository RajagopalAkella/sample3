public class LightningTreeApexController2 {

   @AuraEnabled  
   public static List<items> getRGHierarchy(Id recordId) {  
       
    //Wrapper instance  
    List<items> finalWrp = new List<items>();  
       
    map<Id,List<RelationshipGroupMember__c>> rgRgmMap = new map<id,List<RelationshipGroupMember__c>>();    
    List<RelationshipGroup__c> lstRg = [SELECT Id, name, (SELECT Id, Name FROM RelationshipGroupMembers__r) FROM RelationshipGroup__c
                               where Id IN ('a0I9000000fWQTU', 'a0I9000000fWQTZ', 'a0I9000000fWQTe')];    
    for(RelationshipGroup__c rg : lstRg)
    {
        rgRgmMap.put(rg.id, rg.RelationshipGroupMembers__r);
    }       
       //Get master parent of the record first
       list<RelationshipGroup__c> masterRgRec = new list<RelationshipGroup__c> ([Select Id, RelationshipGroupMasterParent__r.Id FROM RelationshipGroup__c
                                                                    WHERE Id =: recordId LIMIT 1]);
       /*
       list<RelationshipGroup__c> rgRgm = new list<RelationshipGroup__c> (
       [ Select Id, Name, 
                                         RelationshipGroupParent__r.Id, RelationshipGroupParent__r.Name, 
                                         RelationshipGroupMasterParent__r.Id, RelationshipGroupMasterParent__r.Name,
                                         HierarchyLevel__c
                                         From RelationshipGroup__c Where Id =: masterRgRec[0].RelationshipGroupMasterParent__r.Id
                                         OR RelationshipGroupMasterParent__r.Id =: masterRgRec[0].RelationshipGroupMasterParent__r.Id
                                        ORDER BY HierarchyLevel__c desc]
       );
       system.debug('Extract list is: ' + rgRgm);
       */
       
       
       for(RelationshipGroup__c rgRgm : [ Select Id, Name, 
                                         RelationshipGroupParent__r.Id, RelationshipGroupParent__r.Name, 
                                         RelationshipGroupMasterParent__r.Id, RelationshipGroupMasterParent__r.Name,
                                         HierarchyLevel__c
                                         From RelationshipGroup__c Where Id =: masterRgRec[0].RelationshipGroupMasterParent__r.Id
                                         OR RelationshipGroupMasterParent__r.Id =: masterRgRec[0].RelationshipGroupMasterParent__r.Id
                                        ORDER BY HierarchyLevel__c desc]) {
                                            
                                                if(finalWrp.size() == 0){
                                                	finalWrp.add(new items(rgRgm.Name, rgRgm.Name, true, null));
                                                } else{
                                                    finalWrp.add(new items(rgRgm.Name, rgRgm.Name, true, finalWrp));
                                                }
                                            
                                         }
       
       
       /*
       system.debug('Id received: ' + recordId);
       //Going upto 2 level only as per SOQL limit  
       for(RelationshipGroup__c rgRgm : [ Select Id, Name, 
                                         RelationshipGroupParent__r.Id, RelationshipGroupParent__r.Name, 
                                         RelationshipGroupParent__r.RelationshipGroupParent__r.Id, RelationshipGroupParent__r.RelationshipGroupParent__r.Name
                                         From RelationshipGroup__c Where Id =: recordId]) {  
           system.debug('RG rec: ' + rgRgm);
           //populating wrapper  
           List<items> trP1 = new List<items>();           
      //     list<RelationshipGroupMember__c> rg3rgms = rgRgmMap.get(rgRgm.Id);
      //     for(RelationshipGroupMember__c rgm: rg3rgms){
      //         trP1.add(new items(rgm.Name, rgm.Name, true, null));
      //     } 
           trP1.add(new items(rgRgm.Name, rgRgm.Name, true, null));        			
           
           List<items> trP2 = new List<items>();
       //    list<RelationshipGroupMember__c> rg2rgms = rgRgmMap.get(rgRgm.RelationshipGroupParent__r.Id);
       //    for(RelationshipGroupMember__c rgm: rg2rgms){
       //        trP2.add(new items(rgm.Name, rgm.Name, true, null));
       //    } 
           trP2.add(new items(rgRgm.RelationshipGroupParent__r.Name, rgRgm.RelationshipGroupParent__r.Name, true, trP1));			
           
           list<RelationshipGroupMember__c> rg1rgms = rgRgmMap.get(rgRgm.RelationshipGroupParent__r.RelationshipGroupParent__r.Id);
        //   for(RelationshipGroupMember__c rgm: rg1rgms){
        //       finalWrp.add(new items(rgm.Name, rgm.Name, true, null));
        //   }  
           finalWrp.add(new items(rgRgm.RelationshipGroupParent__r.RelationshipGroupParent__r.Name, rgRgm.RelationshipGroupParent__r.RelationshipGroupParent__r.Name, true, trP2));
        	
       }        
   
       */
       
       System.debug('finalWrp:::' + finalWrp); 
       string JsonFinalWrp = JSON.serialize(finalWrp);
       system.debug('JsonSerialize: ' + JsonFinalWrp);
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