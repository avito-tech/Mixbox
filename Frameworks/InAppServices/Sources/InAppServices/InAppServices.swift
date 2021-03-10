#if MIXBOX_ENABLE_IN_APP_SERVICES

/// Facade for starting everything for tests, on the side of the app.
///
/// Functionality:
///
/// - `start()`
///
///     Starts everything up: IPC (inter-process communication), hacking AX (accessibility), etc.
///     Note that nothing is done unless you call this method. Mixbox doesn't have side effects like
///     executing code when framework is loaded. But it will have some if you call it. For example,
///     the visibility check calls `setNeedsLayout` for a checked view, there is some swizzling too, etc.
///
/// - `register(closure:)` from `IpcMethodHandlerWithDependenciesRegisterer`:
///
///     Adds custom IpcMethodHandler that can be used to perform some
///     action inside an application from tests or retrieve some information.
///
///     Example from a real app: measure FPS fro performance tests and get metrics:
///
///     ```
///     mixboxInAppServices.register { _ in
///         AppFpsMeasurementStartIpcMethodHandler(
///             appFpsMeasurer: appFpsMeasurer
///         )
///     }
///     ```
///
/// - `set(uiEventObservable:)` from `UiEventObservableSetter`:
///
///     Sets `UiEventObservable` which can be `UiEventObservingWindow` or your custom implementation.
///
///     It will enable the following features:
///
///     - TouchDrawer: displays touches, useful for debugging tests
///     - UiEventHistoryTracker: tracks UI touches, which can be retrieved later in tests via IPC
///
public protocol InAppServices: IpcMethodHandlerWithDependenciesRegisterer, UiEventObservableSetter {
    func start() -> StartedInAppServices
}

#endif
