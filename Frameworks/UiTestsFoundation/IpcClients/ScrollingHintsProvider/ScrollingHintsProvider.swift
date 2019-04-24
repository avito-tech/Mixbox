import MixboxIpcCommon

public protocol ScrollingHintsProvider {
    func scrollingHint(element: ElementSnapshot) -> ScrollingHint
}
