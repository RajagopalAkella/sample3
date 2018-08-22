trigger ApplyIncentive on Contact (before insert, before update) {
    list<Contact> cc = Trigger.new;
    PriceDiscount.ApplyBonus(cc);
}