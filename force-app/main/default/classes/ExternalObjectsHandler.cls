public with sharing class ExternalObjectsHandler implements Queueable, Database.AllowsCallouts {
    public ExternalObjectsHandler() {

    }

    public void execute(QueueableContext context) {
        //GET + deserialize
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        
        request.setEndpoint('https://jsonplaceholder.typicode.com/posts');
        request.setMethod('GET');
        HttpResponse response = http.send(request);
        
        if(response.getStatusCode() == 200) {    
            List<JSONPlaceHolder> results = JSONPlaceHolder.parse(response.getBody());
            List<ExternalObject__c> extObjects = new List<ExternalObject__c>();

            for (JSONPlaceHolder j : results) {
                extObjects.add(new ExternalObject__c(body__c = j.body,
                                                     id__c = j.id,
                                                     title__c = j.title,
                                                     userId__c = j.userId));
            }
        insert extObjects;
        System.enqueueJob(new ExternalObjectHandlerPOST());
        }
    }

    public static void cleanBeforeQueue(){
        List<ExternalObject__c> objectsToDelete = [SELECT id FROM ExternalObject__c];
        if (!objectsToDelete.isEmpty()) {
            delete objectsToDelete;
        }
    }

}