trigger NameAddPrefix on Contact (before insert, before update) {
    list<Contact> lc = Trigger.new;
    system.debug(lc);
    for(contact c:lc){
        c.LastName = 'Mr. ' + c.LastName;
    }
}