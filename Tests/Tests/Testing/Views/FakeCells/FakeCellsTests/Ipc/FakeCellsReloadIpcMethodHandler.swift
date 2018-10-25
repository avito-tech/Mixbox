import MixboxIpc

final class FakeCellsReloadIpcMethodHandler: IpcMethodHandler {
    static let instance = FakeCellsReloadIpcMethodHandler()
    
    private init() {
    }
    
    let method = FakeCellsReloadIpcMethod()
    
    var onHandle: ((_ type: FakeCellsReloadType, _ completion: @escaping (Int) -> ()) -> ())?
    
    func handle(arguments: FakeCellsReloadType, completion: @escaping (Int) -> ()) {
        guard let onHandle = onHandle else {
            assertionFailure("onHandle is not set")
            completion(0)
            return
        }
        
        DispatchQueue.main.async {
            onHandle(arguments, completion)
        }
    }
}

final class FakeCellsSubviewsInfoIpcMethodHandler: IpcMethodHandler {
    static let instance = FakeCellsSubviewsInfoIpcMethodHandler()
    
    private init() {
    }
    
    let method = FakeCellsSubviewsInfoIpcMethod()
    
    var subviewsInfoGetter: (() -> ([FakeCellsSubviewsInfoIpcMethod.SubviewInfo]))?
    
    func handle(arguments: IpcVoid, completion: @escaping ([FakeCellsSubviewsInfoIpcMethod.SubviewInfo]) -> ()) {
        guard let subviewsInfoGetter = subviewsInfoGetter else {
            assertionFailure("countOfSubviewsGetter is not set")
            completion([])
            return
        }
        
        DispatchQueue.main.async {
            completion(subviewsInfoGetter())
        }
    }
}
