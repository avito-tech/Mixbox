public final class WindowForPointProviderImpl: WindowForPointProvider {
    private let orderedWindowsProvider: OrderedWindowsProvider
    
    public init(orderedWindowsProvider: OrderedWindowsProvider) {
        self.orderedWindowsProvider = orderedWindowsProvider
    }
    
    public func window(point: CGPoint) -> UIWindow? {
        return orderedWindowsProvider.windowsFromTopMostToBottomMost().first { (window) -> Bool in
            window.point(inside: point, with: nil)
                && window.hitTest(point, with: nil) != nil
        }
    }
}
