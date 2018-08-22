public class IV_API {
//This is a sample class that generates API Token for IV API
//sample run example - using my client id and secret - which will get expired in 1 month from 4th March 2015
//IV_API s = new IV_API();
//s.genUrl('v9l53po4jpadgjc959lb','1ginie66crhflrokrncf9jjcoid6qf8mmsmdfrg81dpoh3f41jo77njjst90');
    public string clientid;
    public string clientsecret;
    public void genUrl( String cid, String csec ) {
         String params = '?clientId='+cid;
         params = params + '&clientSecret=' +csec;
         params = params + '&grantType=cred';
         callout('https://login.insideview.com/Auth/login/v1/token'+params);
    }
    public void callout( String methodurl){
        string resultbody ;
        string resultstatus ;
        HttpRequest req = new HttpRequest();
        req.setMethod('POST');
        req.setHeader('Accept', 'application/json');
        req.setEndpoint(methodurl);
        Http http = new Http();
        HTTPResponse res = http.send(req);
        resultbody= res.getBody();
        resultstatus = res.getStatus();
        System.debug('resultbody------------->' + resultbody);
        System.debug('result status ------------->' + resultstatus);
        
        Parent e = (Parent)json.deserialize(res.getBody(),Parent.class);
        
        system.debug('@@@@@@@@@@@@@@@@@@@@@' + e.accessTokenDetails.expirationTime);
    }
		public class Parent{
			accessTokenDetails accessTokenDetails;
		}
		public class accessTokenDetails{
			string expirationTime;
			userInfo userInfo;
		}
		public class userInfo{
			string userId;
		}


}