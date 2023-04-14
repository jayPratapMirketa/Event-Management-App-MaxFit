// Defining a public class named SpeakerRegistrationCustomController
public class SpeakerRegistrationCustomController {

    // Declaring two public variables of type Event_Speaker__c and Speaker__c with their getter and setter methods
    public Event_Speaker__c eventSpeaker{get; set;}
    public Speaker__c speaker{get; set;}

    // Declaring a public variable of type String
    public String getid;

    // Defining a constructor method for the SpeakerRegistrationCustomController class
    public SpeakerRegistrationCustomController() {

        // Initializing the eventSpeaker and speaker variables
        eventSpeaker = new Event_Speaker__c();
        speaker = new Speaker__c();

        // Getting the value of the 'value' parameter from the current page
        getid = Apexpages.currentPage().getParameters().get('value');
        
        // If 'value' parameter exists, set the Event__c field of eventSpeaker object with the 'value'
        if(getid != null){
            eventSpeaker.Event__c = getid;
        }
    }
    
    // Defining a method named saveRecord which doesn't return anything
    public void saveRecord(){

        // Creating a savepoint for the transaction
        Savepoint sp = Database.setSavePoint();

        try {

            // Inserting the speaker record into the database
            insert speaker;

            // Setting the Speaker__c field of eventSpeaker object with the ID of the newly inserted speaker record
            eventSpeaker.Speaker__c = speaker.id;
            // Inserting the eventSpeaker record into the database
            insert eventSpeaker;

            // Initializing the speaker and eventSpeaker variables
            speaker = new Speaker__c();
            eventSpeaker = new Event_Speaker__c();

        } catch (Exception e) {

            // Printing the exception message to the debug log
            System.debug('The following exception has occurred: ' + e.getMessage());

            //call the ErrorLogObject class method to store the error occured.
            ErrorLogObject.insertErrorRecords(e.getMessage(), 'error occured');

            // Rolling back the transaction to the savepoint
            Database.rollback(sp);
        }
    }
}