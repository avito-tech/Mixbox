public protocol WindowsProvider: class {
    func windowsFromTopMostToBottomMost() -> [UIWindow]
    func windowsFromBottomMostToTopMost() -> [UIWindow]
}

extension WindowsProvider {
    public func windowsFromTopMostToBottomMost() -> [UIWindow] {
        return windowsFromBottomMostToTopMost().reversed()
    }
}
