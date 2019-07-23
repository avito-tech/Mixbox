#if MIXBOX_ENABLE_IN_APP_SERVICES

// TODO: Rename to Result / use third party pod
public enum DataResult<T, E> {
    case data(T)
    case error(E)
    
    public typealias Completion = (DataResult) -> ()
    
    public typealias DataType = T
    public typealias ErrorType = E
    
    public var data: T? {
        switch self {
        case .data(let data):
            return data
        case .error:
            return nil
        }
    }
    
    public var error: E? {
        switch self {
        case .error(let error):
            return error
        case .data:
            return nil
        }
    }
    
    public var isError: Bool {
        switch self {
        case .error:
            return true
        case .data:
            return false
        }
    }
    
    public var isData: Bool {
        switch self {
        case .error:
            return false
        case .data:
            return true
        }
    }
    
    public func onData(_ closure: (T) -> ()) {
        switch self {
        case .error:
            break
        case .data(let data):
            closure(data)
        }
    }
    
    public func onError(_ closure: (E) -> ()) {
        switch self {
        case .error(let error):
            closure(error)
        case .data:
            break
        }
    }
    
    public func mapData<TNew>(
        _ transform: (T) throws -> TNew) rethrows
        -> DataResult<TNew, E>
    {
        switch self {
        case .data(let data):
            return try .data(transform(data))
        case .error(let error):
            return .error(error)
        }
    }
    
    public func mapError<ENew>(
        _ transform: (E) throws -> ENew) rethrows
        -> DataResult<T, ENew>
    {
        switch self {
        case .data(let data):
            return .data(data)
        case .error(let error):
            return .error(try transform(error))
        }
    }
    
    public func flatMapData<TNew>(
        _ transform: (T) throws -> DataResult<TNew, E>) rethrows
        -> DataResult<TNew, E>
    {
        switch self {
        case .data(let data):
            return try transform(data)
        case .error(let error):
            return .error(error)
        }
    }
    
    public func flatMapError<ENew>(
        _ transform: (E) throws -> DataResult<T, ENew>) rethrows
        -> DataResult<T, ENew>
    {
        switch self {
        case .data(let data):
            return .data(data)
        case .error(let error):
            return try transform(error)
        }
    }
}

#endif
