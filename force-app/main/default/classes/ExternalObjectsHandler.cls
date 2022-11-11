public with sharing class ExternalObjectsHandler implements Queueable, Database.AllowsCallouts {
    public ExternalObjectsHandler() {

    }

    public void execute(QueueableContext context) {
        //GET + deserialize
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        
        request.setEndpoint('callout:Legacy/posts');
        request.setMethod('GET');
        HttpResponse response = http.send(request);
        
        if(response.getStatusCode() == 200) {    
            //System.JSON.deserialize under the hood of the parse method
            List<JSONPlaceHolder> results = JSONPlaceHolder.parse(response.getBody());
            List<ExternalObject__c> extObjects = new List<ExternalObject__c>();

            for (JSONPlaceHolder j : results) {
                extObjects.add(new ExternalObject__c(body__c = j.body,
                                                     id__c = j.id,
                                                     title__c = j.title,
                                                     userId__c = j.userId));
            }
        upsert extObjects;
        
        if(!Test.isRunningTest()){
        System.enqueueJob(new ExternalObjectHandlerPOST());
        }
    }
    }

}