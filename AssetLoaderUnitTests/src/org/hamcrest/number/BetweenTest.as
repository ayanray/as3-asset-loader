package org.hamcrest.number {

    import org.hamcrest.AbstractMatcherTestCase;
    import org.hamcrest.Matcher;

    public class BetweenTest extends AbstractMatcherTestCase {

		[Test]
        public function testBetweenInclusive():void {
            assertMatches("inside range", between(2, 4), 3);
            assertDoesNotMatch("outside range", between(2, 3), 4);
        }

		[Test]
        public function testBetweenExclusive():void {
            assertMatches("inside range", between(2, 4, true), 3);
            assertDoesNotMatch("outside range", between(2, 3, true), 3);
        }

		[Test]
        public function testHasAReadableDescription():void {
            assertDescription("a Number between <2> and <4>", between(2, 4));
            assertDescription("a Number between <2> and <4> exclusive", between(2, 4, true));
        }
    }
}
