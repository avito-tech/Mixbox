import MixboxDi
import MixboxBuiltinDi
import MixboxStubbing
import MixboxFoundation
import MixboxTestsFoundation
import MixboxUiTestsFoundation

class BaseGeneratorTestCase: TestCase {
    override var reuseState: Bool {
        false
    }
}
