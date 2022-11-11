@isTest
public class TestExternalCommentsHandler implements HttpCalloutMock {
    @isTest
    public static void testCommentsCallout(){
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new TestExternalCommentsHandler());
        System.enqueueJob(new ExternalCommentsHandler());
        Test.stopTest();
        List<Comment__c> c = [SELECT postId__c, id__c FROM Comment__c WHERE id__c = '2'];
        Assert.areEqual('1', c[0].postId__c, 'postId mismatch');
    }

    public static HTTPResponse respond(HTTPRequest req) {
        Assert.areEqual('callout:Legacy/comments', req.getEndpoint());
        Assert.areEqual('GET', req.getMethod());
        HttpResponse response = new HttpResponse();
        String s = '[ { "postId": 1, "id": 1, "name": "id labore ex et quam laborum", "email": "Eliseo@gardner.biz", "body": "laudantium enim quasi est quidem magnam voluptate ipsam eos\\ntempora quo necessitatibus\\ndolor quam autem quasi\\nreiciendis et nam sapiente accusantium" }, { "postId": 1, "id": 2, "name": "quo vero reiciendis velit similique earum", "email": "Jayne_Kuhic@sydney.com", "body": "est natus enim nihil est dolore omnis voluptatem numquam\\net omnis occaecati quod ullam at\\nvoluptatem error expedita pariatur\\nnihil sint nostrum voluptatem reiciendis et" }]';
        response.setBody(s);
        response.setStatusCode(200);
        return response;
    }

}
