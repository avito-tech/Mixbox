import MixboxUiTestsFoundation
import TestsIpc

public final class ScrollingSmokeTestsViewPageObject: BasePageObjectWithDefaultInitializer {
    var first: LabelElement {
        return byId(ScrollingSmokeTestsViewConstants.viewIds.getOrFail(index: 0))
    }
    
    var second: LabelElement {
        return byId(ScrollingSmokeTestsViewConstants.viewIds.getOrFail(index: 1))
    }
    
    var third: LabelElement {
        return byId(ScrollingSmokeTestsViewConstants.viewIds.getOrFail(index: 2))
    }
}
