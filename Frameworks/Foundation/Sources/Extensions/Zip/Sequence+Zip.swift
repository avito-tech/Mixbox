#if MIXBOX_ENABLE_IN_APP_SERVICES

extension Sequence {
    // Unlike `Swift.zip` this function throws when elements are unzipped
    // if sequences aren't of same length.
    public func mb_zip<Other: Sequence>(
        sequenceOfSameLength other: Other)
        -> ZippedSequences<Self, Other>
    {
        return ZippedSequences(
            firstSequence: self,
            secondSequence: other,
            unzipFunction: { (first, second) in
                guard let first = first, let second = second else {
                    throw ErrorString(
                        """
                        Zipped sequences aren't of same length
                        """
                    )
                }
                
                return (first, second)
            }
        )
    }
}

#endif
