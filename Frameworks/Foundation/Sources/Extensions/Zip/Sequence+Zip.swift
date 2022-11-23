#if MIXBOX_ENABLE_FRAMEWORK_FOUNDATION && MIXBOX_DISABLE_FRAMEWORK_FOUNDATION
#error("Foundation is marked as both enabled and disabled, choose one of the flags")
#elseif MIXBOX_DISABLE_FRAMEWORK_FOUNDATION || (!MIXBOX_ENABLE_ALL_FRAMEWORKS && !MIXBOX_ENABLE_FRAMEWORK_FOUNDATION)
// The compilation is disabled
#else

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
