@RestResource(urlMapping='/LPIDAccess2/*')
global without sharing class REST_AccountService_V6 {
//From Postman: http://akellarajgmail-developer-edition.ap1.force.com/myapi/services/apexrest/LPIDAccess2
/*
PUT Call to: http://akellarajgmail-developer-edition.ap1.force.com/myapi/services/apexrest/LPIDAccess2
Request format:
{
    "UpdatePlanningGroupList": [{
        "PlanningGroupID": "1234",
        "LegalParticipantIdentifier": "ABCD"
    },
    {
        "PlanningGroupID": "5678",
        "LegalParticipantIdentifier": "EFGH"
    },
    {
        "PlanningGroupID": "9123",
        "LegalParticipantIdentifier": "IJKL"
    }]
}

Response format:
{
    "successList": [
        {
            "pgid": "5678",
            "lpid": "EFGH"
        },
        {
            "pgid": "5678",
            "lpid": "EFGH"
        }
    ],
    "failureList": [
        {
            "pgid": "5678",
            "lpid": "EFGH"
        }
    ],
    "dbaStatusMsg": "Database query result is not null."
}
*/

    @HttpPut
    global static respList doPut(list<CustomWrap> UpdatePlanningGroupList) {
        RestRequest req = RestContext.request;
        System.debug('req is---------------------- ' +UpdatePlanningGroupList);
        list<respWrap> returnList = new list<respWrap>();
        respList AllStatus = new respList();        
        set<string> inputLpids = new set<string>();
        set<string> notFoundLpidsSet = new set<string>();
        Map <String, CustomWrap> lpIdResultMap = new Map <String, CustomWrap> ();
        boolean flag;
        for(CustomWrap ipl : UpdatePlanningGroupList) {
            inputLpids.add(ipl.LegalParticipantIdentifier);
            lpIdResultMap.put(ipl.LegalParticipantIdentifier,ipl);
        }

        if(inputLpids.size() == 0) {
            return AllStatus;    //If there is no data in the input, This will return just a null JSON
        }

        list<PGAccess__c> queryList = new list<PGAccess__c>([SELECT Id, LPID__c, PGID__c, AccessStatus__c from PGAccess__c
                                                                WHERE LPID__c =: inputLpids]);        
        
        if(queryList.size() == 0) {
            for (CustomWrap ipl : UpdatePlanningGroupList) {
                respWrap rwTemp = new respWrap();
                rwTemp.PlanningGroupID=ipl.PlanningGroupID;
                rwTemp.LegalParticipantIdentifier=ipl.LegalParticipantIdentifier;
                rwTemp.StatusCode='1';
                rwTemp.Severity='Error';
                rwTemp.StatusDescription='Error  While Retrieving Account Details';
                rwTemp.AdditionalStatus.StatusCode='1120';
                rwTemp.AdditionalStatus.Severity='Error';
                rwTemp.AdditionalStatus.StatusDescription='No Records Match Selection Criteria - NO CUSTOMER FOUND  (reference - 38cab9f7-f893-4946-a963-0880d3e50f01  )';
                rwTemp.AdditionalStatus.ServerStatusCode='64202';
                rwTemp.AdditionalStatus.ServerStatusDescription='NO CUSTOMERS FOUND';
                returnList.add(rwTemp);
            }
            AllStatus.Status = returnList;                                                                        
            return AllStatus;            
        }        


        for (PGAccess__c pga : queryList) {
            pga.AccessStatus__c = 'Not Available';
        }
        
        update queryList;

        list<PGAccess__c> queryPostUpdate = new list<PGAccess__c>([SELECT Id, LPID__c, PGID__c, AccessStatus__c from PGAccess__c
                                                                WHERE LPID__c =: inputLpids]);        
        for (CustomWrap ipl : UpdatePlanningGroupList) {
            Boolean foundLipd = false;
            for (PGAccess__c pga : queryPostUpdate) {
                if (ipl.LegalParticipantIdentifier == pga.LPID__c) {
                    foundLipd = true;
                    break;
                }
            }
            
            respWrap rwTemp = new respWrap();
            
            if ( foundLipd ) {
                rwTemp.PlanningGroupID=ipl.PlanningGroupID;
                rwTemp.LegalParticipantIdentifier=ipl.LegalParticipantIdentifier;
                rwTemp.StatusCode='0';
                rwTemp.Severity='Info';
                rwTemp.StatusDescription='Success';
                rwTemp.AdditionalStatus.StatusCode='0';
                rwTemp.AdditionalStatus.Severity='Success';
                rwTemp.AdditionalStatus.StatusDescription='Success';
                rwTemp.AdditionalStatus.ServerStatusCode='64000';
                rwTemp.AdditionalStatus.ServerStatusDescription='ACTION SUCCESSFUL';
                returnList.add(rwTemp);
            } else {
                rwTemp.PlanningGroupID=ipl.PlanningGroupID;
                rwTemp.LegalParticipantIdentifier=ipl.LegalParticipantIdentifier;
                rwTemp.StatusCode='1';
                rwTemp.Severity='Error';
                rwTemp.StatusDescription='Error  While Retrieving Account Details';
                rwTemp.AdditionalStatus.StatusCode='1120';
                rwTemp.AdditionalStatus.Severity='Error';
                rwTemp.AdditionalStatus.StatusDescription='No Records Match Selection Criteria - NO CUSTOMER FOUND  (reference - 38cab9f7-f893-4946-a963-0880d3e50f01  )';
                rwTemp.AdditionalStatus.ServerStatusCode='64202';
                rwTemp.AdditionalStatus.ServerStatusDescription='NO CUSTOMERS FOUND';
                returnList.add(rwTemp);
            }
        }
        

        AllStatus.Status = returnList;
                                                                        
        return AllStatus;
    }
    
    global class respList {
        public list<respWrap> Status = new list<respWrap>();
    } 
    
    global class respWrap {
        public string LegalParticipantIdentifier;
        public string PlanningGroupID;
        public string StatusCode;
        public string Severity;
        public string StatusDescription;
        public subResp AdditionalStatus = new subResp();
    }
    
    global class subResp {
        public string StatusCode;
        public string Severity;
        public string StatusDescription;
        public string ServerStatusCode;
        public string ServerStatusDescription;
    }

    global class CustomWrap {
        public string PlanningGroupID;
        public string LegalParticipantIdentifier;
        public CustomWrap(CustomWrap cw) {
            this.PlanningGroupID = cw.PlanningGroupID;
            this.LegalParticipantIdentifier = cw.LegalParticipantIdentifier;
        }
    }


}