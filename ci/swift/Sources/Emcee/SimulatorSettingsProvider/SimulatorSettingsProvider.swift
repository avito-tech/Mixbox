import Models
import SimulatorPoolModels

public protocol SimulatorSettingsProvider {
    func simulatorSettings() throws -> SimulatorSettings
}
