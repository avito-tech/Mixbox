#if MIXBOX_ENABLE_IN_APP_SERVICES

public protocol CaseGeneratable {
    static var allCasesGenerators: AllCasesGenerators<Self> { get }
}

#endif
