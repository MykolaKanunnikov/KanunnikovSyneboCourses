@isTest
private class SessionTriggerHandlerTest{

    @isTest
    private static void testArchiveCheckerInsert(){
        List<Session__c> newList = TestDataFactory.getNewSession(1);
        newList[0].Session_Date__c = Datetime.now().addDays(-3);
        newList[0].Name = 'ARCHIVE 1';
        newList[0].isArchive__c = false;

        Test.startTest();
        insert newList;
        Test.stopTest();

        List<Session__c> sList = [SELECT Id, isArchive__c FROM Session__c WHERE Id IN :newList];
        Boolean res = sList[0].isArchive__c;
        Assert.areEqual(true, res, 'Checkbox should be checked but it is not'); 
    }
    
    @isTest
    private static void testSessionNumUpdate(){
        List<Session__c> s = TestDataFactory.getNewSession(1);
        Test.startTest();
        Database.SaveResult[] dsr = Database.insert(s);
        Database.DeleteResult[] ddr = Database.delete(s);
        Test.stopTest();
        Assert.areEqual(dsr[0].isSuccess(), ddr[0].isSuccess(), 'DML exception');
    }
    
    @isTest
    private static void testGetIdOfLastModifiedPlaces(){
        Set<Id> idSet = TestDataFactory.getIdofFewPlaces(10);
        List<Session__c> s = [SELECT Id FROM Session__c WHERE Id IN :idSet];
        Test.startTest();
        Set<Id> epId = SessionTriggerHandler.getIdOfLastModifiedPlaces(s);
        Test.stopTest();
        for (Session__c ses: s) {
            for (Id ep : epId) {
                Assert.areEqual(ses.Room__r.Event_Place__r.Id, ep, 'Id mismatch');  
            }
        }
    }

    @isTest
    private static void testIsDateChangedNegative(){
        List<Session__c> s = TestDataFactory.getNewSession(1);
        Test.startTest();
        Boolean subjectResult = SessionTriggerHandler.isDateChanged(s, s);
        Test.stopTest();
        Assert.areEqual(false, subjectResult, 'No date modification expected');
    }

    @isTest
    private static void testIsDateChangedPositive(){
        List<Session__c> s = TestDataFactory.getNewSession(1);
        List<Session__c> s2 = TestDataFactory.getNewSession(1);
        s2[0].Session_Date__c = Datetime.now();
        Test.startTest();
        Boolean subjectResult = SessionTriggerHandler.isDateChanged(s, s2);
        Test.stopTest();
        Assert.areEqual(true, subjectResult, 'Date modification expected');
    }

    @isTest
    private static void testEnqueueJobOnDateUpdate(){
        List<Session__c> s = TestDataFactory.getNewSession(1);
        insert s;
        List<Session__c> s2 = [SELECT Id, Session_Date__c FROM Session__c WHERE Id IN :s];
        s2[0].Session_Date__c = Datetime.now();
        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new TestDataFactory());
        update s2;
        Test.stopTest();

        String resJSON = '[ { "userId": 1, "id": 1, "title": "sunt aut facere repellat provident occaecati excepturi optio reprehenderit", "body": "quia et suscipit\\nsuscipit recusandae consequuntur expedita et cum\\nreprehenderit molestiae ut ut quas totam\\nnostrum rerum est autem sunt rem eveniet architecto" }, { "userId": 1, "id": 2, "title": "qui est esse", "body": "est rerum tempore vitae\\nsequi sint nihil reprehenderit dolor beatae ea dolores neque\\nfugiat blanditiis voluptate porro vel nihil molestiae ut reiciendis\\nqui aperiam non debitis possimus qui neque nisi nulla" }]';
        List<JSONPlaceHolder> eoExpected = (List<JSONPlaceHolder>) JSON.deserialize(resJSON, List<JSONPlaceHolder>.class);
        List<ExternalObject__c> eoActual = [SELECT id__c, title__c FROM ExternalObject__c WHERE id__c = '1'];
        Assert.areEqual(eoExpected[0].title, eoActual[0].title__c, 'Expected object missing');
    }
}
