public class ErrorLogObject {
    // This method inserts an error record in the Error_Log__c custom object.
    public static void insertErrorRecords(String detailVariable, String processnameVariable){
       
        // Create an instance of the Error_Log__c custom object.
        Error_Log__c err = new Error_Log__c();
        
        // Set the Log_Date_Time__c field of the error record to the current datetime.  
        err.Log_Date_Time__c = datetime.now();

        // Set the Log_Details__c field of the error record to the value of detailVariable.
        err.Log_Details__c = detailVariable;

        // Set the Process_Name__c field of the error record to the value of processnameVariable.
        err.Process_Name__c = processnameVariable;

        // Insert the error record in the Error_Log__c custom object.
        insert err;
    }
}