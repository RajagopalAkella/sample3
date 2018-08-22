trigger CreateContacts on Account (after insert, after update) {
    list<Contact> CToAdd = new list<Contact>();
    list<Contact> CTemp = new list<Contact>();
    list<Contact> CToDelete = new list<Contact>();
    map<Id,decimal> mapAcc = new map<Id,decimal>();
    for(Account a:Trigger.new){
        mapAcc.put(a.Id,a.TotalLocations__c);
    }
    if(mapAcc.size()>0 && mapAcc!=null){
        for(Id accid:mapAcc.keySet()){
            CTemp = [Select Id from Contact WHERE AccountID = :accid];
            if (CTemp.size()>0 && CTemp != null){
                for(Contact cd:CTemp){
                    CToDelete.add(cd);    
                }                
            }
            
            for(integer i=0; i<mapAcc.get(accid); i++){
                contact c = new contact();
                c.LastName = 'Sample' + i;
                c.AccountId=accid;
                CToAdd.add(c);
            }
        }
    }
    if(CToDelete.size()>0 && CToDelete != null){
        delete CToDelete;
    }
    if(CToAdd.size()>0 && CToAdd!=null){
        insert CToAdd;
    }
}