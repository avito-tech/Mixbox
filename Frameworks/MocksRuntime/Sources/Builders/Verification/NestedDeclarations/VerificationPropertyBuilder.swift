import MixboxFoundation

public class VerificationImmutablePropertyBuilder<PropertyType> {
    public typealias PropertyType = PropertyType
    
    fileprivate let mockManager: MockManager
    fileprivate var variableName: String
    
    public init(
        variableName: String,
        mockManager: MockManager)
    {
        self.mockManager = mockManager
        self.variableName = variableName
    }
    
    public func get(
        file: StaticString = #file,
        line: UInt = #line)
        -> VerificationFunctionBuilder<(), PropertyType>
    {
        return VerificationFunctionBuilder<(), PropertyType>(
            functionIdentifier: FunctionIdentifierFactory.variableFunctionIdentifier(
                variableName: variableName,
                type: .get
            ),
            mockManager: mockManager,
            recordedCallArgumentsMatcher: any(),
            fileLine: FileLine(file: file, line: line)
        )
    }
}

public final class VerificationMutablePropertyBuilder<PropertyType>:
    VerificationImmutablePropertyBuilder<PropertyType>
{
    // TODO: Support detecting closures? Now only `NonEscapingCallArgument.regular` is returned.
    public func set<NewValueMatcher: Matcher>(
        _ newValueMatcher: NewValueMatcher,
        file: StaticString = #file,
        line: UInt = #line)
        -> VerificationFunctionBuilder<PropertyType, ()>
        where
        NewValueMatcher.MatchingType == NonEscapingCallArguments
    {
        let recordedCallArgumentsMatcher = RecordedCallArgumentsMatcherBuilder()
            .matchNext(newValueMatcher)
            .matcher()
        
        return VerificationFunctionBuilder<PropertyType, ()>(
            functionIdentifier: FunctionIdentifierFactory.variableFunctionIdentifier(
                variableName: variableName,
                type: .set
            ),
            mockManager: mockManager,
            recordedCallArgumentsMatcher: recordedCallArgumentsMatcher,
            fileLine: FileLine(file: file, line: line)
        )
    }
}
