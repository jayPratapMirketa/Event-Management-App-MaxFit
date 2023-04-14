public class EventSpeakerTriggerHandler {

    // This method checks if a speaker is already assigned to another event at the same time
    public static void speakerBookingCheck(List<Event_Speaker__c> newEventSpeakerRecords) {
        
      // Collecting all the new speaker ids and event ids in separate sets for query optimization
      Set<Id> newSpeakerIds = new Set<Id>();
      Set<Id> newEventIds = new Set<Id>();

      // Iterate over the newEventSpeakerRecords list and add the speaker and event IDs to the corresponding sets
      for(Event_Speaker__c newEventSpeakerRecord : newEventSpeakerRecords){
        newSpeakerIds.add(newEventSpeakerRecord.Speaker__c);
        newEventIds.add(newEventSpeakerRecord.Event__c);
      } 
    
      // Querying the new event records for their start and end times
      Map<Id,Event__c> newEventMap = new Map<Id,Event__c>([SELECT Id,Start__c,End__c FROM Event__c WHERE Id IN :newEventIds]);

      // Querying the existing event speaker records
      List<Event_Speaker__c> eventSpeakers = new List<Event_Speaker__c>([SELECT Id, Event__c,Event__r.Name,Event__r.Start__c,Event__r.End__c, Speaker__c FROM  Event_Speaker__c WHERE Speaker__c IN :newSpeakerIds]);

      //Return early if no speaker was found in the event speaker object which can conflict with the inserted or updated records
      if(eventSpeakers.size() == 0){
        return;
      }

      //This map will store the records of eventSpeaker object in a list with a key of their specific speaker so that we can call it inside the code.
      Map<Id,List<Event_Speaker__c>> speakerEventsMap = new Map<Id,List<Event_Speaker__c>>();

      //Entering the key and object list in the map.
      for(Event_Speaker__c eventSpeaker : eventSpeakers){
        if(speakerEventsMap.containsKey(eventSpeaker.speaker__c)){
          //Entering object in the list if the key is already present
          speakerEventsMap.get(eventSpeaker.speaker__c).add(eventSpeaker);
        }
        else{
          //Entering object in the list with the new speaker key.
          speakerEventsMap.put(eventSpeaker.speaker__c, new List<Event_Speaker__c>{eventSpeaker});
        }
      }

      // Iterate over the newEventSpeakerRecords(trigger.new) list again to check for conflicts
      for(Event_Speaker__c newEventSpeakerRecord : newEventSpeakerRecords){

        // Get the data of inserted/updated event record from the newEventMap
        Event__c newEventTime =  newEventMap.get(newEventSpeakerRecord.Event__c);

        //Getting the list of records related to that speaker to check for conflict
        List<Event_Speaker__c> speakerEvents = speakerEventsMap.get(newEventSpeakerRecord.Speaker__c);

        // Iterate over the eventSpeakers list to compare with old events
        for(Event_Speaker__c eventSpeaker : speakerEvents){

          // Check for time conflicts between the Events already assigned to speaker with the new assigned events
          if  ( ((eventSpeaker.Event__r.Start__c <= newEventTime.Start__c) && (eventSpeaker.Event__r.End__c >=newEventTime.Start__c) )||
            ((eventSpeaker.Event__r.Start__c <= newEventTime.End__c )&&(eventSpeaker.Event__r.End__c >=newEventTime.End__c)) ){

              //Throw error if conflict was found
              newEventSpeakerRecord.Speaker__c.addError('Already assigned to Event');
              break;
            }

            
        }

      }

    }
}