struct RequestContainer<T: Codable>: Codable {
    let method: String
    let value: T
}
