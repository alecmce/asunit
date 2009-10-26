﻿package asunit4.printers
{
	import flash.events.EventDispatcher;
	import flash.net.XMLSocket;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import asunit4.IFreeTestResult;
	import asunit.framework.ITestFailure;
	import flash.utils.getQualifiedClassName;
	import asunit4.ITestSuccess;
	
	public class TracePrinter extends EventDispatcher implements IResultPrinter
	{
		protected static const localPathPattern:RegExp =
			/([A-Z]:\\[^\/:\*\?<>\|]+\.\w{2,6})|(\\{2}[^\/:\*\?<>\|]+\.\w{2,6})/g;
		
		protected static const lineNumberPattern:RegExp = /:[0-9]*\]/;
		
		public function TracePrinter() {
		}
		
		public function startTestRun():void {
		}
		
		public function addTestResult(result:IFreeTestResult):void {
			var failure:ITestFailure;
			
			for each (failure in result.errors) {
				sendMessage(getFailureMessage(failure));
			}
			
			for each (failure in result.failures) {
				sendMessage(getFailureMessage(failure));
			}
			
			// Don't send successes.
		}
		
		public function endTestRun():void {
		}
				
		protected function sendMessage(message:String):void {
			trace(message);
		}
		
		protected function getFailureMessage(failure:ITestFailure):String {
			var status:String = (failure.isFailure) ? 'F' : 'E';
			var stack:String = failure.thrownException.getStackTrace();
			var lines:Array = stack.split('\n');
			var methodPattern:RegExp = new RegExp(failure.failedMethod);
			
			var lineWithMethod:String = '';
			for each (var line:String in lines) {
				if (line.match(methodPattern)) {
					lineWithMethod = line;
					break;
				}
			}
			//trace('\n' + lineWithMethod + '\n');
			
			var filePath:String = String(lineWithMethod.match(localPathPattern)[0]);
			// Find the line number between : and ], e.g. :25].
			var lineNumberRaw:String = lineWithMethod.match(lineNumberPattern)[0];
			// Take off the colon and bracket (I need to get better at regex).
			var lineNumber:String = lineNumberRaw.slice(1, -1);
			
			var message:String = filePath + '('+lineNumber+'): ' + status + ' '
				+ (failure.failedMethod + '(): ' + failure.exceptionMessage);
				
			return message;
		}
	}
}
