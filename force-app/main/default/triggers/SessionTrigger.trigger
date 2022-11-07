trigger SessionTrigger on Session__c (before insert, before update, 
                                      after insert, after delete, after update) {

    switch on Trigger.operationType {
        when BEFORE_INSERT{
            SessionTriggerHandler.archiveChecker(Trigger.new);
        } 
        when BEFORE_UPDATE{
            SessionTriggerHandler.archiveChecker(Trigger.new);
        }
         when AFTER_INSERT{
            SessionTriggerHandler.sessionNumUpdate(SessionTriggerHandler.getIdOfLastModifiedPlaces(Trigger.new));
        }  
         when AFTER_DELETE{
            SessionTriggerHandler.sessionNumUpdate(SessionTriggerHandler.getIdOfLastModifiedPlaces(Trigger.old));
        } 
        when AFTER_UPDATE{
            SessionTriggerHandler.enqueueJobOnDateUpdate(Trigger.new, Trigger.old);
        }
    }
}