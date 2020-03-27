import SimulatorPoolModels
import Emcee

public final class DefaultSimulatorOperationTimeoutsProvider: SimulatorOperationTimeoutsProvider {
    public init() {
    }
    
    public func simulatorOperationTimeouts() -> SimulatorOperationTimeouts {
        return SimulatorOperationTimeouts(
            create: 30,
            boot: 180,
            delete: 20,
            shutdown: 20,
            automaticSimulatorShutdown: 60,
            automaticSimulatorDelete: 300
        )
    }
}
