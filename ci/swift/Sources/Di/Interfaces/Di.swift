public protocol Di {
    func resolve<T>() throws -> T
}

