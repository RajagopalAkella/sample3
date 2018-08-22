trigger HelloWorldTrigger on Contact (before insert, before update) {
    
    //Sample comment.
    HelloWorldClass.HelloWorld(Trigger.New);
    
}