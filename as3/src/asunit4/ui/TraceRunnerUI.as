﻿package asunit4.ui {
	import flash.display.MovieClip;
	import asunit4.runners.BaseRunner;
	import asunit4.printers.TracePrinter;
	import flash.events.Event;
	import flash.system.fscommand;
	import flash.system.System;
	
	public class TraceRunnerUI extends MovieClip {
		
		protected var runner:BaseRunner;
		
		public function TraceRunnerUI() {
			runner = new BaseRunner(new TracePrinter());
			runner.addEventListener(Event.COMPLETE, onRunnerComplete);
		}
		
		public function start(suite:Class):void {
			runner.start(suite);
		}
		
		protected function onRunnerComplete(e:Event):void {
			fscommand('quit'); // fails silently if not in debug player
			//System.exit(0); // generates SecurityError if not in debug player
		}
	}
}
