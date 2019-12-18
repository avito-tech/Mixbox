public protocol ElementFinder: class {
    func query(
        elementMatcher: ElementMatcher,
        elementFunctionDeclarationLocation: FunctionDeclarationLocation)
        -> ElementQuery
}
