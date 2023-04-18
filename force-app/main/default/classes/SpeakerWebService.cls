// This code defines a RESTful web service for creating Speaker records in Salesforce.

 // This annotation specifies the URL mapping for the REST API endpoint.

@RestResource(urlMapping='/Speaker/*')
global with sharing class SpeakerWebService {
    // This class is marked 'global with sharing' to ensure that the sharing rules for the current user are enforced.

    @HttpPost
    global static Id createSpeaker() {
        // This method handles HTTP POST requests to the API endpoint, and creates a new Speaker__c record.
    
        RestRequest request = RestContext.request;   
        
        List<SpeakerWrapper> speakerObjects = speakerWrapper.convertJson(request.requestBody.toString());
        List<Speaker__c> speakerList = new List<Speaker__c>();

        for(SpeakerWrapper speakerObject : speakerObjects){
        Speaker__c speaker = new Speaker__c();
        // Create a new Speaker__c record with the specified name, email, phone, and company fields.
        speaker.Name = speakerObject.name;
        speaker.Email__c = speakerObject.email;
        speaker.Phone__c = speakerObject.phone;
        speaker.Company__c = speakerObject.company;
        speakerList.add(speaker);
        
        }

        try {
            insert speakerList; // Try to insert the new Speaker__c record.
            RestContext.response.statuscode = 201; // Set the HTTP response status code to 201 (Created).
            return speakerList[0].id; // Return the ID of the newly created record.
        } catch (Exception e) {
            RestContext.response.statuscode = 410; // Set the HTTP response status code to 410 (Gone).
            return null; // If there was an error creating the record, return null.
        }
    }
}