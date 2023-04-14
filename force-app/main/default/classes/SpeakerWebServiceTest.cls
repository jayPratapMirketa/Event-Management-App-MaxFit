// This is a test class for the SpeakerWebService class
@isTest
private with sharing class SpeakerWebServiceTest {

    // This is a test method for the createSpeaker method of the SpeakerWebService class
    // The @isTest annotation indicates that this is a test method
    @isTest
    static void createSpeakerTest() {

        // Start the test
        Test.startTest();

        // Set up the request and response objects for the REST API call
        RestContext.request = new RestRequest();
        RestContext.response = new RestResponse();

        // Call the createSpeaker method to create a new Speaker record
        Id speakerId1 = SpeakerWebService.createSpeaker('Jay', 'jay.pratap@mirketa.com', '7894561232', 'Mirketa');

        // Query the Speaker record to ensure that it was created correctly
        Speaker__c speaker = [Select Id, Name FROM Speaker__c WHERE id =:speakerId1];

        // Assert that the Speaker record was created with the correct values
        System.assert(speakerId1 != null);
        System.assertEquals('Jay', speaker.Name);
        System.assertEquals(201, RestContext.response.statuscode);

        // Stop the test
        Test.stopTest();
    }

    // This is a test method for the duplicateSpeaker method of the SpeakerWebService class
    // The @isTest annotation indicates that this is a test method
    @isTest
    static void duplicateSpeakerTest(){

        // Start the test
        Test.startTest();

        // Set up the request and response objects for the REST API call
        RestContext.request = new RestRequest();
        RestContext.response = new RestResponse();

        // Call the createSpeaker method twice with the same name and email address, which should result in an error
        Id speakerId1 = SpeakerWebService.createSpeaker('Jay1', 'jay.pratap@mirketa.com', '7894561232', 'Mirketa');
        Id speakerId2 = SpeakerWebService.createSpeaker('Jay1', 'jay.pratap@mirketa.com', '7894561232', 'Mirketa');

        // Assert that the second call to createSpeaker returned a null ID and a 410 status code
        System.assertEquals(null,speakerId2);
        System.assertEquals(410, RestContext.response.statuscode);

        // Stop the test
        Test.stopTest();
    }
}