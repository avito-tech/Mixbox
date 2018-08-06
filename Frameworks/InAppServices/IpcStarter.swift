import MixboxIpc

protocol IpcStarter {
    func start(commandsForAddingRoutes: [(IpcRouter) -> ()]) -> IpcRouter
    
    // For SBTUI only. TODO: remove.
    func handleUiBecomeVisible()
}
