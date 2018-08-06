import MixboxIpc
import GCDWebServer

public final class BuiltinIpcServer: IpcRouter {
    typealias Handler = (_ data: Data, _ completion: @escaping (GCDWebServerResponse) -> ()) -> ()
    
    private let server = GCDWebServer()
    private var handlers = [String: Handler]()
    
    public init() {
        let kGCDWebServerLoggingLevel_Warning: Int32 = 3 // it is private in GCDWebServer module
        GCDWebServer.setLogLevel(kGCDWebServerLoggingLevel_Warning)
        
        server.addDefaultHandler(forMethod: "POST", request: GCDWebServerDataRequest.self) { [weak self] request, completion in
            guard let strongSelf = self else {
                completion(GCDWebServerResponse(statusCode: 500))
                return
            }
            
            strongSelf.handle(
                request: request,
                completion: completion
            )
        }
    }
    
    public func start() -> UInt? {
        do {
            let options: [AnyHashable: Any]
            
            #if os(iOS)
            options = [
                GCDWebServerOption_AutomaticallySuspendInBackground: false,
            ]
            #else
            options = [:]
            #endif
            
            try server.start(
                options: options
            )
            return server.port
        } catch {
            return nil
        }
    }
    
    public func register<MethodHandler: IpcMethodHandler>(methodHandler: MethodHandler) {
        handlers[methodHandler.method.name] = { data, completion in
            BuiltinIpcServer.handle(
                data: data,
                methodHandler: methodHandler,
                completion: completion
            )
        }
    }
    
    // TODO: Better error handling before replacing SBTUI with it.
    private func handle(
        request: GCDWebServerRequest,
        completion: @escaping (GCDWebServerResponse) -> ())
    {
        guard let request = request as? GCDWebServerDataRequest else {
            completion(GCDWebServerResponse(statusCode: 500))
            return
        }
        
        let pathComponents = request.path
            .trimmingCharacters(in: CharacterSet(charactersIn: "/"))
            .components(separatedBy: "/")
        
        guard pathComponents.count == 1 else {
            completion(GCDWebServerResponse(statusCode: 500))
            return
        }
        
        guard pathComponents.first == Routes.ipcMethod else {
            completion(GCDWebServerResponse(statusCode: 500))
            return
        }
        
        guard let container = try? JSONDecoder().decode(MethodNameContainer.self, from: request.data) else {
            completion(GCDWebServerResponse(statusCode: 500))
            return
        }
        
        guard let handler = handlers[container.method] else {
            completion(GCDWebServerResponse(statusCode: 500))
            return
        }
        
        handler(request.data) { response in
            completion(response)
        }
    }
    
    private static func handle<MethodHandler: IpcMethodHandler>(
        data: Data,
        methodHandler: MethodHandler,
        completion: @escaping (GCDWebServerResponse) -> ())
    {
        let container = try? JSONDecoder().decode(RequestContainer<MethodHandler.Method.Arguments>.self, from: data)
        
        guard let arguments = container?.value else {
            completion(GCDWebServerResponse(statusCode: 500))
            return
        }
        
        methodHandler.handle(arguments: arguments) { returnValue in
            guard let data = try? JSONEncoder().encode(ResponseContainer(value: returnValue)) else {
                completion(GCDWebServerResponse(statusCode: 500))
                return
            }
            
            let contentType = "application/json"
            completion(GCDWebServerDataResponse(data: data, contentType: contentType))
        }
    }
}
