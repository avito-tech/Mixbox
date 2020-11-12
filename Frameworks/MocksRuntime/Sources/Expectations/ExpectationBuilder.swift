import MixboxFoundation

public protocol ExpectationBuilder: class {
    init(
        mockManager: MockManager,
        times: FunctionalMatcher<UInt>,
        fileLine: FileLine)
}
