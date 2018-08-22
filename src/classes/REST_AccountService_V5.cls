@RestResource(urlMapping='/LPIDAccess/*')
global without sharing class REST_AccountService_V5 {
//From Postman: http://akellarajgmail-developer-edition.ap1.force.com/myapi/services/apexrest/LPIDAccess
//From Workbench: /services/apexrest/LPIDAccess?ExtId=100
/*
PUT Call to: http://akellarajgmail-developer-edition.ap1.force.com/myapi/services/apexrest/LPIDAccess
Request format:
{
    "inputList": [{
        "pgid": "1234",
        "lpid": "ABCD"
    },
    {
        "pgid": "5678",
        "lpid": "EFGH"
    },
    {
        "pgid": "9123",
        "lpid": "IJKL"
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
    global static respWrap doPut(list<CustomWrap> inputList) {
        RestRequest req = RestContext.request;
        System.debug('req is---------------------- ' +inputList);
        respWrap returnList = new respWrap();
        set<string> inputLpids = new set<string>();
        set<string> notFoundLpidsSet = new set<string>();
        Map <String, CustomWrap> lpIdResultMap = new Map <String, CustomWrap> ();
        boolean flag;
        for(CustomWrap ipl : inputList) {
            inputLpids.add(ipl.lpid);
            lpIdResultMap.put(ipl.lpid,ipl);
        }

        list<PGAccess__c> queryList = new list<PGAccess__c>([SELECT Id, LPID__c, PGID__c, AccessStatus__c from PGAccess__c
                                                                WHERE LPID__c =: inputLpids]);        
        if(inputLpids.size() == 0 || queryList.size() == 0) {
            returnList.dbaStatusMsg = 'No matching LPIDs in database.';
            return returnList;
        }
        
        returnList.dbaStatusMsg = 'Database query result is not null.';

        for (PGAccess__c pga : queryList) {
            pga.AccessStatus__c = 'Not Available';
        }
        
        update queryList;

        list<PGAccess__c> queryPostUpdate = new list<PGAccess__c>([SELECT Id, LPID__c, PGID__c, AccessStatus__c from PGAccess__c
                                                                WHERE LPID__c =: inputLpids]);        
        for (CustomWrap ipl : inputList) {
            Boolean foundLipd = false;
            for (PGAccess__c pga : queryPostUpdate) {
                if (ipl.lpid == pga.LPID__c) {
                    foundLipd = true;
                    break;
                }
            }
            
            if ( !foundLipd ) {
                returnList.failureList.add(new CustomWrap(ipl));
            } else {
                returnList.successList.add(new CustomWrap(ipl));
            }
        }
                                                                        
        return returnList;
    }
    
    global class respWrap {
        public string dbaStatusMsg;
        public list<CustomWrap> successList;
        public list<CustomWrap> failureList;
        public respWrap() {
            dbaStatusMsg = '';
            successList = new list<CustomWrap>();
            failureList = new list<CustomWrap>();
        }
    }

    global class CustomWrap {
        public string pgid;
        public string lpid;
        public CustomWrap(CustomWrap cw) {
            this.pgid = cw.pgid;
            this.lpid = cw.lpid;
        }
    }

/*
    global class CustomQueryWrap {
        public string pgid;
        public string lpid;
        public CustomQueryWrap(PGAccess__c pga) {
            this.pgid = pga.PGID__c;
            this.lpid = pga.LPID__c;
        }
    }
  */  

}