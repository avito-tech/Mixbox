import MixboxTestsFoundation

public final class StubForFunctionBuilder<T, U> {
    public typealias Arguments = T
    public typealias ReturnType = U
    
    private let mockManager: MockManager
    private var functionId: String
    private let matcher: FunctionalMatcher<Arguments>
    
    public init(functionId: String, mockManager: MockManager, matcher: FunctionalMatcher<Arguments>) {
        self.mockManager = mockManager
        self.functionId = functionId
        self.matcher = matcher
    }
    
    public func thenReturn(_ result: ReturnType) {
        mockManager.addStub(
            functionId: functionId,
            closure: { _ in result },
            matcher: matcher.byErasingType()
        )
    }
    
    public func thenInvoke(_ closure: @escaping (Arguments) -> ReturnType) {
        mockManager.addStub(
            functionId: functionId,
            closure: { any in
                guard let arguments = any as? Arguments else {
                    UnavoidableFailure.fail(
                        "Can not cast \(any) of type \(type(of: any)) to type \(Arguments.self)"
                    )
                }
                
                return closure(arguments)
            },
            matcher: matcher.byErasingType()
        )
    }
}
