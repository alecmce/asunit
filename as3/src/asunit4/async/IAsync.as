package asunit4.async {

    import flash.events.IEventDispatcher;

    public interface IAsync extends IEventDispatcher {

		function add(handler:Function, duration:int = -1):Function;

		function cancelPending():void;
        
		function get hasPending():Boolean;
        
		function getPending():Array;

		function proceedOnEvent(test:Object, target:IEventDispatcher, eventName:String, timeout:int = 500, timeoutHandler:Function = null):void;
    }
}

