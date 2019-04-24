import MixboxUiTestsFoundation

public final class GrayApplicationFrameProvider: ApplicationFrameProvider {
    public var frame: CGRect {
        return UIScreen.main.bounds // FIXME
    }
}
