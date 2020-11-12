import MixboxTestsFoundation

public final class StubForFunctionBuilder<Args, ReturnType> {
    private let mockManager: MockManager
    private var functionId: String
    private let matcher: FunctionalMatcher<Args>
    
    public init(functionId: String, mockManager: MockManager, matcher: FunctionalMatcher<Args>) {
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
    
    public func thenInvoke(_ closure: @escaping (Args) -> ReturnType) {
        mockManager.addStub(
            functionId: functionId,
            closure: { any in
                guard let args = any as? Args else {
                    UnavoidableFailure.fail("Can not cast \(any) of type \(type(of: any)) to type \(Args.self)")
                }
                
                return closure(args)
            },
            matcher: matcher.byErasingType()
        )
    }
}
