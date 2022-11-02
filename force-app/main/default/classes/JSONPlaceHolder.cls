public with sharing class JSONPlaceHolder {
    
    public String userId;
	public String id;
	public String title;
	public String body;

    public JSONPlaceHolder(){}

    public static List<JSONPlaceHolder> parse(String json) {
		return (List<JSONPlaceHolder>) System.JSON.deserialize(json, List<JSONPlaceHolder>.class);
	}

}