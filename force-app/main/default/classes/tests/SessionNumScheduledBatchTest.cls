@isTest
private class SessionNumScheduledBatchTest {
    /*
    @TestSetup
    private static void makeData(){
        List<Session__c> sList = TestDataFactory.getNewSession(3);
        insert sList;
    }
*/
    
    @isTest
    private static void test() {
        List<Session__c> s = TestDataFactory.getNewSession(5);        
        insert s;

        Test.startTest();
        Database.executeBatch(new SessionNumScheduledBatch());
        SessionNumScheduledBatch.fireOncePerDaySchedule();
        Test.stopTest();

        List<Event_Place__c> epList = [SELECT Id, Number_of_related_sessions__c FROM Event_Place__c]; 

        Assert.areEqual(5, epList[0].Number_of_related_sessions__c, 'Incorrect number');  
    }
    


}
