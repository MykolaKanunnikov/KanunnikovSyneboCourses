@isTest
private class ExternalObjectHandlerPOSTTest implements HttpCalloutMock {
    @isTest
    private static void executeTest(){
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new ExternalObjectHandlerPOSTTest());
        System.enqueueJob(new ExternalObjectHandlerPOST());
        Test.stopTest();
    }

    public static HTTPResponse respond(HTTPRequest req) {
        Assert.areEqual('callout:Legacy/posts', req.getEndpoint());
        Assert.areEqual('POST', req.getMethod());
        HttpResponse response = new HttpResponse();
        response.setBody('{}');
        response.setStatusCode(200);
        return response;
    }

}
