public with sharing class ExternalCommentsHandler implements Queueable, Database.AllowsCallouts {
    public ExternalCommentsHandler() {

    }

    public void execute(QueueableContext context) {
        //GET + deserialize
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        
        request.setEndpoint('callout:Legacy/comments');
        request.setMethod('GET');
        HttpResponse response = http.send(request);
        
        if(response.getStatusCode() == 200) {    
            List<Comment> results = (List<Comment>) System.JSON.deserialize(response.getBody(), List<Comment>.class);
            
            List<Comment__c> extObjects = new List<Comment__c>();

            for (Comment c : results) {
                extObjects.add(new Comment__c(postid__c = c.postId,
                                              id__c = c.id,
                                              name__c = c.name,
                                              email__c = c.email,
                                              body__c = c.body));
            }
        insert extObjects;
        }
    }


    public class Comment{
        public String postId;
        public String id;
        public String name;
        public String email;
        public String body;
    }
}
