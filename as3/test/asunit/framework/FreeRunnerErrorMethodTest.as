package asunit.framework {
	import asunit.framework.TestCase;
	import flash.events.Event;

	public class FreeRunnerErrorMethodTest extends TestCase {
		private var runner:FreeRunner;
		private var freeTest:ErrorInMethodTest;

		public function FreeRunnerErrorMethodTest(testMethod:String = null) {
			super(testMethod);
		}

		protected override function setUp():void {
			runner = new FreeRunner();
			freeTest = new ErrorInMethodTest();
		}

		protected override function tearDown():void {
			runner = null;
		}

		public function testInstantiated():void {
			assertTrue("FreeRunner instantiated", runner is FreeRunner);
		}
		
		//////
		public function test_runTest_triggers_TestResultEvent_with_errors():void {
			runner.addEventListener(TestResultEvent.NAME, addAsync(check_TestResult_has_one_error, 10));
			runner.runTest(freeTest);
		}
		
		private function check_TestResult_has_one_error(e:TestResultEvent):void {
			var result:FreeTestResult = e.testResult;
			assertFalse(result.wasSuccessful);
			
			assertEquals('one error in testResult',   1, result.errorCount);
			assertEquals('no failures in testResult', 0, result.failureCount);
			
			var failure0:FreeTestFailure = result.errors[0] as FreeTestFailure;
			assertTrue('thrownException is correct type', failure0.thrownException is ArgumentError);
			assertSame('failedTest reference', freeTest, failure0.failedTest);
			assertSame('failedMethod name', 'test_throw_ArgumentError', failure0.failedMethod);
		}
		
	}
}
//////////////////////////////////////////
class ErrorInMethodTest {
	
	public function ErrorInMethodTest()	{
	}
	
	public function setUp():void {
	}
	
	public function tearDown():void {
	}
	
	public function test_throw_ArgumentError():void {
		throw new ArgumentError('generated by ErrorInMethodTest');
	}
	
}
