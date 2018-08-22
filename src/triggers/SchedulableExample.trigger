trigger SchedulableExample on Contact (before update) {
    if(util_Utilities.ScheduledRunFlag == true ){
        return;
    }
	util_Utilities.ScheduledRunFlag = true;    
    
    list<Contact> lic = new list<Contact>();
    for(Contact c:Trigger.new){
       	if(c.ScheduleFlag__c==false){
            c.TimeNow__c = String.valueOf(System.now().hour()) + ':' + String.valueOf(System.now().minute()) + ':' + String.valueOf(System.now().second());
            lic.add(c);
            Datetime executeTime = (System.now()).addSeconds(5);
            String cronExpression = util_Utilities.GetCRONExpression(executeTime);
            ScheduledClass scheduledJob = new ScheduledClass('jrogers@burlington.com');
            System.schedule('ScheduledJob ' + executeTime.getTime(),cronExpression,scheduledJob);    
        }
        c.ScheduleFlag__c=true;
    }
}