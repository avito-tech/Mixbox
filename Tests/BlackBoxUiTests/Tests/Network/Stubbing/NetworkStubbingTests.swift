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
    
    func test___requests_are_stubbed_in_correct_order() {
        openScreen(screen)
        
        networking.stubbing
            .stub(urlPattern: "localhost")
            .thenReturn(string: "1")
        
        screen.localhost.tap()
        screen.info.assertHasText("1")
        
        networking.stubbing
            .stub(urlPattern: "localho")
            .thenReturn(string: "2")
        
        screen.localhost.tap()
        screen.info.assertHasText("2")
        
        networking.stubbing
            .stub(urlPattern: ".*")
            .thenReturn(string: "3")
        
        screen.localhost.tap()
        screen.info.assertHasText("3")
        
        networking.stubbing
            .stub(urlPattern: "localho")
            .thenReturn(string: "4")
        
        screen.localhost.tap()
        screen.info.assertHasText("4")
        
        networking.stubbing
            .stub(urlPattern: "localho")
            .thenReturn(string: "5")
        
        screen.localhost.tap()
        screen.info.assertHasText("5")
    }
    
    private func checkStubbing(
        urlPattern: String,
        tapAction: () -> (),
        expectedResponse: String)
    {
        networking.stubbing
            .stub(urlPattern: urlPattern)
            .thenReturn(string: stubbedText)
        
        openScreen(screen)
        
        tapAction()
        
        screen.info.assertHasText(expectedResponse)
    }
}
