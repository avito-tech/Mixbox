#if MIXBOX_ENABLE_FRAMEWORK_IN_APP_SERVICES && MIXBOX_DISABLE_FRAMEWORK_IN_APP_SERVICES
#error("InAppServices is marked as both enabled and disabled, choose one of the flags")
#elseif MIXBOX_DISABLE_FRAMEWORK_IN_APP_SERVICES || (!MIXBOX_ENABLE_ALL_FRAMEWORKS && !MIXBOX_ENABLE_FRAMEWORK_IN_APP_SERVICES)
// The compilation is disabled
#else

import MixboxUiKit

// Translated to Swift.
// Original implementation: https://github.com/google/EarlGrey/blob/87ffa7ac2517cc8931e4e6ba11714961cbac6dd7/EarlGrey/Provider/GREYUIWindowProvider.m
//
public final class OrderedWindowsProviderImpl: OrderedWindowsProvider {
    private let applicationWindowsProvider: ApplicationWindowsProvider
    
    public init(
        applicationWindowsProvider: ApplicationWindowsProvider)
    {
        self.applicationWindowsProvider = applicationWindowsProvider
    }
    
    public func windowsFromBottomMostToTopMost() -> [UIWindow] {
        var windows = Set<OrderedWindow>(
            applicationWindowsProvider.windows.enumerated().map {
                OrderedWindow(order: $0.offset, window: $0.element)
            }
        )
        
        if let window = applicationWindowsProvider.applicationDelegateWindow ?? nil {
            // Is it possible that application.windows doesn't contain this window?
            windows.insert(OrderedWindow(order: windows.count, window: window))
        }
        
        if let window = applicationWindowsProvider.keyWindow {
            // Is it possible that application.windows doesn't contain this window?
            windows.insert(OrderedWindow(order: windows.count, window: window))
        }
        
        if let window = applicationWindowsProvider.statusBarWindow {
            windows.insert(OrderedWindow(order: windows.count, window: window))
        }
        
        return windows.sorted(by: <).map { $0.window }
    }
}

private class OrderedWindow: Hashable, Comparable {
    static func ==(l: OrderedWindow, r: OrderedWindow) -> Bool {
        return l.window === r.window
    }
    
    let order: Int
    let window: UIWindow
    
    init(order: Int, window: UIWindow) {
        self.order = order
        self.window = window
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(ObjectIdentifier(window))
    }
    
    static func <(l: OrderedWindow, r: OrderedWindow) -> Bool {
        if l.window.windowLevel == r.window.windowLevel {
            return l.order < r.order
        } else {
            return l.window.windowLevel < r.window.windowLevel
        }
    }
}

#endif
