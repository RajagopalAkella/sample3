global class getLeadInfo {

  WebService static Lead getLeadAddressByEmail(string LeadEmail) {
    Lead c = [SELECT Id, Street, City, State, PostalCode from Lead WHERE Email = :LeadEmail];
    //Lead l = new Lead(Street = c.Street, City = c.City, State = c.State, PostalCode = c.PostalCode);
    
   return c; 

  }
}