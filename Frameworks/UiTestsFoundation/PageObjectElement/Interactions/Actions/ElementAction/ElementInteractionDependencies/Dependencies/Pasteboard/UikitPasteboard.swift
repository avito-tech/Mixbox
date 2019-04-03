public final class UikitPasteboard: Pasteboard {
    public init() {
    }
    
    public var string: String? {
        get {
            return UIPasteboard.general.string
        }
        set {
            UIPasteboard.general.string = newValue
        }
    }
}
