public with sharing class SessionTriggerHandler {
    public SessionTriggerHandler() {

    }

    public static Boolean isScheduled = true;

    public static void archiveCheckerBeforeInsert (List<Session__c> newList){
        if (isDateInThePast(newList)) {
            for (Session__c s : newList) {
                if (s.name.contains('ARCHIVE')) {
                    s.isArchive__c = true;
                }
            }     
        }
    }

    public static void archiveCheckerBeforeUpdate (List<Session__c> newList, List<Session__c> oldList){
        if (isDateChanged(newList, oldList)) {
            for (Session__c s : newList) {
                if (s.name.contains('ARCHIVE')) {
                    s.isArchive__c = true;
                }
            }     
        }
    }

    @future
    public static void sessionNumUpdate (){
        if(!isScheduled){
            Map<Id,Decimal> oldValues = oldNumRelatedSes();
            Map<Id,Decimal> newValues = newNumRelatedSes();
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

    public static void enqueueJobOnDateUpdate(List<Session__c> newList, List<Session__c> oldList){
        if(isDateChanged(newList, oldList)){
            ExternalObjectsHandler.cleanBeforeQueue();
            System.enqueueJob(new ExternalObjectsHandler());
        }
    }

    private static Boolean isDateInThePast (List<Session__c> newList){
        for(Session__c s : newList){
            if(s.Session_Date__c < DateTime.now()){
                return true;
            }
        }
        return false;
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

    private static Map<Id,Decimal> oldNumRelatedSes(){
        List<Event_Place__c> places = [SELECT Id, 
                                      Number_of_related_sessions__c 
                                      FROM Event_Place__c];
        Map<Id,Decimal> oldValues = new Map<Id,Decimal>();
            for (Event_Place__c p : places) {
                oldValues.put(p.Id, p.Number_of_related_sessions__c);
            }
        return oldValues;
    }

    private static Map<Id,Decimal> newNumRelatedSes(){
        List<AggregateResult> newResult = [SELECT Room__r.Event_Place__r.Id, 
                                           COUNT(Id) counter 
                                           FROM Session__c
                                           WHERE Session__c.Event_Place_counter_switch__c = true
                                           GROUP BY Room__r.Event_Place__r.Id];
        Map<Id,Decimal> newValues = new Map<Id,Decimal>();
            for (AggregateResult agr : newResult) {
                newValues.put((Id)agr.get('Id'), (Decimal)agr.get('counter'));
            }
        return newValues;
    }
}