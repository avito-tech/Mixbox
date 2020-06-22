#if MIXBOX_ENABLE_IN_APP_SERVICES

import MixboxFoundation
import MixboxIpc
import Foundation

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
    
    public func call<Method: IpcMethod>(
        method: Method,
        arguments: Method.Arguments,
        completion: @escaping (DataResult<Method.ReturnValue, Error>) -> ())
    {
        let container = RequestContainer(method: method.name, value: arguments)
        
        guard let data = try? encoderFactory.encoder().encode(container) else {
            completion(.error(ErrorString("encodingError"))) // TODO: Better error
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
        completion: @escaping (DataResult<ReturnValue, Error>) -> ())
    {
        guard let url = URL(string: "http://\(host):\(port)/\(Routes.ipcMethod)") else {
            completion(.error(ErrorString("URL(string:) failed"))) // TODO: Better error
            return
        }
        var request = URLRequest(url: url)
        
        request.httpBody = data
        request.httpMethod = "POST"
        
        let dataTask = URLSession.shared.dataTask(with: request) { [weak self] data, urlResponse, error in
            guard let strongSelf = self else {
                completion(.error(ErrorString("self == nil"))) // TODO: Better error
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
        completion: @escaping (DataResult<ReturnValue, Error>) -> ())
    {
        guard let data = data else {
            completion(.error(ErrorString("data == nil"))) // TODO: Better error
            return
        }
        
        let typeToDecode = ResponseContainer<ReturnValue>.self
        
        do {
            let container = try decoderFactory.decoder().decode(typeToDecode, from: data)
            
            completion(.data(container.value))
        } catch {
            var statusCodeNotice: String {
                guard let urlResponse = urlResponse else {
                    return "Note that urlResponse is nil."
                }
                
                guard let httpUrlResponse = urlResponse as? HTTPURLResponse else {
                    return "Note that urlResponse is not HTTPURLResponse."
                }
                
                let statusCode = httpUrlResponse.statusCode
                
                if statusCode != 200 {
                    return "Note that statusCode != 200 (it is \(statusCode))"
                } else {
                    return "Note that statusCode is 200, so it is a pure decoding error"
                }
            }
            
            completion(
                .error(
                    ErrorString(
                        """
                        Failed to decode \(typeToDecode): "\(error)". \(statusCodeNotice)
                        """
                    )
                )
            )
        }
    }
}

#endif
