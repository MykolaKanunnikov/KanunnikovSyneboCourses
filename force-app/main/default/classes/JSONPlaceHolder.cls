public with sharing class JSONPlaceHolder {
    
    public String userId;
	public String id;
	public String title;
	public String body;

	public JSONPlaceHolder(String userId, String id, String title, String body){
		this.userId = userId;
		this.id = id;
		this.title = title;
		this.body = body;
	}

    public static List<JSONPlaceHolder> parse(String json) {
		return (List<JSONPlaceHolder>) System.JSON.deserialize(json, List<JSONPlaceHolder>.class);
	}

}