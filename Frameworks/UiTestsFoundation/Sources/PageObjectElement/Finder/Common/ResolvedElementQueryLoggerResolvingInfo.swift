public final class ResolvedElementQueryLoggerResolvingInfo {
    public enum Status {
        // UI elements can be either found or not
        case queryWasPerformed(
            resolvedElementQuery: ResolvedElementQuery,
            provideViewHierarcyDescription: () -> String
        )
        case failedToQueryElements(
            error: String
        )
    }
    
    public let elementFunctionDeclarationLocation: FunctionDeclarationLocation
    public let status: Status
    
    public init(
        status: Status,
        elementFunctionDeclarationLocation: FunctionDeclarationLocation
    ) {
        self.status = status
        self.elementFunctionDeclarationLocation = elementFunctionDeclarationLocation
    }
}
