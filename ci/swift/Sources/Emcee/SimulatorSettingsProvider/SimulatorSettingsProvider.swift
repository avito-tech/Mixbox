import Models

public protocol SimulatorSettingsProvider {
    func simulatorSettings() throws -> SimulatorSettings
}
