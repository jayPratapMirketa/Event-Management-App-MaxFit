// This code defines a RESTful web service for querying Event records in Salesforce.

@RestResource(urlMapping='/Events/*') // This annotation specifies the URL mapping for the REST API endpoint.

global with sharing class EventWebService {
    // This class is marked 'global with sharing' to ensure that the sharing rules for the current user are enforced.

    @HttpGet
    global static List<Event__c> getEvent() {
        // This method handles HTTP GET requests to the API endpoint, and returns a list of Event__c records.

        List<Event__c> result = [
            // This SOQL query selects the Name, Max_Seats, Start, and related fields for all Event__c records.
            Select Name__c, Max_Seats__c, Start__c, Event_Organizer__r.Name, Event_Organizer__r.Email__c 
            FROM Event__c
        ];

        return result; // The result is returned to the API caller as a JSON-encoded list of records.
    }
}