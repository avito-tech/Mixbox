import MixboxUiTestsFoundation
import MixboxTestsFoundation
import TestsIpc

public final class ScrollingSmokeTestsViewPageObject: BasePageObjectWithDefaultInitializer {
    var first: LabelElement {
        return byId(ScrollingSmokeTestsViewConstants.viewIds.elementOrFail(index: 0))
    }
    
    var second: LabelElement {
        return byId(ScrollingSmokeTestsViewConstants.viewIds.elementOrFail(index: 1))
    }
    
    var third: LabelElement {
        return byId(ScrollingSmokeTestsViewConstants.viewIds.elementOrFail(index: 2))
    }
}
