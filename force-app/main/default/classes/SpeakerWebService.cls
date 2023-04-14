// This code defines a RESTful web service for creating Speaker records in Salesforce.

@RestResource(urlMapping='/Speaker/*') // This annotation specifies the URL mapping for the REST API endpoint.

global with sharing class SpeakerWebService {
    // This class is marked 'global with sharing' to ensure that the sharing rules for the current user are enforced.

    @HttpPost
    global static Id createSpeaker(String name, String email, String phone, String company) {
        // This method handles HTTP POST requests to the API endpoint, and creates a new Speaker__c record.

        Speaker__c speaker = new Speaker__c();
        // Create a new Speaker__c record with the specified name, email, phone, and company fields.
        speaker.Name = name;
        speaker.Email__c = email;
        speaker.Phone__c = phone;
        speaker.Company__c = company;

        try {
            insert speaker; // Try to insert the new Speaker__c record.
            RestContext.response.statuscode = 201; // Set the HTTP response status code to 201 (Created).
            return speaker.id; // Return the ID of the newly created record.
        } catch (Exception e) {
            RestContext.response.statuscode = 410; // Set the HTTP response status code to 410 (Gone).
            return null; // If there was an error creating the record, return null.
        }
    }
}