import MixboxUiKit
import MixboxFoundation
import TestsIpc

// We have few tests that check accesibility initialization via private API
// (for example, `UIViewTestabilityWithAccessibilityEnabledTests`)
//
// Ideally it should be tested with a separate app, because this is
// not a default behavior. Main tests should be tested with default settings.
// We did not create multiple apps, we use simpler solution, we sacrifice iOS 14 for this purpose.
//
// Note: for some unknown reason accessibility is already initialized locally in Xcode for
// GrayBoxUiTests, but not on CI and not in UnitTests.
//
public final class AccessibilityForTestAutomationInitializerSettings {
    private init() {}
    
    public static func shouldUsePrivateApi(
        iosVersion: IosVersion
    ) -> Bool {
        return iosVersion.majorVersion == MixboxIosVersions.Supported.iOS14
    }
}
