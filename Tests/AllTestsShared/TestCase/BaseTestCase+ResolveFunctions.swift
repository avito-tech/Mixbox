import MixboxTestsFoundation
import MixboxUiTestsFoundation
import MixboxIpc
import MixboxUiKit
import MixboxFoundation
import MixboxStubbing

extension BaseTestCase {
    var iosVersionProvider: IosVersionProvider {
        return dependencies.resolve()
    }
    
    var stepLogger: StepLogger {
        return dependencies.resolve()
    }
    
    var dateProvider: DateProvider {
        return dependencies.resolve()
    }
    
    var testFailureRecorder: TestFailureRecorder {
        return dependencies.resolve()
    }
    
    var environmentProvider: EnvironmentProvider {
        return dependencies.resolve()
    }
    
    var generator: GeneratorFacade {
        return dependencies.resolve()
    }
}
