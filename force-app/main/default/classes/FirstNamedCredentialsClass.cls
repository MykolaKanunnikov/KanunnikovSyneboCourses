@RestResource (urlMapping='/kanunnikov/*')
global class FirstNamedCredentialsClass {
    public FirstNamedCredentialsClass() {

    }
    //workbench: /services/apexrest/kanunnikov
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


    //workbench: /services/apexrest/kanunnikov?id=a097Q0000033II5QAM (use id from get method)
    @httpDelete
    global static void deleteSession(){
        Map<String,String> paramsMap = RestContext.request.params;
        String sessionId = paramsMap.get('id');
        Session__c s = [SELECT id FROM Session__c WHERE Id =:sessionId FOR UPDATE];
        delete s;
    }

    //workbench: /services/apexrest/kanunnikov 
    //JSON sample:
    //{
    //    "place": "restplace",
    //    "room": "restroom",
    //    "session": "restsession"
    //}
    @httpPost
    global static void createSession(){
        Map<String,String> paramsMap = RestContext.request.params;
        
        Event_Place__c placeRest = new Event_Place__c(Name = paramsMap.get('place'));
        insert placeRest;
        
        Room__c roomRest = new Room__c(Name = paramsMap.get('room'),
                                       Event_Place__c = placeRest.id);
        insert roomRest;

        Session__c sessionToInsert = new Session__C(Name = paramsMap.get('session'),
                                                    Room__c = roomRest.id); 
        insert sessionToInsert;       
    }

    //workbench: /services/apexrest/kanunnikov 
    //JSON sample (use id from get method):
    //{
    //    "id": "a097Q0000031qJOQAY",
    //    "description": "the most incredible session forever",
    //}
    @httpPut
    global static void changeSessionDescription(){
        Map<String,String> paramsMap = RestContext.request.params;
        String sId = paramsMap.get('id');
        Id sessionId = Id.valueOf(sId);
        String description = paramsMap.get('description');
        Session__c s = new Session__c(Id = sessionId, Description__c = description);
        update s;
    }
}

