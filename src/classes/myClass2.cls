public class myClass2{    
    public static void myMethod () {      
        // Do some work!
        list<account> acct = new list<account>();
        list<contact> cont = new list<contact>();
        for(Integer a=0; a<10; a++) {            
            Account acc = new Account();
            acc.Name = 'Test Acc ' + a;
            acct.add(acc);
        }
        insert acct;
        for (account a : acct) {
            for(Integer i=0; i<5; i++) {
                Contact con = new Contact();
                con.LastName = 'Test ' + i;
                con.FirstName = 'Contact';
                con.AccountId = a.Id;
                cont.add(con);
            }
        }
        insert cont;
    } 
}