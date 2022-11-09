@isTest
private class SessionTriggerHandlerTest{
    //todo: assertions 

    @isTest
    private static void testArchiveChecker(){
        Test.startTest();
        SessionTriggerHandler.archiveChecker(new List<Session__c>{new Session__c()});
        Test.stopTest();
    }
    
    @isTest
    private static void testSessionNumUpdate(){
        Set<Id> idSet = TestDataFactory.getIdofFewPlaces();
        Test.startTest();
        SessionTriggerHandler.sessionNumUpdate(idSet);
        Test.stopTest();
    }
    @isTest
    private static void testGetIdOfLastModifiedPlaces(){
        Test.startTest();
        SessionTriggerHandler.getIdOfLastModifiedPlaces(TestDataFactory.getNewSession());
        Test.stopTest();
    }
    /*
    //Don't forget to implement HttpCalloutMock if mocking here
    @isTest
    private static void testEnqueueJobOnDateUpdate(){
        Test.startTest();
        SessionTriggerHandlerTest httpMock;
        httpMock = new SessionTriggerHandlerTest (200, 'Complete', '{}', null);
        Test.setMock(HttpCalloutMock.class, httpMock);
        SessionTriggerHandler.enqueueJobOnDateUpdate(new List<Session__c>{null},new List<Session__c>{new Session__c()});
        httpMock=new SessionTriggerHandlerTest(200,'Complete','{}',null);
        Test.setMock(HttpCalloutMock.class,httpMock);
        SessionTriggerHandler.enqueueJobOnDateUpdate(null,new List<Session__c>{new Session__c()});
        Test.stopTest();
    }
    */
}
