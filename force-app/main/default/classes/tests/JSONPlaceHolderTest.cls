@isTest
private class JSONPlaceHolderTest {

    @isTest
    private static void parserTest(){
        String jsonSample = TestDataFactory.getBodyJSONPlaceholder();
        List<JSONPlaceHolder> expected = (List<JSONPlaceHolder>) System.JSON.deserialize(jsonSample, List<JSONPlaceHolder>.class);
        Test.startTest();
        List<JSONPlaceHolder> testSubject = JSONPlaceHolder.parse(jsonSample);
        Test.stopTest();
        Assert.areEqual(expected[0].userId, testSubject[0].userId, 'Deserealization went wrong');
    }
    
    
}