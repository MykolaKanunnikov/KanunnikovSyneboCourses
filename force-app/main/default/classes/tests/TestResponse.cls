@isTest
private class TestResponse {
    @isTest(SeeAllData=true)
    private static void testListConstructor(){
        List<Event_Place__c> epList = [SELECT (SELECT Id FROM Rooms__r) 
                                       FROM Event_Place__c 
                                       WHERE Id = 'a0B7Q00000265gVUAQ'];

        Set<Room__c> roomsId = new Set<Room__c>();
        for (Event_Place__c ep : epList) {
           for (Room__c r : ep.Rooms__r) {
                roomsId.add(r);            
           }
        }
        System.debug('roomsId -- ' + roomsId);

        List<Room__c> roomList = [SELECT Name FROM Room__c WHERE Id IN :roomsId];
        System.debug('roomList ' + roomList);

        QuickActionResponse resp = new QuickActionResponse(roomList);
    }
}
