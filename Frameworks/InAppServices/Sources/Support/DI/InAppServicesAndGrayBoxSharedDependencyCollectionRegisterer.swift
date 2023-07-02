#if MIXBOX_ENABLE_FRAMEWORK_IN_APP_SERVICES && MIXBOX_DISABLE_FRAMEWORK_IN_APP_SERVICES
#error("InAppServices is marked as both enabled and disabled, choose one of the flags")
#elseif MIXBOX_DISABLE_FRAMEWORK_IN_APP_SERVICES || (!MIXBOX_ENABLE_ALL_FRAMEWORKS && !MIXBOX_ENABLE_FRAMEWORK_IN_APP_SERVICES)
// The compilation is disabled
#else

import MixboxDi
import MixboxIpcCommon

public final class InAppServicesAndGrayBoxSharedDependencyCollectionRegisterer: DependencyCollectionRegisterer {
    public init() {
    }
    
    public func register(dependencyRegisterer di: DependencyRegisterer) {
        di.register(type: UIScreen.self) { _ in
            UIScreen.main
        }
        di.register(type: UIApplication.self) { _ in
            UIApplication.shared
        }
        di.register(type: ApplicationWindowsProvider.self) { di in
            try UiApplicationWindowsProvider(
                uiApplication: di.resolve(),
                iosVersionProvider: di.resolve()
            )
        }
        di.register(type: OrderedWindowsProvider.self) { di in
            try OrderedWindowsProviderImpl(
                applicationWindowsProvider: di.resolve()
            )
        }
        di.register(type: ViewInContextDrawer.self) { _ in
            ViewInContextDrawerImpl()
        }
        di.register(type: KeyboardWindowExposer.self) { di in
            try KeyboardWindowExposerImpl(
                keyboardPrivateApi: di.resolve(),
                iosVersionProvider: di.resolve(),
                floatValuesForSr5346Patcher: di.resolve()
            )
        }
        di.register(type: ScreenInContextDrawerWindowPatcher.self) { di in
            try ScreenInContextDrawerWindowPatcherImpl(
                keyboardWindowExposer: di.resolve()
            )
        }
        di.register(type: ScreenInContextDrawer.self) { di in
            try ScreenInContextDrawerImpl(
                orderedWindowsProvider: di.resolve(),
                viewInContextDrawer: di.resolve(),
                screenInContextDrawerWindowPatcher: di.resolve(),
                screen: di.resolve()
            )
        }
        di.register(type: KeyboardPrivateApi.self) { _ in
            try KeyboardPrivateApi.sharedInstance()
        }
        di.register(type: InAppScreenshotTaker.self) { di in
            InAppScreenshotTakerImpl(
                screenInContextDrawer: try di.resolve()
            )
        }
        di.register(type: ViewHierarchyProvider.self) { di in
            try InProcessViewHierarchyProvider(
                applicationWindowsProvider: di.resolve(),
                floatValuesForSr5346Patcher: di.resolve(),
                keyboardWindowExposer: di.resolve()
            )
        }
    }
}

#endif
