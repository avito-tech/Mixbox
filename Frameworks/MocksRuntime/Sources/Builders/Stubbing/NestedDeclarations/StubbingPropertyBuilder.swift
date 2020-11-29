import MixboxFoundation

public class StubbingImmutablePropertyBuilder<PropertyType> {
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
        -> StubbingFunctionBuilder<(), PropertyType>
    {
        return StubbingFunctionBuilder(
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

public final class StubbingMutablePropertyBuilder<PropertyType>:
    StubbingImmutablePropertyBuilder<PropertyType>
{
    public func set<NewValueMatcher: Matcher>(
        _ newValueMatcher: NewValueMatcher,
        file: StaticString = #file,
        line: UInt = #line)
        -> StubbingFunctionBuilder<PropertyType, ()>
        where
        NewValueMatcher.MatchingType == PropertyType
    {
        let recordedCallArgumentsMatcher = RecordedCallArgumentsMatcher(
            matchingFunction: { (other: RecordedCallArguments) -> Bool in
                guard let other: PropertyType = Self.unwrapNewValue(recordedCallArguments: other) else {
                    return false
                }
                
                return newValueMatcher.valueIsMatching(other)
            }
        )
        
        return StubbingFunctionBuilder(
            functionIdentifier: FunctionIdentifierFactory.variableFunctionIdentifier(
                variableName: variableName,
                type: .set
            ),
            mockManager: mockManager,
            recordedCallArgumentsMatcher: recordedCallArgumentsMatcher,
            fileLine: FileLine(file: file, line: line)
        )
    }
    
    private static func unwrapNewValue<PropertyType>(recordedCallArguments: RecordedCallArguments) -> PropertyType? {
        // Setters can have only 1 argument.
        return recordedCallArguments.arguments.mb_only?.typedNestedValue()
    }
}
