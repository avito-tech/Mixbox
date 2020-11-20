import MixboxFoundation
import MixboxTestsFoundation

public final class StubbingFunctionBuilder<T, U> {
    public typealias Arguments = T
    public typealias ReturnType = U
    
    private let mockManager: MockManager
    private let functionIdentifier: FunctionIdentifier
    private let argumentsMatcher: FunctionalMatcher<Arguments>
    private let fileLine: FileLine
    
    public init(
        functionIdentifier: FunctionIdentifier,
        mockManager: MockManager,
        argumentsMatcher: FunctionalMatcher<Arguments>,
        fileLine: FileLine)
    {
        self.mockManager = mockManager
        self.functionIdentifier = functionIdentifier
        self.argumentsMatcher = argumentsMatcher
        self.fileLine = fileLine
    }
    
    public func thenReturn(_ result: ReturnType) {
        mockManager.stub(
            functionIdentifier: functionIdentifier,
            closure: { _ in result },
            argumentsMatcher: argumentsMatcher.byErasingType()
        )
    }
    
    public func thenInvoke(_ closure: @escaping (Arguments) -> ReturnType) {
        mockManager.stub(
            functionIdentifier: functionIdentifier,
            closure: { [fileLine] any in
                guard let arguments = any as? Arguments else {
                    UnavoidableFailure.fail(
                        "Can not cast \(any) of type \(type(of: any)) to type \(Arguments.self)",
                        file: fileLine.file,
                        line: fileLine.line
                    )
                }
                
                return closure(arguments)
            },
            argumentsMatcher: argumentsMatcher.byErasingType()
        )
    }
}

extension StubbingFunctionBuilder where ReturnType == Void {
    public func thenDoNothing() {
        thenReturn(())
    }
}
