import MixboxTestsFoundation

public protocol ResolvedElementQueryLogger {
    func logResolvingElement(
        resolveElement: () -> ResolvedElementQueryLoggerResolvingInfo,
        elementFunctionDeclarationLocation: FunctionDeclarationLocation
    ) -> ResolvedElementQuery
}
