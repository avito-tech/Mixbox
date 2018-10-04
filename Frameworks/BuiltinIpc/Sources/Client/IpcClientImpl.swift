import MixboxFoundation
import MixboxIpc

public final class BuiltinIpcClient: IpcClient {
    private let port: UInt
    private let host: String
    private let encoderFactory: EncoderFactory
    private let decoderFactory: DecoderFactory
    
    public init(
        host: String,
        port: UInt,
        encoderFactory: EncoderFactory,
        decoderFactory: DecoderFactory)
    {
        self.host = host
        self.port = port
        self.encoderFactory = encoderFactory
        self.decoderFactory = decoderFactory
    }
    
    public func handshake(localPort: UInt) {
        call(
            method: HandshakeIpcMethod(),
            arguments: localPort,
            completion: { _ in
                // no handling yet
            }
        )
    }
    
    public func call<Method: IpcMethod>(
        method: Method,
        arguments: Method.Arguments,
        completion: @escaping (DataResult<Method.ReturnValue, IpcClientError>) -> ())
    {
        let container = RequestContainer(method: method.name, value: arguments)
        
        guard let data = try? encoderFactory.encoder().encode(container) else {
            completion(.error(.encodingError))
            return
        }
        
        call(
            method: method.name,
            data: data,
            completion: completion
        )
    }
    
    // TODO: Better error handling before replacing SBTUI with it.
    private func call<ReturnValue: Codable>(
        method: String,
        data: Data,
        completion: @escaping (DataResult<ReturnValue, IpcClientError>) -> ())
    {
        guard let url = URL(string: "http://\(host):\(port)/\(Routes.ipcMethod)") else {
            completion(.error(.customError("URL(string:) failed")))
            return
        }
        var request = URLRequest(url: url)
        
        request.httpBody = data
        request.httpMethod = "POST"
        
        let dataTask = URLSession.shared.dataTask(with: request) { [weak self] data, urlResponse, error in
            guard let strongSelf = self else {
                completion(.error(.customError("self == nil")))
                return
            }
            
            strongSelf.handleResult(data: data, urlResponse: urlResponse, error: error, completion: completion)
        }
        
        dataTask.resume()
    }
    
    private func handleResult<ReturnValue: Codable>(
        data: Data?,
        urlResponse: URLResponse?,
        error: Error?,
        completion: @escaping (DataResult<ReturnValue, IpcClientError>) -> ())
    {
        guard let data = data else {
            completion(.error(.customError("data == nil")))
            return
        }
        
        let container = try? decoderFactory.decoder().decode(ResponseContainer<ReturnValue>.self, from: data)
        
        guard let decodedResponse: ReturnValue = container?.value else {
            completion(.error(.decodingError))
            return
        }
        
        completion(.data(decodedResponse))
    }
}
