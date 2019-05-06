import MixboxUiTestsFoundation

public final class GrayApplicationFrameProvider: ApplicationFrameProvider {
    public var applicationFrame: CGRect {
        return UIScreen.main.bounds // TODO: Proper code! Write tests!
    }
}
