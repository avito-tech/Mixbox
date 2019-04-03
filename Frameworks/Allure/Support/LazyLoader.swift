// Enums are not nested because of https://bugs.swift.org/browse/SR-4383
// GenericCache(0x122edbc00): cyclic metadata dependency detected

public enum LazyLoaderResult<T> {
    case loaded(T)
    case failure(String)
}

private enum LazyLoaderState<T> {
    case initial
    case loading
    case loaded(T)
}

// Makes async call with ability to preload data and to wait data is loaded.
// Useful for tests where you should support synchronicity and want to minimize waiting time.
//
// Example:
//
// init() {
//     self.lazyLoader = LazyLoader<Bar> { completion in
//         fooApi.getBar { bar in
//             completion(bar)
//         }
//     }
// }
//
// func start() {
//     lazyLoader.preload()
// }
//
// func stop() {
//     handleValue(lazyLoader.value())
// }
//
// TODO: Move somewhere
//
public final class LazyLoader<T> {
    public typealias Completion = (T) -> ()
    
    // MARK: - Private
    
    private let dispatchGroup = DispatchGroup()
    private let load: (@escaping Completion) -> ()
    private var state: LazyLoaderState<T> = .initial
    
    // MARK: - Init
    
    public init(load: @escaping (@escaping Completion) -> ()) {
        self.load = load
    }
    
    // MARK: - Loading
    
    public func preload() {
        switch state {
        case .initial:
            dispatchGroup.enter()
            state = .loading
            load { [weak self] result in
                self?.state = .loaded(result)
                self?.dispatchGroup.leave()
            }
        case .loading:
            break
        case .loaded:
            break
        }
    }
    
    public func value() -> LazyLoaderResult<T> {
        switch state {
        case .initial:
            preload()
            return value()
        case .loading:
            return waitLoading()
        case .loaded(let value):
            return .loaded(value)
        }
    }
    
    // MARK: - Private
    
    private func waitLoading() -> LazyLoaderResult<T> {
        dispatchGroup.wait()
        
        switch state {
        case .initial:
            return .failure("Incorrect transition in LazyLoader from .loading to .initial")
        case .loading:
            return .failure("Incorrect transition in LazyLoader from .loading to .loading")
        case .loaded(let value):
            return .loaded(value)
        }
    }
}
