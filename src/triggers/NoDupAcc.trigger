trigger NoDupAcc on Account (before insert, before update) {
    for (Account a : Trigger.new){
    	list <Account> la = [select Id from Account where Name = :a.Name];
        if (la.size()>0){
            a.Name.adderror('Account with same name already exists.');
        }
    }
}