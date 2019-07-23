#if MIXBOX_ENABLE_IN_APP_SERVICES

// Zips 2 arrays, pads arrays if they aren't of same length
public func mb_zip<T>(_ a: [T], _ b: [T], pad: T) -> Zip2Sequence<[T], [T]> {
    var a = a
    var b = b
    
    while a.count < b.count {
        a.append(pad)
    }
    while a.count > b.count {
        b.append(pad)
    }
    
    return zip(a, b)
}

extension Collection {
    // Returns element at index or nil if index is out of range
    public func mb_elementAtIndex(_ index: Index) -> Iterator.Element? {
        let intIndex = distance(from: startIndex, to: index)
        
        if intIndex >= 0 && intIndex < count {
            return self[index]
        } else {
            return nil
        }
    }
    
    public var mb_only: Iterator.Element? {
        return count == 1 ? first : nil
    }
    
    // Returns array of "chunks" (arrays of size `chunkSize` or lower for last element.
    // Example: [1, 2, 3].mb_chunked(chunkSize: 2) returns [[1, 2], [3]]
    //
    // Edge cases:
    // - Negative chunkSize is never valid
    // - chunkSize == 0 is not valid for non-empty collection
    // - Empty collection can only be chunked to [], chunkSize == 0 is valid for empty collection.
    // - Empty chunks will never be returned
    //
    // Note: chunkSize is Int, because distance between indicies in Collection is Int.
    //
    public func mb_chunked(chunkSize: Int) throws -> [[Element]] {
        if chunkSize < 0 {
            throw ErrorString("chunkSize should not be negative (chunkSize == \(chunkSize))")
        } else if chunkSize == 0 {
            if count == 0 {
                // Empty collection can be chunked only into zero chunks.
                return []
            } else {
                throw ErrorString("Can not chunk non-empty collection into empty chunks (chunkSize == \(chunkSize))")
            }
        } else {
            return stride(from: 0, to: count, by: chunkSize).map { chunkStartIndex in
                let start: Self.Index = index(startIndex, offsetBy: chunkStartIndex)
                let end: Self.Index = index(startIndex, offsetBy: Swift.min(chunkStartIndex + chunkSize, count))
                
                return Array(self[start ..< end])
            }
        }
    }
}

#endif
