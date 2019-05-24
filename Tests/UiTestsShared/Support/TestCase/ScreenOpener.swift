protocol ScreenOpener {
    func openScreen(name: String)
}

extension ScreenOpener {
    func openScreen(_ screen: OpenableScreen) {
        openScreen(name: screen.viewName)
    }
}
