trigger UpdateACheck on Contact (after insert, after update) {
    list<Account> la = new list<Account>();
    for(Contact c:Trigger.new){
        if(c.CQualified__c){
            Account a = new Account(Id=c.AccountId);
            a.Qualified__c=True;
            la.add(a);
        }
    }
    if(la.size()>0 && la!=null){
        update la;
    }
}