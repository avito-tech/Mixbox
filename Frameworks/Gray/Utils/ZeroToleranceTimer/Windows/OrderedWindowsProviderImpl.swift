import MixboxUiKit
import MixboxInAppServices
import UIKit
import Foundation

// Translated to Swift.
// Original implementation: https://github.com/google/EarlGrey/blob/87ffa7ac2517cc8931e4e6ba11714961cbac6dd7/EarlGrey/Provider/GREYUIWindowProvider.m
//
public final class OrderedWindowsProviderImpl: OrderedWindowsProvider {
    private let applicationWindowsProvider: ApplicationWindowsProvider
    private let iosVersionProvider: IosVersionProvider
    
    public init(
        applicationWindowsProvider: ApplicationWindowsProvider,
        iosVersionProvider: IosVersionProvider)
    {
        self.applicationWindowsProvider = applicationWindowsProvider
        self.iosVersionProvider = iosVersionProvider
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
