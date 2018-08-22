trigger ContactEligible2 on Contact (after insert, after update, after delete) {
	set<id> allConts = new set<id>();
    map<id,id> YesAcc = new map<id,id>();
    map<id,id> NoAcc = new map<id,id>();
    map<id,id> DelAcc = new map<id,id>();
    list<Account> lacc = new list<Account>();
    if (Trigger.isupdate || Trigger.isinsert){
        for(Contact c:Trigger.new){
            if(c.Eligible__c == 'Yes'){
                YesAcc.put(c.AccountId,c.Id);
                allConts.add(c.AccountId);
            } 
            else if(c.Eligible__c == 'No'){
                NoAcc.put(c.AccountId,c.Id);
                allConts.add(c.AccountId);
            }
        }
    }
    if (Trigger.isdelete){
		for(Contact c:Trigger.old){
			DelAcc.put(c.AccountId,c.Id);
			allConts.add(c.AccountId);
		}
	}
    if(allConts.size()>0 && allConts != null){
        lacc = [select Id,Eligible__c from Account where Id IN: allConts];
        for(Account la:lacc){
            if(YesAcc.containsKey(la.Id)) la.Eligible__c = 'Yes';
            if(NoAcc.containsKey(la.Id)) la.Eligible__c = 'No';
            if(DelAcc.containsKey(la.Id)) la.Eligible__c = '';
        }
	}
    if(lacc.size()>0 && lacc != null) update lacc;
}