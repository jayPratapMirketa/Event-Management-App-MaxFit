trigger EventAttendeeTrigger on Event_Attendee__c (after insert) {

    //Calling the method attendeeEmailSend from the class EventAttendeeTriggerHandler by passing trigger.new as parameter
    if(trigger.isAfter && trigger.isInsert){
        EventAttendeeTriggerHandler.attendeeEmailSend(trigger.new);
    }
}