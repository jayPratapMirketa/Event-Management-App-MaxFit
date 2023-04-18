/**
This is a custom controller for Attendee Registration for an Event
*/
public with sharing class AttendeeRegistrationCustomController {

    
    // Instance variables for the controller
    public Event_Attendee__c eventAttendee{get; set;}
    public Attendees__c attendee{get; set;}
    public Location_Address_Book__c locationAttendee{get; set;}
    
    public String getid;


    // Constructor method to initialize instance variables and get the Event ID from the URL parameter
    public AttendeeRegistrationCustomController() {
        eventAttendee = new Event_Attendee__c();
        attendee = new Attendees__c();
        // locationAttendee = new Location_Address_Book__c();
        getid = Apexpages.currentPage().getParameters().get('value');
        
        // Set the Event ID for the Event_Attendee__c record
        if(getid != null){
            eventAttendee.Event__c = getid;
        }
        
    }


    /**
    Method to save the Event Attendee registration details
    */
    public void saveRecord(){

        // Create a save point to roll back if there's an exception
        Savepoint sp = Database.setSavePoint();

        try {

            insert locationAttendee;
            // Set the Address__c field on the Attendees__c record to the ID of the Location_Address_Book__c record
            attendee.Address__c = locationAttendee.id;
            // Insert the Attendees__c record
            insert attendee;
            
            // Set the Attendees__c field on the Event_Attendee__c record to the ID of the Attendees__c record
           eventAttendee.Attendees__c = attendee.id;
            // Insert the Event_Attendee__c record
            insert eventAttendee;

            // Clear the instance variables for a new registration
            locationAttendee = new Location_Address_Book__c();
            attendee = new Attendees__c();
            // eventAttendee = new Event_Attendee__c();

            

        } catch (Exception e) {

             // Catch any exceptions, log the error message, insert error records, and rollback to the save point
             System.debug('The following exception has occurred: ' + e.getMessage());

             // call the ErrorLogObject class method to store the error
             ErrorLogObject.insertErrorRecords(e.getMessage(), 'error occured');

             // Rollback, if there is any exception occur in the between
             Database.rollback(sp);
        }

    }

}