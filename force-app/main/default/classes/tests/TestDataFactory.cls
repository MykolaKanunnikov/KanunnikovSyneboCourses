public class TestDataFactory implements HttpCalloutMock{
    //JSONPlaceholder
    public static String getBodyJSONPlaceholder(){
        JSONPlaceHolder extObject = new JSONPlaceHolder('userId', 'id', 'title', 'body');
        List<JSONPlaceHolder> extObjectList = new List<JSONPlaceHolder>();
        extObjectList.add(extObject);
        return System.JSON.serialize(extObjectList);
    }

    //SessionTriggerHandler
    public static Set<Id> getIdofFewPlaces(){
        List<Event_Place__c> epList = [SELECT Id FROM Event_Place__c LIMIT 10];
        Set<Id> idofFewPlaces = new Set<Id>();
        for (Event_Place__c ep : epList) {
            idofFewPlaces.add(ep.id);
        }
        return idofFewPlaces;
    }

    public static List<Session__c> getNewSession(){
        //You may need to check whether Room__c id is valid
        Session__c newSession= new Session__c(Name = 'testSession', 
                                              Room__c = Id.valueOf('a067Q000007EphuQAC'));
        List<Session__c> sList = new List<Session__c>();
        sList.add(newSession);
        return sList;
    }

    
    public static HTTPResponse respond(HTTPRequest req) {
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody('{"example":"test"}');
        res.setStatusCode(200);
        return res;
    }
    

}