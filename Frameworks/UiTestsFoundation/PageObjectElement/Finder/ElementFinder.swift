public protocol ElementFinder {
    func query(
        elementMatcher: ElementMatcher,
        waitForExistence: Bool)
        -> ElementQuery
}
