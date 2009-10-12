package asunit4.async {
	import asunit.framework.Command;
	import flash.errors.IllegalOperationError;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import asunit.framework.ErrorEvent;
	
	[Event(name="called",	type="flash.events.Event")]
	[Event(name="error",	type="asunit.framework.ErrorEvent")]

	public class TimeoutCommand extends EventDispatcher implements Command {
		public static const CALLED:String = 'called';
		public var scope:Object;
		public var handler:Function; // public for now for testing
		protected var params:Array;
		
		protected var timeout:Timer;
		protected var duration:Number;
		protected var failureHandler:Function;

		public function TimeoutCommand(scope:Object, handler:Function, duration:Number = -1, failureHandler:Function=null){
			this.scope = scope;
			this.handler = handler || function(...args):* {};
			this.duration = duration;
			this.failureHandler = failureHandler;
			
			if (duration < 0) return;
			timeout = new Timer(duration, 1);
			timeout.addEventListener(TimerEvent.TIMER_COMPLETE, onTimeoutComplete);
			timeout.start();
		}
		
		public function execute():* {
			return handler.apply(scope, params);
		}
		
		public function getCallback():Function{
			return callback;
		}
		
		public function cancel():void {
			if (timeout) timeout.stop();
		}
		
		protected function callback(...params):* {
			if (timeout) timeout.stop();
			this.params = params;
			dispatchEvent(new Event(CALLED));
		}
		
		protected function onTimeoutComplete(event:TimerEvent):void {
			sendError(new IllegalOperationError("Timeout (" + duration + "ms) exceeded on an asynchronous operation."));
		}
		
		protected function sendError(error:Error):void {
			var event:ErrorEvent = new ErrorEvent(ErrorEvent.ERROR, error);
			dispatchEvent(event);
			if (failureHandler != null) failureHandler(event);
		}

		override public function toString():String {
			return '[TimeoutCommand scope=' + scope + ']';;
		}
		
	}
}