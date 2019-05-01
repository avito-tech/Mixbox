public final class WindowForPointProviderImpl: WindowForPointProvider {
    private let windowsProvider: WindowsProvider
    
    public init(windowsProvider: WindowsProvider) {
        self.windowsProvider = windowsProvider
    }
    
    public func window(point: CGPoint) -> UIWindow? {
        return windowsProvider.windowsFromTopMostToBottomMost().first { (window) -> Bool in
            return window.point(inside: point, with: nil)
                && window.hitTest(point, with: nil) != nil
        }
    }
}
