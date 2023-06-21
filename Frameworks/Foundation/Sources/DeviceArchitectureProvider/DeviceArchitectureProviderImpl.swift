#if MIXBOX_ENABLE_FRAMEWORK_FOUNDATION && MIXBOX_DISABLE_FRAMEWORK_FOUNDATION
#error("Foundation is marked as both enabled and disabled, choose one of the flags")
#elseif MIXBOX_DISABLE_FRAMEWORK_FOUNDATION || (!MIXBOX_ENABLE_ALL_FRAMEWORKS && !MIXBOX_ENABLE_FRAMEWORK_FOUNDATION)
// The compilation is disabled
#else

import MachO

public final class DeviceArchitectureProviderImpl: DeviceArchitectureProvider {
    public init() {
    }
    
    public func deviceArchitecture() throws -> DeviceArchitecture {
        let architectureString = String(cString: NXGetLocalArchInfo().pointee.name)
        
        guard let deviceArchitecture = DeviceArchitecture(
            rawValue: architectureString
        ) else {
            throw ErrorString("Unknown architecture: \(architectureString)")
        }
        
        return deviceArchitecture
    }
}

#endif
