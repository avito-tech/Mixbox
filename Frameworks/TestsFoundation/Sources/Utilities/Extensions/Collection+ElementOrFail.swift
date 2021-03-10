import MixboxFoundation

extension Collection {
    public func elementOrFail(index: Index) -> Iterator.Element {
        guard let element = mb_elementAtIndex(index) else {
            UnavoidableFailure.fail(
                "Failed to get element at index \(index) from the collection of \(count) elements"
            )
        }
        
        return element
    }
}
