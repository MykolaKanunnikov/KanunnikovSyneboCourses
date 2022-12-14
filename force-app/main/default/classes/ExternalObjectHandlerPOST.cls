public with sharing class ExternalObjectHandlerPOST implements Queueable, Database.AllowsCallouts {
    public ExternalObjectHandlerPOST() {

    }
    public void execute(QueueableContext context) {
        //POST + serialize
        Http http2 = new Http();
        HttpRequest request2 = new HttpRequest();

        request2.setEndpoint('callout:Legacy/posts');
        request2.setMethod('POST');

        List<ExternalObject__c> objectsToPOST = [SELECT body__c, id__c, title__c, userId__c
                                                 FROM ExternalObject__c
                                                 WHERE id__c = '1'];
        if(Test.isRunningTest()){
            ExternalObject__c e = new ExternalObject__c (body__c = 'test',
                                                         id__c = '1', 
                                                         title__c = 'test', 
                                                         userId__c = 'test');
            objectsToPOST.add(e);
        }       
        List<String> jsonToPostList = new List<String>();
        for (ExternalObject__c e : objectsToPOST) {
            jsonToPostList.add(JSON.serialize(e));
        }

        for (String j : jsonToPostList) {
            request2.setBody(j);
            HttpResponse responseOnPOST = http2.send(request2);

            if(responseOnPOST.getStatusCode() != 201) {
                System.debug('The status code returned was not expected: ' + responseOnPOST.getStatusCode() + ' ' + responseOnPOST.getStatus());
            } else {
                System.debug(responseOnPOST.getBody());
            }
        }
    }
}