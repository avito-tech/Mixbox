final class CallToSuperInPreconditionOfBaseUiTestCaseValidationTests: TestCase {
    override func precondition() {
        // call to super is missed
    }
    
    override func setUp() {
        assertFails(
            description:
            """
            You must call super.precondition() from your subclass of BaseUiTestCase (CallToSuperInPreconditionOfBaseUiTestCaseValidationTests)
            """,
            body: {
                super.setUp()
            }
        )
    }
    
    func test() {
        // no test body is needed for this test case
    }
}
