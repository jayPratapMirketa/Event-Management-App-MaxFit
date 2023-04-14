@isTest
private class ErrorLogObjectTest {
    // Test method to test the insertErrorLog method
    @isTest 
     public static void testInsertErrorRecords() {

        // Create test data
        Error_Log__c errorLog = new Error_Log__c();
        dateTime logDateTime = System.now();
        String logDetails = 'Test error log details';
        String processName = 'Test process name';
        insert errorLog;

        // Call the insertErrorLog method
        Test.startTest();
        system.assertEquals(logDetails,'Test error log details');
        system.assertEquals(processName,'Test process name');
        system.assertEquals(logDateTime,System.now());
        ErrorLogObject.insertErrorRecords(logDetails, processName);
       
        Test.stopTest();
        
    }
}