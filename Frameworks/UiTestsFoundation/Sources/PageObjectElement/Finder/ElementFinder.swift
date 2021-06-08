public protocol ElementFinder: AnyObject {
    func query(
        elementMatcher: ElementMatcher,
        elementFunctionDeclarationLocation: FunctionDeclarationLocation)
        -> ElementQuery
}
