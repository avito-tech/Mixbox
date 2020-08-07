#if MIXBOX_ENABLE_IN_APP_SERVICES

protocol IpcStarterProvider {
    func ipcStarter() throws -> IpcStarter
}

#endif
