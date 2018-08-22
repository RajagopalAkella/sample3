trigger CascadeCheck on Contact (after insert, after update) {
    list<Account> listAccUpdate = new list<Account>();
    list<Account> listAccSelected = new list<Account>();
    set<Id> setAccId = new set<Id>();
    map<Id,Id> mapCheckedTrue = new map<Id,Id>();
    map<Id,Id> mapCheckedFalse = new map<Id,Id>();
    
    if (Trigger.isInsert || Trigger.isUpdate){
        for (Contact c:Trigger.new){
            if (c.CQualified__c == True){
                mapCheckedTrue.put(c.AccountId,c.Id);
                setAccId.add(c.AccountId);
            }
        }
    }

    listAccSelected = [select Id, Qualified__c from Account where Id in :setAccId];
    if(listAccSelected.size() > 0 && listAccSelected.size() != null){
        for(Account a:ListAccSelected){
            if(mapCheckedTrue.containsKey(a.Id)){
                a.Qualified__c = True;
                listAccUpdate.add(a);
            }
        }
    }
//    if (listAccUpdate.size()>0 && listAccUpdate != null){
        update listAccUpdate;
        system.debug('Data Updated.');
//    }
}