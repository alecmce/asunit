package asunit4.framework {

	import asunit.framework.TestCase;
    import asunit.util.Iterator;

	import asunit4.support.DoubleFailSuite;
	import asunit4.support.FailAssertEqualsTest;
	import asunit4.support.FailAssertTrueTest;

	public class SuiteIteratorTest extends TestCase {

		public function SuiteIteratorTest(testMethod:String = null) {
			super(testMethod);
		}

		public function test_countTestClasses_of_suite_class():void {
            var iterator:Iterator = new SuiteIterator(DoubleFailSuite);
			assertEquals(2, iterator.length);
		}
		
		public function test_accepts_non_suite_class():void {
            var iterator:Iterator = new SuiteIterator(Date);
			assertEquals(0, iterator.length);
		}
		
		public function test_accepts_test_class():void {
            var iterator:Iterator = new SuiteIterator(FailAssertEqualsTest);
			assertEquals(1, iterator.length);
		}
		
		public function test_getTestClasses_of_suite_class():void {
            var iterator:Iterator = new SuiteIterator(DoubleFailSuite);
			
			assertEquals(2, iterator.length);
			// In case the ordering is random, check that the array contains the class somewhere.
            assertSame(FailAssertEqualsTest, iterator.next());
            assertSame(FailAssertTrueTest, iterator.next());
		}
		
		public function test_getTestClasses_on_test_class_should_return_array_with_test():void {
            var iterator:Iterator = new SuiteIterator(FailAssertTrueTest);
			
			assertEquals(1, iterator.length);
			assertSame(FailAssertTrueTest, iterator.next());
		}
		
		public function test_iterator_for_non_suite_class_yields_hasNext_false():void {
			var iterator:Iterator = new SuiteIterator(Date);
			assertFalse(iterator.hasNext());
		}
		
		public function test_iterator_for_suite_class_with_2_tests_hasNext():void {
			var iterator:Iterator = new SuiteIterator(DoubleFailSuite);
			assertTrue(iterator.hasNext());
		}
		
		public function test_iterator_next():void {
			var iterator:Iterator = new SuiteIterator(DoubleFailSuite);
			
			assertSame(FailAssertEqualsTest,	iterator.next());
			assertSame(FailAssertTrueTest, 		iterator.next());
			
			assertFalse('no methods left in iterator', iterator.hasNext());
		}
	}
}

