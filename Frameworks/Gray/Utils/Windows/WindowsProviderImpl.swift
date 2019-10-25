import MixboxUiKit

// Translated to Swift.
// Original implementation: https://github.com/google/EarlGrey/blob/87ffa7ac2517cc8931e4e6ba11714961cbac6dd7/EarlGrey/Provider/GREYUIWindowProvider.m
//
public final class WindowsProviderImpl: WindowsProvider {
    private let application: UIApplication
    private let iosVersionProvider: IosVersionProvider
    
    public init(
        application: UIApplication,
        iosVersionProvider: IosVersionProvider)
    {
        self.application = application
        self.iosVersionProvider = iosVersionProvider
    }
    
    public func windowsFromBottomMostToTopMost() -> [UIWindow] {
        let shouldIncludeStatusBarWindow = iosVersionProvider.iosVersion().majorVersion < 13
        
        var windows = Set<OrderedWindow>(
            application.windows.enumerated().map {
                OrderedWindow(order: $0.offset, window: $0.element)
            }
        )
        
        if let window = application.delegate?.window ?? nil {
            // Is it possible that application.windows doesn't contain this window?
            windows.insert(OrderedWindow(order: windows.count, window: window))
        }
        
        if let window = application.keyWindow {
            // Is it possible that application.windows doesn't contain this window?
            windows.insert(OrderedWindow(order: windows.count, window: window))
        }
        
        if shouldIncludeStatusBarWindow, let window = application.statusBarWindow() {
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
