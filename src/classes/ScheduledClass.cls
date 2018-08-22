global class ScheduledClass implements Schedulable{
    string eml;
    global void execute( SchedulableContext SC ){
        system.debug('@@@@@@ I am run');
        //list<Contact> lc = new list<contact>([select Id,TimeAfter__c from contact where Email='jrogers@burlington.com']);
        list<Contact> lc = new list<contact>([select Id,TimeAfter__c from contact where Email=: eml]);
        EnterTimeAfter(lc.get(0));
    }
    public void EnterTimeAfter(Contact c){
    	c.TimeAfter__c = String.valueOf(System.now().hour()) + ':' + String.valueOf(System.now().minute()) + ':' + String.valueOf(System.now().second());
        update c;
    }
    public ScheduledClass(string lc){
        eml = lc;
    }
}