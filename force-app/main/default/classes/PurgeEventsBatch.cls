public class PurgeEventsBatch implements Database.Batchable<sObject>, Database.AllowsCallouts {
    
    // Execute method to query and delete old, organized events
    public Database.QueryLocator start(Database.BatchableContext bc) {
        String query = 'SELECT Id From Event__c Where End__c <= LAST_N_MONTHS:2 AND Live__c = true';
        return Database.getQueryLocator(query);
    }
    
    public void execute(Database.BatchableContext bc, List<Event__c> scope) {
        // Delete events in batch
        delete scope;
    }
    
    // Send an email to admin once batch processing is complete
    public void finish(Database.BatchableContext bc) {
        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
        String[] toAddresses = new String[]{'jay.pratap@mirketa.com'}; // Change to admin email address
        email.setToAddresses(toAddresses);
        email.setSubject('Batch Job Completed Successfully');
        email.setPlainTextBody('The batch job to purge old events has completed successfully.');
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email});
    }
}