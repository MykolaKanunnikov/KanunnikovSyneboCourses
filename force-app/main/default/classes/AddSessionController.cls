public class AddSessionController {

    @AuraEnabled
    public static Response addNewSession(String sessionName, String sessionDateTime){
        Response resp;
        Datetime dt = (DateTime)JSON.deserialize('"' + sessionDateTime + '"', DateTime.class);

        try {
            Session__c s = new Session__c(Name = sessionName, 
                                          Session_Date__c = dt,
                                          Room__c = Id.valueOf('a067Q000007EphuQAC'));
            resp = new Response(s);
            insert s;
        } catch (Exception e) {
            resp = new Response(e);
        }
        return resp;
    }
    
}
