import MixboxFoundation
import MixboxTestsFoundation
import MixboxIpcCommon
import MixboxDi

public final class ElementInteractionDependenciesImpl: ElementInteractionDependencies {
    public let di: TestFailingDependencyResolver
    
    public init(
        dependencyResolver: TestFailingDependencyResolver)
    {
        self.di = dependencyResolver
    }
}
