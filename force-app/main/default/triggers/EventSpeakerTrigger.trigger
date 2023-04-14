trigger EventSpeakerTrigger on Event_Speaker__c (before insert) {

    //Calling the method speakerBookingCheck from the class EventSpeakerTriggerHandler by passing trigger.new as parameter
    if(trigger.isBefore && trigger.isInsert){
        EventSpeakerTriggerHandler.speakerBookingCheck(trigger.new);
    }
}