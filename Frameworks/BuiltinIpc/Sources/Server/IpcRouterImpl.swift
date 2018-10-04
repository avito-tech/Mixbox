import MixboxIpc
import GCDWebServer

public final class BuiltinIpcServer: IpcRouter {
    typealias Handler = (_ data: Data, _ completion: @escaping (GCDWebServerResponse) -> ()) -> ()
    
    private let server = GCDWebServer()
    private var handlers = [String: Handler]()
    private let encoderFactory: EncoderFactory
    private let decoderFactory: DecoderFactory

    public init(
        encoderFactory: EncoderFactory,
        decoderFactory: DecoderFactory)
    {
        self.encoderFactory = encoderFactory
        self.decoderFactory = decoderFactory
        
        let kGCDWebServerLoggingLevel_Warning: Int32 = 3 // it is private in GCDWebServer module
        GCDWebServer.setLogLevel(kGCDWebServerLoggingLevel_Warning)
        
        server.addDefaultHandler(forMethod: "POST", request: GCDWebServerDataRequest.self) { [weak self] request, completion in
            guard let strongSelf = self else {
                return completion(error("strongSelf == nil"))
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
        handlers[methodHandler.method.name] = { [weak self] data, completion in
            guard let strongSelf = self else {
                return completion(error("strongSelf == nil"))
            }
            
            strongSelf.handle(
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
            return completion(error("request is not GCDWebServerDataRequest"))
        }
        
        let pathComponents = request.path
            .trimmingCharacters(in: CharacterSet(charactersIn: "/"))
            .components(separatedBy: "/")
        
        guard pathComponents.count == 1 else {
            return completion(error("pathComponents.count != 1: \(pathComponents.count) != 1"))
        }
        
        guard pathComponents.first == Routes.ipcMethod else {
            return completion(error("pathComponents.first != Routes.ipcMethod: \(String(describing: pathComponents.first)) != \(Routes.ipcMethod)"))
        }
        
        guard let container = try? JSONDecoder().decode(MethodNameContainer.self, from: request.data) else {
            return completion(error("decoding failed"))
        }
        
        guard let handler = handlers[container.method] else {
            return completion(error("method \(container.method) was not registered"))
        }
        
        handler(request.data) { response in
            completion(response)
        }
    }
    
    private func handle<MethodHandler: IpcMethodHandler>(
        data: Data,
        methodHandler: MethodHandler,
        completion: @escaping (GCDWebServerResponse) -> ())
    {
        let container = try? decoderFactory
            .decoder()
            .decode(RequestContainer<MethodHandler.Method.Arguments>.self, from: data)
        
        guard let arguments = container?.value else {
            return completion(error("container?.value == nil"))
        }
        
        methodHandler.handle(arguments: arguments) { [weak self] returnValue in
            guard let strongSelf = self else {
                return completion(error("self == nil"))
            }
            
            do {
                let data = try strongSelf.encoderFactory.encoder().encode(ResponseContainer(value: returnValue))
                
                let contentType = "application/json"
                completion(GCDWebServerDataResponse(data: data, contentType: contentType))
            } catch (let e) {
                completion(error("encoding failed: \(e)"))
            }
        }
    }
}

private func error(_ text: String, file: StaticString = #file, line: UInt = #line) -> GCDWebServerResponse {
    return GCDWebServerErrorResponse(
        serverError: .httpStatusCode_InternalServerError,
        text: "\(text) \(#file):\(#line)"
    )
}
