public protocol ElementFinder {
    func query(
        elementMatcher: ElementMatcher)
        -> ElementQuery
}
