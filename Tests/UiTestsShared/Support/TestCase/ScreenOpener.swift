protocol ScreenOpener: class {
    func openScreen(
        name: String,
        additionalEnvironment: [String: String]
    )
}

extension ScreenOpener {
    func openScreen(name: String) {
        openScreen(name: name, additionalEnvironment: [:])
    }
    
    @discardableResult
    func openScreen<T: OpenableScreen>(_ screen: T) -> T {
        openScreen(name: screen.viewName)
        
        return screen
    }
}
