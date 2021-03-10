import MixboxTestsFoundation
import MixboxUiTestsFoundation
import MixboxIpc
import MixboxFoundation
import MixboxInAppServices
import MixboxDi

public final class GrayPageObjectDependenciesFactory: BasePageObjectDependenciesFactory {
    public init(
        dependencyResolver: DependencyResolver,
        dependencyInjectionFactory: DependencyInjectionFactory)
    {
        super.init(
            dependencyResolver: dependencyResolver,
            dependencyInjectionFactory: dependencyInjectionFactory,
            registerSpecificDependencies: { di in
                di.register(type: PageObjectElementCoreFactory.self) { di in
                    PageObjectElementCoreFactoryImpl(
                        testFailureRecorder: try di.resolve(),
                        screenshotAttachmentsMaker: try di.resolve(),
                        stepLogger: try di.resolve(),
                        dateProvider: try di.resolve(),
                        elementInteractionDependenciesFactory: { elementSettings in
                            GrayElementInteractionDependenciesFactory(
                                elementSettings: elementSettings,
                                dependencyResolver: WeakDependencyResolver(dependencyResolver: di),
                                dependencyInjectionFactory: dependencyInjectionFactory
                            )
                        },
                        performanceLogger: try di.resolve(),
                        interactionFailureDebugger: try di.resolve()
                    )
                }
            }
        )
    }
}
