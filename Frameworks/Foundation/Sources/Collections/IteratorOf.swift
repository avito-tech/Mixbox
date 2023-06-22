#if MIXBOX_ENABLE_FRAMEWORK_FOUNDATION && MIXBOX_DISABLE_FRAMEWORK_FOUNDATION
#error("Foundation is marked as both enabled and disabled, choose one of the flags")
#elseif MIXBOX_DISABLE_FRAMEWORK_FOUNDATION || (!MIXBOX_ENABLE_ALL_FRAMEWORKS && !MIXBOX_ENABLE_FRAMEWORK_FOUNDATION)
// The compilation is disabled
#else

public final class IteratorOf<Element>: IteratorProtocol {
    private let nextClosure: () -> Element?
    
    public init(next: @escaping () -> Element?) {
        self.nextClosure = next
    }
    
    public convenience init<Other: IteratorProtocol>(_ other: Other) where Other.Element == Element {
        var other = other
        self.init(
            next: {
                other.next()
            }
        )
    }
    
    public func next() -> Element? {
        nextClosure()
    }
}

#endif
