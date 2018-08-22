public class showSelectedAccounts {
    public list<Account> lstAcc{get;set;}
    public list<Account> selectedAcc{get;set;}
    public list<wrapper> lstWrapper{get;set;}
    public boolean noAcc{get;set;}
    
    public showSelectedAccounts(){
        lstWrapper=new list<Wrapper>();
        lstAcc=[select id,name,phone from Account];
        Wrapper objwrap;
        for(Account objA:lstAcc){
            objwrap=new Wrapper();
            objwrap.Acc=objA;
            lstWrapper.add(objwrap);
        }
    }
    
    public void ShowSelected(){
        selectedAcc=new list<account>();
        selectedAcc.clear();
        noAcc=false;
        for(Wrapper objWrap:lstWrapper){
            if(objWrap.selected){
                noAcc=true;
                selectedAcc.add(objWrap.Acc);
            }
        }
        if(!noAcc){
            system.debug('#########'+noAcc);
            ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.INFO,'No Account Selected'));
        }
    }
    
    public class wrapper{
        public boolean selected{get;set;}
        public Account Acc{get;set;}
    }

}