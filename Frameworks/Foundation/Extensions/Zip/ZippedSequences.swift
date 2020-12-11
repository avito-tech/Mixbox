#if MIXBOX_ENABLE_IN_APP_SERVICES

// Similar to Swift.Zip2Sequence, but behavior when sequences aren't
// of same length is customizable.
public final class ZippedSequences<FirstSequence: Sequence, SecondSequence: Sequence>: Sequence {
    public typealias UnzipFunction = (FirstSequence.Iterator.Element?, SecondSequence.Iterator.Element?)
        throws
        -> (FirstSequence.Iterator.Element, SecondSequence.Iterator.Element)
    
    private let firstSequence: FirstSequence
    private let secondSequence: SecondSequence
    private let unzipFunction: UnzipFunction
    
    public init(
        firstSequence: FirstSequence,
        secondSequence: SecondSequence,
        unzipFunction: @escaping UnzipFunction)
    {
        self.firstSequence = firstSequence
        self.secondSequence = secondSequence
        self.unzipFunction = unzipFunction
    }
    
    public struct Iterator: IteratorProtocol {
        public typealias Element = ZippedSequencesElement<
            FirstSequence.Iterator.Element,
            SecondSequence.Iterator.Element
        >
        
        private var firstSequenceIterator: FirstSequence.Iterator
        private var secondSequenceIterator: SecondSequence.Iterator
        private let unzipFunction: UnzipFunction
        
        public init(
            firstSequenceIterator: FirstSequence.Iterator,
            secondSequenceIterator: SecondSequence.Iterator,
            unzipFunction: @escaping UnzipFunction)
        {
            self.firstSequenceIterator = firstSequenceIterator
            self.secondSequenceIterator = secondSequenceIterator
            self.unzipFunction = unzipFunction
        }
        
        public mutating func next() -> Element? {
            let first = firstSequenceIterator.next()
            let second = secondSequenceIterator.next()
            
            if first == nil && second == nil {
                return nil
            } else {
                return Element(
                    first: first,
                    second: second,
                    unzipFunction: unzipFunction
                )
            }
        }
    }
    
    public func makeIterator() -> Iterator {
        return Iterator(
            firstSequenceIterator: self.firstSequence.makeIterator(),
            secondSequenceIterator: self.secondSequence.makeIterator(),
            unzipFunction: unzipFunction
        )
    }
}

#endif
