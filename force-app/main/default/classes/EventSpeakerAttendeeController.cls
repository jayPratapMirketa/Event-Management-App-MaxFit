public with sharing class EventSpeakerAttendeeController {

    //Declare public variables
    public Event__c event{get; set;}
    public List<Event_Speaker__c> eventSpeaker{get; set;}
    public String getid{get; set;}

    //Constructor method for the class
    public EventSpeakerAttendeeController() {

        //Get the id parameter from the URL
        getid = Apexpages.currentPage().getParameters().get('id');

        //Check if the id is not null
        if(getid != null){

            //Query the event record from the database based on the id
            this.event = [Select Name, Event_Organizer__r.Name, Location__r.Name, Start__c, End__c FROM Event__c where id = :getid LIMIT 1];

            //Query the event speakers for the current event from the database based on the id
            this.eventSpeaker = [Select Name, Event__c, Event__r.Name__c, Speaker__c, Speaker__r.Name, Speaker__r.Profile_URL__c, Speaker__r.About_Me__c FROM Event_Speaker__c  where Event__c = :getid];
        }
    }

    //Method for the Attendee action button
    public PageReference doAttendeeAction(){

        //Redirect to the AttendeeRegistration page passing the current event id as a parameter
        return new PageReference('/apex/AttendeeRegistration?id='+getid).setRedirect(true);
    }

    //Method for the Speaker action button
    public PageReference doSpeakerAction(){

        //Redirect to the SpeakerRegistration page passing the current event id as a parameter
        return new PageReference('/apex/SpeakerRegistration?id='+getid).setRedirect(true);    
    }
}