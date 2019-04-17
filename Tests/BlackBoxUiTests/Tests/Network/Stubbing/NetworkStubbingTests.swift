import SwiftyJSON

final class NetworkStubbingTests: BaseNetworkMockingTestCase {
    private let stubbedText = "This is a stubbed string"
    
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
        
        openScreen(name: screen.view)
        
        tapAction()
        
        screen.info.assertHasText(expectedResponse)
    }
}
