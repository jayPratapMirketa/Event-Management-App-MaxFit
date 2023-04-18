public with sharing class speakerWrapper {

        public string name;
        public string email;
        public string phone;
        public string company;
    
    public static List<speakerWrapper> convertJson(String json){
        return (List<speakerWrapper>) System.JSON.deserialize(json, List<speakerWrapper>.class);
    }
}