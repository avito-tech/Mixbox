import MixboxUiTestsFoundation
import MixboxTestsFoundation
import MixboxFoundation
import MixboxInAppServices
import MixboxDi

public final class GrayElementInteractionDependenciesFactory: BaseElementInteractionDependenciesFactory {
    override public init(
        dependencyResolver: DependencyResolver,
        dependencyInjectionFactory: DependencyInjectionFactory)
    {
        super.init(
            dependencyResolver: dependencyResolver,
            dependencyInjectionFactory: dependencyInjectionFactory
        )
    }
    
    override public func registerSpecificDependencies(di: DependencyRegisterer, fileLine: FileLine) {
        // TODO: Remove? Duplicates code from `IpcClientsDependencyCollectionRegisterer`
        di.register(type: Pasteboard.self) { _ in
            UikitPasteboard(uiPasteboard: .general)
        }
    }
}
