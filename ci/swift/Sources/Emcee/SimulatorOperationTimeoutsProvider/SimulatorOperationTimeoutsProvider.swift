import SimulatorPoolModels

public protocol SimulatorOperationTimeoutsProvider {
    func simulatorOperationTimeouts() -> SimulatorOperationTimeouts
}
