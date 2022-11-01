trigger SessionTrigger on Session__c (before insert, before update, 
                                      after insert, after delete, after update) {

    switch on Trigger.operationType {
        when BEFORE_INSERT{
            SessionTriggerHandler.archiveCheckerBeforeInsert(Trigger.new);
        } 
        when BEFORE_UPDATE{
            SessionTriggerHandler.archiveCheckerBeforeUpdate(Trigger.new, Trigger.old);
        }
         when AFTER_INSERT{
            SessionTriggerHandler.sessionNumUpdate();
        }  
         when AFTER_DELETE{
            SessionTriggerHandler.sessionNumUpdate();
        } 
        when AFTER_UPDATE{
            SessionTriggerHandler.enqueueJobOnDateUpdate(Trigger.new, Trigger.old);
        }
    }
}