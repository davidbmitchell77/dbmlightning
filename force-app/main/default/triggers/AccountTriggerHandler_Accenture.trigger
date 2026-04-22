trigger AccountTriggerHandler_Accenture on Account (before insert, before update, before delete, after insert, after update, after delete, after undelete) {
    private Boolean runTriggerHandler = false;

    switch on Trigger.operationType {
        when BEFORE_INSERT {
            runTriggerHandler = false;
        }
        when BEFORE_UPDATE {
            runTriggerHandler = false;
        }
        when BEFORE_DELETE {
            runTriggerHandler = false;
        }
        when AFTER_INSERT {
            runTriggerHandler = false;
        }
        when AFTER_UPDATE {
            runTriggerHandler = true;
        }
        when AFTER_DELETE {
            runTriggerHandler = false;
        }
        when AFTER_UNDELETE {
            runTriggerHandler = false;
        }
    }

    if (runTriggerHandler == true) {
        AccountTriggerHandler_Accenture handler = new AccountTriggerHandler_Accenture(Trigger.operationType);
        if (handler.isValid(Trigger.new)) {
            handler.run(Trigger.old, Trigger.new, Trigger.newMap, Trigger.oldMap);
        }
    }
}