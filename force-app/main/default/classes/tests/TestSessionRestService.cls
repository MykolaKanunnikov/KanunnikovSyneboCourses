@isTest
private class TestSessionRestService {

    @isTest
    private static void testGETSessionRest (){
        Test.startTest();
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
    
        req.requestURI = '/sessionsrestservice/*';  
        req.httpMethod = 'GET';  
        RestContext.request = req;
        RestContext.response = res;

        SessionRestService.getSessionsOnWeek();
        Test.stopTest();
        Assert.areEqual(200, res.statusCode);
    }

    @isTest
    private static void testDeleteSessionRest (){
        Test.startTest();
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
    
        req.requestURI = '/sessionsrestservice/*';  
        req.httpMethod = 'DELETE';
        req.params.put('id', 'a097Q0000033II5QAM');
        RestContext.request = req;
        RestContext.response = res;

        SessionRestService.deleteSession();
        Test.stopTest();
        Assert.areEqual(200, res.statusCode);
    }

    @isTest
    private static void testCreateSession(){
        Test.startTest();
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
    
        req.requestURI = '/sessionsrestservice/*';  
        req.httpMethod = 'PUT';
        List<Session__c> sList = TestDataFactory.getNewSession(1);
        req.requestBody = Blob.valueOf(JSON.serialize(sList[0]));
        RestContext.request = req;
        RestContext.response = res;

        SessionRestService.createSession();
        Test.stopTest();
        Assert.areEqual(200, res.statusCode);
    }

    @isTest
    private static void testEditSessionDescription(){
        Test.startTest();
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
    
        req.requestURI = '/sessionsrestservice/*';  
        req.httpMethod = 'PATCH';

        Session__c s = new Session__c(id = id.valueOf('a097Q0000031qJOQAY'),
                                      Description__c = 'test description');

        req.requestBody = Blob.valueOf(JSON.serialize(s));
        RestContext.request = req;
        RestContext.response = res;

        SessionRestService.editSessionDescription();
        Test.stopTest();
        Assert.areEqual(200, res.statusCode);
    }



}
