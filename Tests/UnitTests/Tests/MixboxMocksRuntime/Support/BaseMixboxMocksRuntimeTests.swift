import MixboxTestsFoundation
import MixboxMocksRuntime

class BaseMixboxMocksRuntimeTests: TestCase {
    var setUpMocksAutomatically: Bool {
        false
    }
    
    // Remove `RegisterMocksSetUpAction`, this allows to test all cases:
    // whether `RegisterMocksSetUpAction` is used or not (it can be used manually)
    override func setUpActions() -> [SetUpAction] {
        if setUpMocksAutomatically {
            return super.setUpActions()
        } else {
            return super.setUpActions().filter {
                !($0 is RegisterMocksSetUpAction)
            }
        }
    }
}
