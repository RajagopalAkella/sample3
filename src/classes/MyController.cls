public class MyController {

    public List<Account> getMyaccounts() {
        return [SELECT Id, Name, AccountNumber FROM Account];
    }

}