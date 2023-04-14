@isTest
public class PurgeEventsBatchTest {

    // Define the test method
    @isTest
    static void testDeleteEvents() {

        // Create test events that meet the criteria for deletion
        List<Event__c> eventsToDelete = new List<Event__c>();
        for (Integer i = 0; i < 200; i++) {
            Event__c event = new Event__c();
            event.Name__c = 'Test Event ' + i;
            event.Start__c = Date.today().addMonths(-5);
            event.End__c = Date.today().addMonths(-3);
            event.Live__c = true;
            eventsToDelete.add(event);
        }
        insert eventsToDelete;

        Test.startTest();

        // Start the batch process
        PurgeEventsBatch batch = new PurgeEventsBatch();
        Database.executeBatch(batch);
        Test.stopTest();

        // Verify that the events were deleted
        List<Event__c> remainingEvents = [SELECT Id FROM Event__c];
        System.assertEquals(0, remainingEvents.size());

        // Verify that the admin received an email
        List<EmailMessage> sentEmails = [SELECT Id, ToAddress FROM EmailMessage WHERE Subject = 'Batch Job Completed Successfully'];
        System.assertEquals(1, sentEmails.size());
        System.assertEquals('jay.pratap@mirketa.com', sentEmails[0].ToAddress);
    
    }
}