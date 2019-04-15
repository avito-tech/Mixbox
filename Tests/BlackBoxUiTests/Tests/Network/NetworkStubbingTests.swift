import SwiftyJSON

final class NetworkStubbingTests: TestCase {
    override var reuseState: Bool {
        return false
    }
    
    var screen: NetworkStubbingTestsViewPageObject {
        return pageObjects.networkStubbingTestsViewPageObject
    }
    
    private let stubbedText = "This is a stubbed string"
    private let notStubbedText = "This is NOT a stubbed string"
    
    func test_networkIsStubbed_ifUrlPatternMatches_anything() {
        checkStubbing(
            urlPattern: ".*",
            tapAction: { screen.localhost.tap() },
            expectedResponse: stubbedText
        )
    }
    
    func test_networkIsStubbed_ifUrlPatternMatches_localhost() {
        checkStubbing(
            urlPattern: "localhost",
            tapAction: { screen.localhost.tap() },
            expectedResponse: stubbedText
        )
    }
    
    func test_networkIsStubbed_ifUrlPatternMatches_exampleCom() {
        checkStubbing(
            urlPattern: "example.com",
            tapAction: { screen.exampleCom.tap() },
            expectedResponse: stubbedText
        )
    }
    
    func test_networkIsNotStubbed_ifUrlPatternMismatches() {
        checkStubbing(
            urlPattern: "example.com",
            tapAction: { screen.localhost.tap() },
            expectedResponse: notStubbedText
        )
    }
    
    private func checkStubbing(
        urlPattern: String,
        tapAction: () -> (),
        expectedResponse: String)
    {
        networking.stubbing
            .stub(urlPattern: urlPattern)
            .thenReturn(string: stubbedText)
        
        openScreen(name: "NetworkStubbingTestsView")
        
        tapAction()
        
        screen.info.assertHasText(expectedResponse)
    }
}
