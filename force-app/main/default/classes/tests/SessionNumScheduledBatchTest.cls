@isTest
private class SessionNumScheduledBatchTest {
    
    @isTest
    private static void test() {
        //static resource session to meet the batch last modification date requirements
        Session__c[] sList = test.loadData(Session__c.sObjectType,'sfseLastModDateInPast');
        
        Test.startTest();
        Database.executeBatch(new SessionNumScheduledBatch());
        SessionNumScheduledBatch.fireOncePerDaySchedule();
        Test.stopTest();

        List<Event_Place__c> epList = [SELECT Id, Number_of_related_sessions__c 
                                       FROM Event_Place__c]; 
        //be aware of expected value
        Assert.areEqual(1, epList[0].Number_of_related_sessions__c, 'Incorrect number');  
    }
    


}
