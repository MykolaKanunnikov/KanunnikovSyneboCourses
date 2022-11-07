public with sharing class SessionNumScheduledBatch implements Database.Batchable<SObject>, Schedulable {
    
    //This batch updates records that were not modified during last 3 days.
    //Only number of related sessions updated, where appropriate 

    private static String dateToCompare = Datetime.now().addDays(-3).format('yyyy-MM-dd\'T\'HH:mm:ss\'Z\'');
    private static String query ='SELECT Id, Number_of_related_sessions__c FROM Event_Place__c WHERE Allow_statistics__c = true AND lastModifiedDate <= ' + dateToCompare;
    
    public SessionNumScheduledBatch() {

    }

    public static void fireOncePerDaySchedule(){
        String cronExp = '0 0 0 ? * * *';
        System.schedule('DailySessionNumUpdate', cronExp, new SessionNumScheduledBatch());
    }

    public void execute(SchedulableContext ctx) {
        Database.executeBatch(new SessionNumScheduledBatch(), 200);
    }

    public Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator(query);
    }

    public void execute(Database.BatchableContext bc, List<Event_Place__c> scope){
        List<AggregateResult> newValuesList = [SELECT Room__r.Event_Place__r.Id, 
                                               COUNT(Id) counter 
                                               FROM Session__c
                                               WHERE Session__c.Event_Place_counter_switch__c = true 
                                               AND Room__r.Event_Place__r.Allow_statistics__c = true
                                               AND Room__r.Event_Place__r.Id IN :scope
                                               GROUP BY Room__r.Event_Place__r.Id];

        Map<Id,Decimal> newValuesMap = new Map<Id,Decimal>();
            for (AggregateResult agr : newValuesList) {
              newValuesMap.put((Id)agr.get('Id'), (Decimal)agr.get('counter'));
            }
    
        Map<Id,Decimal> oldValues = new Map<Id,Decimal>();
            for (Event_Place__c p : scope) {
                oldValues.put(p.Id, p.Number_of_related_sessions__c);
            }          

        List<Event_Place__c> updateable = new List<Event_Place__c>();
        Set<Id> setone = oldValues.keySet();        
        for (Id key : setone) {
            if(oldValues.get(key) != newValuesMap.get(key)){
                updateable.add(new Event_Place__c (Id = key,  
                                                   Number_of_related_sessions__c = newValuesMap.get(key)));
            }
        }
        if(!updateable.isEmpty()){
            update updateable;
        }
    }
    
    public void finish(Database.BatchableContext bc){
    
    }

}