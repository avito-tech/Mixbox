#if MIXBOX_ENABLE_IN_APP_SERVICES

struct ResponseContainer<T: Codable>: Codable {
    let value: T
}

#endif
