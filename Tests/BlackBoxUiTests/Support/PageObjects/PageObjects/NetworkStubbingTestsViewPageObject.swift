import MixboxUiTestsFoundation

public final class NetworkStubbingTestsViewPageObject: BasePageObjectWithDefaultInitializer {
    var info: LabelElement {
        return byId("info")
    }
    var exampleCom: ButtonElement {
        return byId("example.com")
    }
    var localhost: LabelElement {
        return byId("localhost")
    }
}
