package asunit4.framework {

	import asunit.framework.TestCase;
    import asunit.util.Iterator;

	import asunit4.support.FailAssertTrueTest;

	public class TestIteratorSingleMethodTest extends TestCase {

		private var iterator:Iterator;
		private var singleTest:FailAssertTrueTest;

		public function TestIteratorSingleMethodTest(testMethod:String = null) {
			super(testMethod);
		}

		protected override function setUp():void {
            super.setUp();
			singleTest = new FailAssertTrueTest();
		}

		protected override function tearDown():void {
            super.tearDown();
			iterator   = null;
            singleTest = null;
		}

		public function test_iterator_for_null_yields_hasNext_false():void {
			iterator = new TestIterator(null);
			assertFalse(iterator.hasNext());
		}
		
		public function test_iterator_for_non_test_yields_hasNext_false():void {
			iterator = new TestIterator(new Date());
			assertFalse(iterator.hasNext());
		}
		
		public function test_iterator_for_test_with_one_test_method_hasNext():void {
			iterator = new TestIterator(singleTest);
			assertTrue(iterator.hasNext());
		}
		
		public function test_iterator_next():void {
			iterator = new TestIterator(singleTest);
			
			assertEquals('runBefore', 		iterator.next().toString());
			assertEquals('fail_assertTrue',	iterator.next().toString());
			assertEquals('runAfter',		iterator.next().toString());
			
			assertFalse('no methods left in iterator', iterator.hasNext());
		}
	}
}

