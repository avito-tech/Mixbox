#if MIXBOX_ENABLE_IN_APP_SERVICES

public protocol PageObjectElementGenerationWizard {
    func set(onFinish: (() -> ())?)
    
    func start()
}

#endif
