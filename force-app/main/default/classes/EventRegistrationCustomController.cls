/**
 * The EventRegistrationCustomController class manages the creation of new events and event organizers in Salesforce.
 * This class contains methods for creating and saving new records for Event_Organizer__c, Event__c, and Location_Address_Book__c objects.
 */
public with sharing class EventRegistrationCustomController {

    // Properties
    // An instance of the Event_Organizer__c object.
    public Event_Organizer__c eventOrg{get; set;}

    // An instance of the Event__c object.
    public Event__c event{get; set;}

    // An instance of the Location_Address_Book__c object for the event location.
    public Location_Address_Book__c locationEvent{get; set;}

    // Constructor

    /**
     * Initializes new instances of the Event_Organizer__c, Event__c, Location_Address_Book__c objects.
     */
    public EventRegistrationCustomController() {
        eventOrg = new Event_Organizer__c();
        event = new Event__c();
        locationEvent = new Location_Address_Book__c();
    }

    // Methods
    
    /**
     * Creates new records for Event_Organizer__c, Event__c, and Location_Address_Book__c objects, and saves them to Salesforce.
     * If the event type is 'Virtual', only the event organizer location is inserted.
     * If an exception occurs during the process, the transaction is rolled back.
     */
    public void saveRecord(){
        // Set a save point to roll back if an exception occurs.
        Savepoint sp = Database.setSavePoint();

        try {
            // If the event is not virtual, add the location of the event.
            if(event.Event_Type__c != 'Virtual'){
                insert locationEvent;
            }

            // Set the locations of the event and event organizer.
            // System.debug(locationEvent.id);
            event.Location__c = locationEvent.id;
            

            // Initialize new instances of Location_Address_Book__c objects.
            locationEvent = new Location_Address_Book__c();

            // Insert the event organizer.
            insert eventOrg;
            eventOrg = new Event_Organizer__c();

            // Insert the event.
            insert event;
            event = new Event__c();


        } catch (Exception e) {

            // Debug the exception and insert an error log.
            System.debug('The following exception has occurred: ' + e.getMessage());

            // call ErrorLogObject class method to store the error if any occurs.
            ErrorLogObject.insertErrorRecords(e.getMessage(), 'message');

            // Roll back the transaction to the save point.
            Database.rollback(sp);
        }
    }
}