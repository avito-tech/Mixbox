#if MIXBOX_ENABLE_IN_APP_SERVICES

// Used for kludge. See usage.
// TODO: Replace with ErrorString after issue is resolved.
struct HttpBodyStreamIsNotSupportedError: Error, CustomStringConvertible {
    let description: String
    
    init(_ description: String) {
        self.description = description
    }
}

#endif
