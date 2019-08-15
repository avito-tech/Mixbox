#if MIXBOX_ENABLE_IN_APP_SERVICES

struct RequestContainer<T: Codable>: Codable {
    let method: String
    let value: T
}

#endif
