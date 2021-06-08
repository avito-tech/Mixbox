import MixboxIpcCommon

public protocol ScrollingHintsProvider: AnyObject {
    func scrollingHint(element: ElementSnapshot) -> ScrollingHint
}
