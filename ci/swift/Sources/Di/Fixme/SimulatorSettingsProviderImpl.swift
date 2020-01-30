import Emcee
import Models
import CiFoundation
import SingletonHell

public final class SimulatorSettingsProviderImpl: SimulatorSettingsProvider {
    private let environmentProvider: EnvironmentProvider
    
    public init(environmentProvider: EnvironmentProvider) {
        self.environmentProvider = environmentProvider
    }
    
    public func simulatorSettings() throws -> SimulatorSettings {
        let keyboards = ["en_US@sw=QWERTY;hw=Automatic"]
        
        return SimulatorSettings(
            simulatorLocalizationSettings: SimulatorLocalizationSettings(
                localeIdentifier: "en_US",
                keyboards: keyboards,
                passcodeKeyboards: keyboards,
                languages: ["en"],
                addingEmojiKeybordHandled: true,
                enableKeyboardExpansion: true,
                didShowInternationalInfoAlert: true
            ),
            watchdogSettings: WatchdogSettings(
                bundleIds: [
                    "mixbox.Tests.TestedApp",
                    "mixbox.Tests.BlackBoxUiTests",
                    "mixbox.Tests.UnitTests",
                    "mixbox.Tests.HostedAppLogicTests",
                    "mixbox.Tests.GrayBoxUiTests",
                    "mixbox.Tests.FakeSettingsApp",
                    "mixbox.Tests.Lint",
                    "com.mixbox.AppForCheckingPureXctest",
                    "com.mixbox.AppForCheckingPureXctestUITests"
                ],
                timeout: 150
            )
        )
    }
}
