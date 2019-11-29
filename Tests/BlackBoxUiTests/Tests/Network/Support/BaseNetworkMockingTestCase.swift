class BaseNetworkMockingTestCase: TestCase {
    let notStubbedText = "This is NOT a stubbed string"
    
    override var reuseState: Bool {
        return false
    }
    
    var screen: NetworkStubbingTestsViewPageObject {
        return pageObjects.networkStubbingTestsView.default
    }
    
    func assertFailsInRecordingMode(body: () -> ()) {
        assertFails(
            description: """
                Failing test in network recording mode. This is totally fine, expected and will happen every time network is recorded. Once network is recorded, network player switches to replaying mode, so if everything went well, you wouldn't see this failure. Note that this failure prevents you to commit code that is records network.
                """,
            expected: true,
            body: body
        )
    }
}
