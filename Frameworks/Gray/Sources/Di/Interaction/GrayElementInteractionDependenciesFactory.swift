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
        di.register(type: ElementHierarchyDescriptionProvider.self) { di in
            GrayElementHierarchyDescriptionProvider(
                viewHierarchyProvider: ViewHierarchyProviderImpl(
                    applicationWindowsProvider: try di.resolve(),
                    floatValuesForSr5346Patcher: NoopFloatValuesForSr5346Patcher(),
                    keyboardPrivateApi: try di.resolve()
                )
            )
        }
        di.register(type: TextTyper.self) { di in
            try GrayTextTyper(
                keyboardPrivateApi: di.resolve()
            )
        }
        di.register(type: MenuItemProvider.self) { di in
            GrayMenuItemProvider(
                elementMatcherBuilder: try di.resolve(),
                elementFinder: try di.resolve(),
                elementSimpleGesturesProvider: try di.resolve(),
                runLoopSpinnerFactory: try di.resolve()
            )
        }
        di.register(type: Pasteboard.self) { _ in
            UikitPasteboard(uiPasteboard: .general)
        }
    }
}
