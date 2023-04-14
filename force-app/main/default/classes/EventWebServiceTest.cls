// This code defines a test class for the EventWebService Apex class.

@isTest
private class EventWebServiceTest {

    @isTest
    public static void testEventWebService() {
        // This method tests the behavior of the EventWebService class.

        // Create a new Event_Organizer__c record to use as a related object in the test.
        Event_Organizer__c eventOrganizer = new Event_Organizer__c();
        eventOrganizer.Name = 'New Organizer';
        eventOrganizer.Email__c = 'jay.pratap@mirketa.com';
        insert eventOrganizer;

        // Create a new Event__c record to test the retrieval of event data.
        Event__c event = new Event__c();
        event.Name__c = 'Event Name';
        event.Max_Seats__c = 5;
        event.Start__c = System.now();
        insert event;

        // Start the test context.
        Test.startTest();

        // Call the EventWebService's getEvent() method to retrieve the event data.
        List<Event__c> eveGet = EventWebService.getEvent();

        // Assert that the retrieved event data is not null, has size 1, and has the expected Name__c value.
        System.assert(eveGet != null);
        System.assert(eveGet.size() == 1);
        System.assertEquals('Event Name', eveGet[0].Name__c);

        // Stop the test context.
        Test.stopTest();
    }
}