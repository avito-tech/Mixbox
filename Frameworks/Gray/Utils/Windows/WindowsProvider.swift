public protocol WindowsProvider {
    func windowsFromTopMostToBottomMost() -> [UIWindow]
    func windowsFromBottomMostToTopMost() -> [UIWindow]
}

extension WindowsProvider {
    public func windowsFromTopMostToBottomMost() -> [UIWindow] {
        return windowsFromBottomMostToTopMost().reversed()
    }
}

public final class WindowsProviderImpl: WindowsProvider {
    private let application: UIApplication
    private let shouldIncludeStatusBarWindow: Bool // TODO: It seems that it never works.
    
    public init(
        application: UIApplication,
        shouldIncludeStatusBarWindow: Bool)
    {
        self.application = application
        self.shouldIncludeStatusBarWindow = shouldIncludeStatusBarWindow
    }
    
    public func windowsFromBottomMostToTopMost() -> [UIWindow] {
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

private class OrderedWindow: Hashable {
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
