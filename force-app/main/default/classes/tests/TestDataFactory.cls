@isTest
public class TestDataFactory implements HttpCalloutMock{
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
    
    //ExternalObjectsHandler called from SessionTriggerHandler
    public static HTTPResponse respond(HTTPRequest req) {
        Assert.areEqual('callout:Legacy/posts', req.getEndpoint());
        Assert.areEqual('GET', req.getMethod());
        String resJSON = '[ { "userId": 1, "id": 1, "title": "sunt aut facere repellat provident occaecati excepturi optio reprehenderit", "body": "quia et suscipit\\nsuscipit recusandae consequuntur expedita et cum\\nreprehenderit molestiae ut ut quas totam\\nnostrum rerum est autem sunt rem eveniet architecto" }, { "userId": 1, "id": 2, "title": "qui est esse", "body": "est rerum tempore vitae\\nsequi sint nihil reprehenderit dolor beatae ea dolores neque\\nfugiat blanditiis voluptate porro vel nihil molestiae ut reiciendis\\nqui aperiam non debitis possimus qui neque nisi nulla" }]';
        HttpResponse response = new HttpResponse();
        response.setBody(resJSON);
        response.setStatusCode(200);
        return response;
    }
    

}