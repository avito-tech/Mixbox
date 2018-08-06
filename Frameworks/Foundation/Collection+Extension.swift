// Zips 2 arrays, pads arrays if they aren't of same length
public func zip<T>(_ a: [T], _ b: [T], pad: T) -> Zip2Sequence<[T], [T]> {
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
}
