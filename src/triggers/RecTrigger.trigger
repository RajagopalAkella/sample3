trigger RecTrigger on TestRecursive__c (before update) {
    public static integer RecrCounter;
    public static string samp;
    
    if(RecrCounter == null){
        RecrCounter = 1;
    } else {
        RecrCounter = RecrCounter + 1;
    }
    
    if(RecrCounter < 5 ){
        
        for(TestRecursive__c temp : Trigger.new) {        
            if(temp.RecursiveCountNum__c < 5) {  
                temp.RecursiveCountNum__c = RecrCounter;
                
                system.debug('Old val: ' + Trigger.oldMap.get(temp.Id).RecursiveCountNum__c);
                system.debug('New Val: ' + temp.RecursiveCountNum__c);
                system.debug('Counter: ' + RecrCounter);
                
                samp = samp + String.valueOf(RecrCounter);
                temp.CounterVal__c = samp;
                //temp.RecursiveCount__c  = temp.RecursiveCount__c + ':' + temp.RecursiveCountNum__c + '-' + Trigger.oldMap.get(temp.Id).RecursiveCountNum__c;                
                //temp.CounterVal__c = temp.CounterVal__c + '-' + String.valueOf(RecrCounter);                
                //system.debug('Old val: ' + Trigger.oldMap.get(temp.Id).RecursiveCountNum__c + ' New Val: ' + temp.RecursiveCountNum__c);
            }
        }        
    
    }
    
}