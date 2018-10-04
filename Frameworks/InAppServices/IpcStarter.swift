import MixboxIpc

protocol IpcStarter {
    // TODO: IpcClient should not be nil
    func start(commandsForAddingRoutes: [(IpcRouter) -> ()]) -> (IpcRouter, IpcClient?)
    
    // For SBTUI only. TODO: remove.
    func handleUiBecomeVisible()
}
