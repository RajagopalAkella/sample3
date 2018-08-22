public class ISOtoCodeService {
    public String countryISO {get;set;}
    public String response {get;set;} 

	private String baseSericeURL = 'http://services.groupkt.com/country/get/iso2code/';
    private String returnedContinuationId ;

    public ISOtoCodeService()
    {
        countryISO = 'IN';
    } 

    public Object requestService(){

        //Timeout in seconds, 60 is limit
        Continuation con = new Continuation(60);

        // Set callback method
        con.continuationMethod='renderResponse';

        // Create callout request
        HttpRequest req = new HttpRequest();
        req.setMethod('GET');
        req.setEndpoint(baseSericeURL+countryISO);

        returnedContinuationId = con.addHttpRequest(req);

        return con;
    }

    public Object renderResponse() {
      // Get the response by using the unique label
      HttpResponse httpRes = Continuation.getResponse(returnedContinuationId);
      // Set the result variable that is displayed on the Visualforce page
      response = httpRes.getBody();
      // Return null to re-render the original Visualforce page
      return null;
    }

}