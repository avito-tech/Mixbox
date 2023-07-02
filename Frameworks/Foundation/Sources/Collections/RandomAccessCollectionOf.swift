#if MIXBOX_ENABLE_FRAMEWORK_FOUNDATION && MIXBOX_DISABLE_FRAMEWORK_FOUNDATION
#error("Foundation is marked as both enabled and disabled, choose one of the flags")
#elseif MIXBOX_DISABLE_FRAMEWORK_FOUNDATION || (!MIXBOX_ENABLE_ALL_FRAMEWORKS && !MIXBOX_ENABLE_FRAMEWORK_FOUNDATION)
// The compilation is disabled
#else

public struct RandomAccessCollectionOf<ElementType, IndexType: Comparable>: RandomAccessCollection {
    public typealias Index = IndexType
    public typealias Element = ElementType
    
    private let _startIndex: () -> Index
    private let _endIndex: () -> Index
    private let _subscript: (Index) -> Element
    private let _index_before: (Index) -> Index
    private let _index_after: (Index) -> Index

    public init<Other: RandomAccessCollection>(_ other: Other) where Other.Element == Element, Other.Index == Index {
        _startIndex = { other.startIndex }
        _endIndex = { other.endIndex }
        _subscript = { other[$0] }
        _index_before = { other.index(before: $0) }
        _index_after = { other.index(after: $0) }
    }
    
    public var startIndex: Index {
        _startIndex()
    }
    
    public var endIndex: Index {
        _endIndex()
    }
    
    public subscript(position: Index) -> Element {
        get {
            _subscript(position)
        }
    }
    
    public func index(before i: Index) -> Index {
        _index_before(i)
    }
    
    public func index(after i: Index) -> Index {
        _index_after(i)
    }
}

#endif
