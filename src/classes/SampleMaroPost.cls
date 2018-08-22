public class SampleMaroPost {
    public static string sendEmailThroughMaro(string myInpEmail) {
        string successContacts = '';
        string failureContacts = '';
        list<contact> conts = new list<contact> ([SELECT Id ,LastName, Email FROM Contact WHERE Email IN ('akellaraj@gmail.com','akellaraj2@gmail.com')]);
        overallEmail myEmail = new overallEmail();
        for(contact c : conts){
            myEmail.email.campaign_id = 172;
            myEmail.email.contact.email = c.Email;
            myEmail.email.contact.first_name = c.LastName;
            system.debug('#### Input JSON: ' + JSON.serialize(myEmail));
            
            try{
                String endpoint = 'http://api.maropost.com/accounts/1173/emails/deliver.json?auth_token=j-V4sx8ueUT7eKM8us_Cz5JqXBzoRrNS3p1lEZyPUPGcwWNoVNZpKQ';
                HttpRequest req = new HttpRequest();
                req.setEndpoint(endpoint);
                req.setMethod('POST');
                req.setHeader('Content-type', 'application/json');
                req.setbody(JSON.serialize(myEmail));
                Http http = new Http();
                HTTPResponse response = http.send(req);                    
                string resultBodyGet = '';
                resultBodyGet = response.getBody();        
                maroResponse myMaroResponse = new maroResponse();
                myMaroResponse = (maroResponse) JSON.deserialize(resultBodyGet, maroResponse.class);
                system.debug('#### myMaroResponse: ' + myMaroResponse);
                if(myMaroResponse.message == 'Email was sent successfully')
                    successContacts = successContacts + ';' + c.Email;
                else
                    failureContacts = failureContacts + ';' + c.Email;
            }
            catch (exception e) {
                failureContacts = failureContacts + ';' + c.Email;
                system.debug('#### Exception caught: ' + e.getMessage());                
            }
        }
        return 'successContacts=' + successContacts + '---' + 'failureContacts=' + failureContacts;        
    }
    
    public class maroResponse {
        public string message {get;set;}
    }

    public class overallEmail {
        public emailJson email = new emailJson();
    }
    
    public class emailJson {
        public Integer campaign_id;
        public contactJson contact = new contactJson();
    }
    
    public class contactJson {
        public string email;
        public string first_name;
    }
}