public with sharing class SessionTriggerHandler {
    public SessionTriggerHandler() {

    }

    public static void archiveChecker (List<Session__c> beforeContext){
        for (Session__c s : beforeContext) {
            if (s.name.contains('ARCHIVE')) {
                s.isArchive__c = true;
            }
        } 
    }

    public static Boolean isDateChanged (List<Session__c> newList){
        for(Session__c s : newList){
            if(s.Session_Date__c < DateTime.now()){
                return true;
            }
        }
        return false;
    }

    public static void sessionNumUpdate (){
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
