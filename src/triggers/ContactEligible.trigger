trigger ContactEligible on Contact (after insert, after update, after delete) {
    set<Id> SetAccsAll = new set<Id>();
//    set<Id> SetAccDel = new set<Id>();
    map<Id,Id> MapAccsYes = new map<Id,Id>();
    map<Id,Id> MapAccsNo = new map<Id,Id>();
    map<Id,Id> MapAccsDel = new map<Id,Id>();
    List<Account> lAccs = new List<Account>();
    
    if(Trigger.isinsert || Trigger.isupdate){
        for(Contact c:Trigger.new){
            if(c.Eligible__c=='Yes'){
                MapAccsYes.put(c.AccountId,c.Id);
                SetAccsAll.add(c.AccountId);
            }
            if(c.Eligible__c=='No'){
                MapAccsNo.put(c.AccountId,c.Id);
                SetAccsAll.add(c.AccountId);
            }
        }
    }

    if(Trigger.isdelete){
        for(Contact c1:Trigger.old){
            MapAccsDel.put(c1.AccountId,c1.Id);
            SetAccsAll.add(c1.AccountId);
//            SetAccDel.add(C1.AccountId);
        }
    }
    
    if(SetAccsAll.size()>0 && SetAccsAll!=null){
        lAccs = [Select Id, Eligible__c from Account WHERE ID IN :SetAccsAll];
        for(Account A:lAccs){
            if(MapAccsYes.containsKey(A.Id)){
                A.Eligible__c='Yes';
            }
            if(MapAccsNo.containsKey(A.Id)){
                A.Eligible__c='No';
            }
            if(MapAccsDel.containsKey(A.Id)){
                A.Eligible__c='';
                system.debug('>>>>>>>>>>>>>>>>>>>>>> Deleted.');
            }
        }
    }
    
    if(lAccs.size()>0 && lAccs!=null){
        update lAccs;
    }
}