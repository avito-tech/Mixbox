import MixboxIpcCommon

public protocol ScrollingHintsProvider: class {
    func scrollingHint(element: ElementSnapshot) -> ScrollingHint
}
