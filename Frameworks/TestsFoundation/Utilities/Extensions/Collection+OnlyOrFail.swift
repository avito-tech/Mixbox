// swiftlint:disable large_tuple
public extension Collection {
    var onlyOneOrFail: Iterator.Element {
        return onlyOrFail()
    }
    
    func onlyOrFail() -> Iterator.Element {
        return onlyOrFail(
            count: 1,
            getter: at(0)
        )
    }
    
    func onlyOrFail() -> (Iterator.Element, Iterator.Element) {
        return onlyOrFail(
            count: 2,
            getter: (at(0), at(1))
        )
    }
    
    func onlyOrFail() -> (Iterator.Element, Iterator.Element, Iterator.Element) {
        return onlyOrFail(
            count: 3,
            getter: (at(0), at(1), at(2))
        )
    }
    
    func onlyOrFail() -> (Iterator.Element, Iterator.Element, Iterator.Element, Iterator.Element) {
        return onlyOrFail(
            count: 4,
            getter: (at(0), at(1), at(2), at(3))
        )
    }
    
    func onlyOrFail() -> (Iterator.Element, Iterator.Element, Iterator.Element, Iterator.Element, Iterator.Element) {
        return onlyOrFail(
            count: 5,
            getter: (at(0), at(1), at(2), at(3), at(4))
        )
    }
    
    func onlyOrFail() -> (Iterator.Element, Iterator.Element, Iterator.Element, Iterator.Element, Iterator.Element, Iterator.Element) {
        return onlyOrFail(
            count: 6,
            getter: (at(0), at(1), at(2), at(3), at(4), at(5))
        )
    }
    
    private func at(_ index: Int) -> Iterator.Element {
        return self[self.index(startIndex, offsetBy: index)]
    }
    
    private func onlyOrFail<T>(
        count: Int,
        getter: @autoclosure () -> T)
        -> T
    {
        if self.count != count {
            UnavoidableFailure.fail(
                "Failed to get exactly \(count) elements from the collection, actual count: \(count)"
            )
        } else {
            return getter()
        }
    }
    
    private func fail(count: Int) {
        UnavoidableFailure.fail(
            "Failed to get exactly \(count) elements from the collection, actual count: \(count)"
        )
    }
}
