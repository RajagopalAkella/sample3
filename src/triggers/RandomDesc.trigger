trigger RandomDesc on Account (before insert, before update) {
    list<Account> la = Trigger.new;
    MyCollectionClass mcc = new MyCollectionClass();
    mcc.AddDesc(la);
}