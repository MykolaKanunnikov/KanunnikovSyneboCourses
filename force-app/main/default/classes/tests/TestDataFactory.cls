@isTest
public class TestDataFactory {
    //JSONPlaceholder
    public static String getBodyJSONPlaceholder(){
        JSONPlaceHolder extObject = new JSONPlaceHolder('userId', 'id', 'title', 'body');
        List<JSONPlaceHolder> extObjectList = new List<JSONPlaceHolder>();
        extObjectList.add(extObject);
        return System.JSON.serialize(extObjectList);
    }

    //SessionTriggerHandler
    public static Set<Id> getIdofFewPlaces(Integer lim){
        List<Event_Place__c> epList = [SELECT Id FROM Event_Place__c LIMIT :lim];
        Set<Id> idofFewPlaces = new Set<Id>();
        for (Event_Place__c ep : epList) {
            idOfFewPlaces.add(ep.id);
        }
        return idofFewPlaces;
    }

    public static List<Session__c> getNewSession(Integer num){
        //You may need to check whether Room__c id is valid
        //Here is the AdminRoom id used
        List<Session__c> sList = new List<Session__c>(); 
        for (Integer i = 0; i < num; i++) {
          sList.add(new Session__c(Name = 'testSession' + String.valueOf(i), 
                                   Room__c = Id.valueOf('a067Q000007EphuQAC')));
        }
        return sList;
    }    

}