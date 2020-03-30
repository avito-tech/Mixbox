import TestsIpc

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
    func open<T: OpenableScreen>(
        screen: T)
        -> T
    {
        openScreen(name: screen.viewName)
        
        return screen
    }
}
