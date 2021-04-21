import MixboxUiTestsFoundation
import MixboxTestsFoundation
import MixboxFoundation
import MixboxDi

public final class XcuiElementInteractionDependenciesFactory: BaseElementInteractionDependenciesFactory {
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
            XcuiElementHierarchyDescriptionProvider(
                applicationProvider: try di.resolve()
            )
        }
        di.register(type: TextTyper.self) { di in
            XcuiTextTyper(
                applicationProvider: try di.resolve()
            )
        }
        di.register(type: MenuItemProvider.self) { di in
            XcuiMenuItemProvider(
                applicationProvider: try di.resolve()
            )
        }
        di.register(type: ElementSimpleGesturesProvider.self) { di in
            XcuiElementSimpleGesturesProvider(
                applicationProvider: try di.resolve(),
                applicationFrameProvider: try di.resolve(),
                applicationCoordinatesProvider: try di.resolve()
            )
        }
        di.register(type: EventGenerator.self) { di in
            XcuiEventGenerator(
                applicationProvider: try di.resolve()
            )
        }
        di.register(type: ApplicationStateProvider.self) { di in
            XcuiApplicationStateProvider(
                applicationProvider: try di.resolve()
            )
        }
    }
}
