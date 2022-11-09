public with sharing class SessionTriggerHandler {

    public static Boolean isScheduled = false;

    public static void archiveChecker (List<Session__c> newList){
        for (Session__c s : newList) {
            if (s.Session_Date__c < DateTime.now() && s.name.contains('ARCHIVE')) {
                s.isArchive__c = true;
            }
        }     
    }

    @future
    public static void sessionNumUpdate (Set<Id> idOfLastModifiedPlaces){
        if(!isScheduled){
            Map<Id,Decimal> oldValues = oldNumRelatedSes(idOfLastModifiedPlaces);
            Map<Id,Decimal> newValues = newNumRelatedSes(idOfLastModifiedPlaces);
            List<Event_Place__c> updateable = new List<Event_Place__c>();
            Set<Id> setone = oldValues.keySet();        
            for (Id key : setone) {
                if(oldValues.get(key) != newValues.get(key)){
                    updateable.add(new Event_Place__c (Id = key,  
                                                       Number_of_related_sessions__c = newValues.get(key)));
                }
            }
            if(!updateable.isEmpty()){
                update updateable;
            }
        }
    }

    public static Set<Id> getIdOfLastModifiedPlaces(List<Session__c> newOldList){
        Set<Id> idOfLastModifiedRooms = new Set<Id>();
        for (Session__c s: newOldList) {
            idOfLastModifiedRooms.add(s.Room__c);
        }

        List<Room__c> eventPlacesIdList = [SELECT Event_Place__r.Id
                                           FROM Room__c
                                           WHERE Id IN :idOfLastModifiedRooms];

        Set<Id> idOfLastModifiedPlaces = new Set<Id>();
        for (Room__c r : eventPlacesIdList) {
            idOfLastModifiedPlaces.add(r.Event_Place__r.Id);
        }
        return idOfLastModifiedPlaces;
    }

    public static void enqueueJobOnDateUpdate(List<Session__c> newList, List<Session__c> oldList){
        if(isDateChanged(newList, oldList)){
            System.enqueueJob(new ExternalObjectsHandler());
        }
    }
    
    private static Map<Id,Decimal> oldNumRelatedSes(Set<Id> idOfLastModifiedPlaces){
        List<Event_Place__c> places = [SELECT Id, Number_of_related_sessions__c 
                                       FROM Event_Place__c
                                       WHERE Id IN :idOfLastModifiedPlaces];   

        Map<Id,Decimal> oldValues = new Map<Id,Decimal>();
            for (Event_Place__c p : places) {
                oldValues.put(p.Id, p.Number_of_related_sessions__c);
            }
        return oldValues;
    }

    private static Map<Id,Decimal> newNumRelatedSes(Set<Id> idOfLastModifiedPlaces){
        List<AggregateResult> newResult = [SELECT Room__r.Event_Place__r.Id, 
                                           COUNT(Id) counter 
                                           FROM Session__c
                                           WHERE Room__r.Event_Place__r.Id IN :idOfLastModifiedPlaces
                                           GROUP BY Room__r.Event_Place__r.Id];

        Map<Id,Decimal> newValues = new Map<Id,Decimal>();
            for (AggregateResult agr : newResult) {
                newValues.put((Id)agr.get('Id'), (Decimal)agr.get('counter'));
            }
        return newValues;
    }

    private static Boolean isDateChanged (List<Session__c> newList, List<Session__c> oldList){
        for(Session__c sn : newList){
            for (Session__c so : oldList) {
                if(sn.Session_Date__c != so.Session_Date__c){
                    return true;
                }
            }
        }
        return false;
    }
}