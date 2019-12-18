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
        return SimulatorSettings(
            simulatorLocalizationSettings: SimulatorLocalizationLocation(
                ResourceLocation.remoteUrl(try environmentProvider.getUrlOrThrow(env: Env.MIXBOX_CI_SIMULATOR_LOCALIZATION_URL))
            ),
            watchdogSettings: WatchdogSettingsLocation(
                ResourceLocation.remoteUrl(try environmentProvider.getUrlOrThrow(env: Env.MIXBOX_CI_WATCHDOG_SETTINGS_URL))
            )
        )
    }
}
