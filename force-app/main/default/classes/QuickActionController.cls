public with sharing class QuickActionController {
    
    @AuraEnabled
    public static List<Room__c> showRooms(String recordId){
        System.debug('1.1. recordId ' + recordId);
        List<Event_Place__c> epList = [SELECT (SELECT Id FROM Rooms__r) 
                                       FROM Event_Place__c 
                                       WHERE Id = :recordId];
        System.debug('1.2. epList ' + epList);

        Set<Room__c> roomsId = new Set<Room__c>();
        for (Event_Place__c ep : epList) {
            for (Room__c r : ep.Rooms__r) {
                roomsId.add(r);            
            }
        }
        System.debug('1.3. roomsId ' + roomsId);

        List<Room__c> roomList = [SELECT Name FROM Room__c WHERE Id IN :roomsId];
        System.debug('1.4. roomList ' + roomList);
        return roomList;
}


    
    // The following code snippet returns the expected result. 
    // Nevertheless, it was not rendered on the lwc datatable.
    // The problem includes:
    // 1. JS passes null instead of the current record id.
    // 2. If the id passed (hardcoded), no data on the lwc component is exposed.
    
    /*
    @AuraEnabled
    public static List<String> showRooms(String recordId){
        System.debug('1.1. recordId ' + recordId);
        List<Event_Place__c> epList = [SELECT (SELECT Id FROM Rooms__r) 
                                       FROM Event_Place__c 
                                       WHERE Id = :recordId];
        System.debug('1.2. epList ' + epList);

        Set<Room__c> roomsId = new Set<Room__c>();
        for (Event_Place__c ep : epList) {
            for (Room__c r : ep.Rooms__r) {
                roomsId.add(r);            
            }
        }
        System.debug('1.3. roomsId ' + roomsId);

        List<Room__c> roomList = [SELECT Name FROM Room__c WHERE Id IN :roomsId];
        List<String> roomNamesList = new List<String>();
        for (Room__c r : roomList) {
            roomNamesList.add(r.Name);
            System.debug('room name: ' + r.Name);

        }
     //   String singleString = String.join(roomNamesList, ', ');
     //   System.debug('singleString: ' + singleString);

        return roomNamesList;
}
*/
}