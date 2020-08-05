#if MIXBOX_ENABLE_IN_APP_SERVICES

import MixboxDi

public protocol TypeErasedDefaultGeneratorProvider {
    static func typeErasedDefaultGenerator(dependencyResolver: DependencyResolver) throws -> Any
}

#endif
