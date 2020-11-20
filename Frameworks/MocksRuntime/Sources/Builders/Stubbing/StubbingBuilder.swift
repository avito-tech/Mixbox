import MixboxFoundation

public protocol StubbingBuilder: class {
    init(mockManager: MockManager, fileLine: FileLine)
}
