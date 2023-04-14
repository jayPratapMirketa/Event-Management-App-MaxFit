public class EventAttendeeTriggerHandler {

    // This method sends emails to attendees of events.
    public static void attendeeEmailSend(List<Event_Attendee__c> eventAttendeeNewRecords) {
        
        // Create a list to hold the email messages.
        List<Messaging.SingleEmailMessage> emails = new List<Messaging.SingleEmailMessage>();
       
        // Create sets to hold the ids of events and attendees.
        Set<Id> eventIds = new Set<Id>();
        Set<Id> attendeeIds = new Set<Id>();

        // Loop through the new event attendee records.
        for (Event_Attendee__c eventAttendeeNewRecord : eventAttendeeNewRecords) {

            // Check if the event or attendee is null before adding the ids to the respective sets.
            if (eventAttendeeNewRecord.Event__c != null || eventAttendeeNewRecord.Attendees__c != null) {
                eventIds.add(eventAttendeeNewRecord.Event__c);
                attendeeIds.add(eventAttendeeNewRecord.Attendees__c);
            }
        }
        
        // Query the events and store them in a map using the event id as the key.
        Map<Id, Event__c> eventMap = new Map<Id, Event__c>([
            SELECT Name__c, Start__c, Location__r.Name, Event_Organizer__r.Name 
            FROM Event__c 
            WHERE Id IN :eventIds
        ]);
        
        // Query the attendees and store them in a map using the attendee id as the key.
        Map<Id, Attendees__c> attendeeMap = new Map<Id, Attendees__c>([
            SELECT Name, Email__c 
            FROM Attendees__c 
            WHERE Id IN :attendeeIds]);
        
        // Iterate through the new records in the Event_Attendee__c custom object again.
        for (Event_Attendee__c eventAttendeeNewRecord : eventAttendeeNewRecords) {
                      
            // Get the event and attendee corresponding to the event ID and attendee ID in the current record.
            Event__c event = eventMap.get(eventAttendeeNewRecord.Event__c);
            Attendees__c attendee = attendeeMap.get(eventAttendeeNewRecord.Attendees__c);
            
            // Create a new SingleEmailMessage object for each attendee.
            Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
            email.setToAddresses(new String[]{attendee.Email__c});
            email.setSubject('Pass for the "' + event.Name__c + '"');
            email.setPlainTextBody('Dear ' + attendee.Name + ',\n\nThank you for registering for "' 
                                   + event.Name__c + '" which will be organized on '
                                   + event.Start__c.format('dd/mm/yyyy') + ' and will be held in '
                                   + event.Location__r.Name + '. We are excited to have you, see you at the event.\n\nThanks,\n'
                                   + event.Event_Organizer__r.Name);
            emails.add(email);
           
            
        }
        
        // Send the emails using the Messaging.sendEmail method.
        try {
            Messaging.sendEmail(emails);
        } catch (Exception e) {
            // If there is an error sending the emails, insert an error record in the Error_Log__c custom object using the ErrorLogObject
            ErrorLogObject.insertErrorRecords(e.getMessage(), 'Error sending email');
        }
    }
}