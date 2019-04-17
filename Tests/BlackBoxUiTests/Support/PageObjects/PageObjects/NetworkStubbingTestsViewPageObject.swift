import MixboxUiTestsFoundation

public final class NetworkStubbingTestsViewPageObject: BasePageObjectWithDefaultInitializer {
    public let view = "NetworkStubbingTestsView"
    
    public var info: LabelElement {
        return byId("info")
    }
    
    public var exampleCom: ButtonElement {
        return byId("example.com")
    }
    
    public var localhost: LabelElement {
        return byId("localhost")
    }
}
