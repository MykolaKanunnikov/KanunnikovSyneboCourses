public with sharing class QuickActionResponse {
     
    @AuraEnabled
    public Boolean isSuccess { get; set; }
    @AuraEnabled
    public String roomNames { get; set; }
    //public List<String> roomNames { get; set; }

    public QuickActionResponse() {

    }

    public QuickActionResponse(List<Room__c> roomList) {
        this.isSuccess = true;
        System.debug('2.1. roomList: ' + roomList);

        List<String> roomNamesList = new List<String>();
        for (Room__c r : roomList) {
            roomNamesList.add(r.Name);
            System.debug('room name: ' + r.Name);

        }
        String singleString = String.join(roomNamesList, ', ');
        this.roomNames = singleString;
        System.debug('2.2. this room names: ' + this.roomNames);
    }

}
