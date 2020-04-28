import MixboxFoundation
import MixboxTestsFoundation

extension Collection {
    public func getOrFail(index: Index) -> Iterator.Element {
        return mb_elementAtIndex(index).unwrapOrFail()
    }
}
