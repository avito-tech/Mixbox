public protocol ElementFinder: class {
    func query(
        elementMatcher: ElementMatcher)
        -> ElementQuery
}
