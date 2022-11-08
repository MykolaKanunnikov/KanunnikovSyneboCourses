@RestResource (urlMapping='/sessionsrestservice/*')
global class SessionRestService {
    public SessionRestService() {

    }
    //workbench: /services/apexrest/sessionsrestservice
    @HttpGet
    global static void getSessionsOnWeek() {
        List<Session__c> s = [SELECT Id, Name 
                              FROM Session__c 
                              WHERE Days_remains__c >= 0 
                              AND Days_remains__c <= 7
                              FOR UPDATE];

        RestContext.response.responseBody = Blob.valueOf(JSON.serialize(s));
        RestContext.response.statusCode = 200;
    }


    //workbench: /services/apexrest/sessionsrestservice?id=a097Q0000033II5QAM (use id from the get method)
    @httpDelete
    global static void deleteSession(){
        Map<String,String> paramsMap = RestContext.request.params;
        String sessionId = paramsMap.get('id');
        Session__c s = [SELECT id FROM Session__c WHERE Id =:sessionId FOR UPDATE];
        delete s;
    }

    //workbench: /services/apexrest/sessionsrestservice 
    //JSON sample:
    //{
    //    "Name": "restsession",
    //    "Room__c": "a067Q000007EphuQAC"   
    //}
    @httpPost
    global static void createSession(){
        Session__c sessionToInsert = (Session__c) JSON.deserialize(RestContext.request.requestBody.toString(), Session__c.class);
        insert sessionToInsert;       
    }

    //workbench: /services/apexrest/sessionsrestservice 
    //JSON sample (use id from get method):
    //{      
    //    "id": "a097Q0000031qPmQAI",
    //    "Description__c": "the most incredible session forever"
    //}
    @httpPatch
    global static void editSessionDescription(){
        Session__c sessionUpdate = (Session__c) JSON.deserialize(RestContext.request.requestBody.toString(), Session__c.class);
        update sessionUpdate;
    }
}

