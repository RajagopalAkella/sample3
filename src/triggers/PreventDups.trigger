trigger PreventDups on Account (before insert) {
    for (Account a:Trigger.new){
        list<Account> la = [select Id from Account where Name=:a.Name];
        if(la.size()>0){            
            a.Name.adderror('Name already exists');
        }
    }
}