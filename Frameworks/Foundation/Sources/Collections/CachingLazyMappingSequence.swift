#if MIXBOX_ENABLE_FRAMEWORK_FOUNDATION && MIXBOX_DISABLE_FRAMEWORK_FOUNDATION
#error("Foundation is marked as both enabled and disabled, choose one of the flags")
#elseif MIXBOX_DISABLE_FRAMEWORK_FOUNDATION || (!MIXBOX_ENABLE_ALL_FRAMEWORKS && !MIXBOX_ENABLE_FRAMEWORK_FOUNDATION)
// The compilation is disabled
#else

public final class CachingLazyMappingSequence<SourceElement, TransformedElement>: Sequence {
    public let sourceElements: [SourceElement]
    private let transform: (SourceElement) -> TransformedElement
    private let mappedElementsCache = MappedElementsCache<TransformedElement>()
    
    public init(
        sourceElements: [SourceElement],
        transform: @escaping (SourceElement) -> TransformedElement
    ) {
        self.sourceElements = sourceElements
        self.transform = transform
    }
    
    public func makeIterator() -> IteratorOf<TransformedElement> {
        return IteratorOf( // Iterator is wrapped to not expose unsafe APIs (note `preconditionFailure`s in this class)
            LazyMappingSequenceIterator<SourceElement, TransformedElement>(
                sourceElements: sourceElements,
                transform: transform,
                mappedElementsCache: mappedElementsCache,
                index: 0
            )
        )
    }
    
    public var isEmpty: Bool {
        return sourceElements.isEmpty
    }
    
    public var mappedElements: [TransformedElement] {
        mappedElementsCache.mappedElements
    }
    
    public var allElements: [TransformedElement] {
        if sourceElements.count == mappedElements.count {
            return mappedElements
        } else {
            let iterator = LazyMappingSequenceIterator<SourceElement, TransformedElement>(
                sourceElements: sourceElements,
                transform: transform,
                mappedElementsCache: mappedElementsCache,
                index: mappedElements.count
            )
            
            while iterator.next() != nil {}
            
            if sourceElements.count == mappedElements.count {
                return mappedElements
            } else {
                preconditionFailure(
                    """
                    Expected to map all elements. Source elements count: \(sourceElements.count). Mapped elements count: \(mappedElements.count)
                    """
                )
            }
        }
    }
}

private final class MappedElementsCache<TransformedElement> {
    var mappedElements: [TransformedElement] = []
}

private final class LazyMappingSequenceIterator<SourceElement, TransformedElement>: IteratorProtocol {
    private let sourceElements: [SourceElement]
    private let transform: (SourceElement) -> TransformedElement
    private let mappedElementsCache: MappedElementsCache<TransformedElement>
    private var index: Int

    init(
        sourceElements: [SourceElement],
        transform: @escaping (SourceElement) -> TransformedElement,
        mappedElementsCache: MappedElementsCache<TransformedElement>,
        index: Int
    ) {
        self.sourceElements = sourceElements
        self.transform = transform
        self.mappedElementsCache = mappedElementsCache
        self.index = index
    }

    func next() -> TransformedElement? {
        if index < sourceElements.count {
            if index < mappedElementsCache.mappedElements.count {
                index += 1
                return mappedElementsCache.mappedElements[index]
            } else if index == mappedElementsCache.mappedElements.count {
                let sourceElement = sourceElements[index]
                let transformedElement = transform(sourceElement)
                
                mappedElementsCache.mappedElements.append(transformedElement)
                
                index += 1
                return transformedElement
            } else {
                preconditionFailure(
                    """
                    Accessed element at index \(index) before ever accessing previous element. This represents a bug in CachingLazyMappingSequence.
                    Latest accessed element index: \(mappedElementsCache.mappedElements.count - 1).
                    """
                )
            }
        } else {
            return nil
        }
    }
}

#endif
