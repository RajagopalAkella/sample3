public class HelloWorldClass {
	
	//Sample comment
	public static void HelloWorld(List<Contact> contacts) {
		for (Contact c : contacts) {
			c.Hello__c = 'World';
		}
	}

}