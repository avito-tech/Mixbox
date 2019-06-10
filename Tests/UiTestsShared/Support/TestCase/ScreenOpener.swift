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
    
    func openScreen(_ screen: OpenableScreen) {
        openScreen(name: screen.viewName)
    }
}
