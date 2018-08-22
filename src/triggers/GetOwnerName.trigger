trigger GetOwnerName on Account (after insert) {
    list<Account> MyAccs = new list<Account>();
    for(Account a : Trigger.new) {
        a.Description = 'Just Updated';
        MyAccs.add(a);
    }
    update MyAccs;
}