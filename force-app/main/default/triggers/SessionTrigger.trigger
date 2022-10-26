trigger SessionTrigger on Session__c (before insert, before update, after insert, after delete) {

    switch on Trigger.operationType {
        when BEFORE_INSERT{
            SessionTriggerHandler.archiveChecker(Trigger.new);
        } 
        when BEFORE_UPDATE{
            if(SessionTriggerHandler.isDateChanged(Trigger.new)){
                SessionTriggerHandler.archiveChecker(Trigger.new);
            }
        }
         when AFTER_INSERT{
            SessionTriggerHandler.sessionNumUpdate();
        }  
         when AFTER_DELETE{
            SessionTriggerHandler.sessionNumUpdate();
        } 
    }
}
