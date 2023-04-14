@isTest 
private class EventSpeakerTriggerHandlerTest {

    // Define the test method
    @isTest 
    static void testspeakerBookingCheck() {

        // Create a test location
        Location_Address_Book__c location = new Location_Address_Book__c();
        location.Name = 'Test Location';
        insert location;

        // Create a test event (oldEvent)
        Event__c oldEvent = new Event__c(Name__c = 'Mirketa webinar', Location__c = location.id, Live__c=True, Start__c = Date.today(), End__c = Date.today().addDays(10));
        insert oldEvent;

        Event__c oldEvent1 = new Event__c(Name__c = 'Mirketa webinar', Location__c = location.id, Live__c=True, Start__c = Date.today().addDays(40), End__c = Date.today().addDays(50));
        insert oldEvent1;

        // Create a test event (newEvent)
        Event__c newEvent = new Event__c(Name__c = 'Webinar on AI', Location__c = location.id, Live__c=True, Start__c = Date.today().addDays(5), End__c = Date.today().addDays(15));
        insert newEvent;

        // Create a test speaker
        Speaker__c speaker = new Speaker__c();
        speaker.name = 'Jay Pratap';
        insert speaker;

        // Create a test event speaker booking for the oldEvent
        Event_Speaker__c booking1 = new Event_Speaker__c(Speaker__c = speaker.id, Event__c = oldEvent.Id);
        insert booking1;

        Event_Speaker__c booking2 = new Event_Speaker__c(Speaker__c = speaker.id, Event__c = oldEvent1.Id);
        insert booking2;

        // Create a test event speaker booking for the newEvent
        Event_Speaker__c booking3 = new Event_Speaker__c(Speaker__c = speaker.id, Event__c = newEvent.Id);

        // Add the new event speaker booking to a list
        List<Event_Speaker__c> bookingList = new List<Event_Speaker__c>();
        bookingList.add(booking3);
        
        // Test that the trigger throws an error when trying to insert the second booking
        Test.startTest();
        try {

            // Call the method that is being tested
            EventSpeakerTriggerHandler.speakerBookingCheck(bookingList);
        } 
        catch (DmlException e) {

            // Verify that the expected error message is thrown
            System.assertEquals('Already assigned to Event',e.getMessage());
        }
        Test.stopTest();
    }        
}