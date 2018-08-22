public class MyCollectionClass {
    public void AddDesc(list<Account> la){
        for(Account a:la){
            if(a.Description != 'Hello'){
                a.Description = 'Hello';
            }
        }
        //update la;
    }
}