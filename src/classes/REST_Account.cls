@RestResource(urlMapping='/myapi/UpsertAccount')
global without sharing class REST_Account {
    // sandbox access token: '3C7A8A9A-1C70-4B70-A438-8321758601AB'
    // production access token '607D0D0C-1241-4E06-AA5B-545329CC99A1'
    private static final string ACCESS_TOKEN='oHiDy0lm-5DU8-gnaP-gMEA-ORXgP';
    @HttpPut
    global static string CreateAccount() {
        RestRequest req=RestContext.request;
        return CreateAccountWS(req.requestBody.toString(), req.headers.get('AccessToken'));        
    }

    public class clMessage {
        string Code;
        string Message;
        public clMessage(string scode, string mess) {
            this.Code=scode;
            this.Message=mess;
        }
    }    
    
    public class Account_JSON {
        string aName;
        public Account_JSON(string aName) {
            this.aName=aName;
        }
    }
    
    global static string CreateAccountWS(string sJSON, string sAccessToken) {
        if(sAccessToken!=ACCESS_TOKEN) return JSON.serialize(new clMessage('0','Invalid AccessToken provided. Received sAccessToken'));       
        if(sJSON==null || sJSON=='') return JSON.serialize(new clMessage('0','Empty List of IV ORG Accounts'));  
        
        List<Account_JSON> lDeserializedAcc; 
        try {
            lDeserializedAcc= (List<Account_JSON>)JSON.deserialize(sJSON, List<Account_JSON>.class);   
        } catch( Exception e ) {
        return JSON.serialize(new clMessage('0','System Error: Could not deserialize JSON. Error message: '+e));
        }

        //data validation
        List<Account> accs_Insert=new List<Account>();
        for(Account_JSON acc: lDeserializedAcc) {
            Account to_Create;
            to_Create=create_Account_from_JSON(acc);
            accs_Insert.add(to_Create);
            //return JSON.serialize(new clMessage('0','Check. : '+lDeserializedAcc.size()));
        }  

        try {
            if(!accs_Insert.isEmpty()) insert accs_Insert;
        } catch(System.DMLException e) {
        return JSON.serialize(new clMessage('0','System Error: Could not Insert. Error message: '+e +accs_Insert[0].Name));
        }
        clMessage WS_Result=new clMessage('1','Successfull UPSERT');
        return JSON.serialize(WS_Result);
    }            

    private static Account create_Account_from_JSON(Account_JSON from_json) {
        Account acc_new=new Account(Name=from_json.aName);        
        return acc_new;
    }    
}