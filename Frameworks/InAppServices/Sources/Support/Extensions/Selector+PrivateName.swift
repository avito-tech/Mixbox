#if MIXBOX_ENABLE_IN_APP_SERVICES

// TODO: Use everywhere
extension Selector {
    // Suppresses `Use '#selector' instead of explicitly constructing a 'Selector'` warning
    init(privateName: String) {
        self.init(privateName)
    }
}

#endif
