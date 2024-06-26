#if MIXBOX_ENABLE_FRAMEWORK_BUILTIN_IPC && MIXBOX_DISABLE_FRAMEWORK_BUILTIN_IPC
#error("BuiltinIpc is marked as both enabled and disabled, choose one of the flags")
#elseif MIXBOX_DISABLE_FRAMEWORK_BUILTIN_IPC || (!MIXBOX_ENABLE_ALL_FRAMEWORKS && !MIXBOX_ENABLE_FRAMEWORK_BUILTIN_IPC)
// The compilation is disabled
#else

import MixboxFoundation
import MixboxIpc

public typealias AsyncFunction<Arguments, ReturnValue> = (Arguments, @escaping (ReturnValue) -> ()) -> ()
public typealias SyncFunction<Arguments, ReturnValue> = (Arguments) -> ReturnValue

public final class IpcCallback<Arguments: Codable, ReturnValue: Codable>: Codable {
    private let closure: AsyncFunction<Arguments, DataResult<ReturnValue, Error>>
    
    public static func async(_ closure: @escaping AsyncFunction<Arguments, ReturnValue>) -> IpcCallback {
        return IpcCallback { args, completion in
            closure(args) { value in
                completion(.data(value))
            }
        }
    }
    
    public static func sync(_ closure: @escaping SyncFunction<Arguments, ReturnValue>) -> IpcCallback {
        return IpcCallback { args, completion in
            completion(.data(closure(args)))
        }
    }
    
    public init(_ closure: @escaping AsyncFunction<Arguments, DataResult<ReturnValue, Error>>) {
        self.closure = closure
    }
    
    public func call(arguments: Arguments, completion: @escaping (DataResult<ReturnValue, Error>) -> ()) {
        closure(arguments, completion)
    }
    
    private enum CodingKeys: String, CodingKey {
        case id
    }
    
    public func encode(to encoder: Encoder) throws {
        let id = "\(ObjectIdentifier(self))"
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: CodingKeys.id)
        
        guard let ipcCallbackStorageKey = CodingUserInfoKey(rawValue: "ipcCallbackStorage"),
            let ipcCallbackStorage = encoder.userInfo[ipcCallbackStorageKey] as? IpcCallbackStorage else
        {
            throw ErrorString("encoder.userInfo[ipcCallbackStorageKey] is not IpcCallbackStorage")
        }
        
        guard let encoderFactoryKey = CodingUserInfoKey(rawValue: "encoderFactory"),
            let encoderFactory = encoder.userInfo[encoderFactoryKey] as? EncoderFactory else
        {
            throw ErrorString("encoder.userInfo[encoderFactoryKey] is not EncoderFactory")
        }
        
        guard let decoderFactoryKey = CodingUserInfoKey(rawValue: "decoderFactory"),
            let decoderFactory = encoder.userInfo[decoderFactoryKey] as? DecoderFactory else
        {
            throw ErrorString("encoder.userInfo[decoderFactoryKey] is not DecoderFactory")
        }
        
        ipcCallbackStorage[id] = { [closure] string, completion in
            guard let deserialized: Arguments = try? GenericSerialization.deserialize(string: string, decoder: decoderFactory.decoder()) else {
                return completion(nil)
            }
            
            closure(deserialized) { (result: DataResult<ReturnValue, Error>) in
                if let data = result.data {
                    completion(try? GenericSerialization.serialize(value: data, encoder: encoderFactory.encoder()))
                } else {
                    completion(nil)
                }
            }
        }
    }
    
    // swiftlint:disable:next function_body_length
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let callbackId = try container.decode(String.self, forKey: .id)
        
        guard let ipcClientHolderKey = CodingUserInfoKey(rawValue: "ipcClientHolder"),
            let ipcClientHolder = decoder.userInfo[ipcClientHolderKey] as? IpcClientHolder else
        {
            throw ErrorString("decoder.userInfo[ipcClientHolderKey] is not IpcClientHolder")
        }
        
        guard let encoderFactoryKey = CodingUserInfoKey(rawValue: "encoderFactory"),
            let encoderFactory = decoder.userInfo[encoderFactoryKey] as? EncoderFactory else
        {
            throw ErrorString("decoder.userInfo[encoderFactoryKey] is not EncoderFactory")
        }
        
        guard let decoderFactoryKey = CodingUserInfoKey(rawValue: "decoderFactory"),
            let decoderFactory = decoder.userInfo[decoderFactoryKey] as? DecoderFactory else
        {
            throw ErrorString("decoder.userInfo[decoderFactoryKey] is not DecoderFactory")
        }
        
        self.closure = { (args: Arguments, completion: @escaping (DataResult<ReturnValue, Error>) -> ()) in
            do {
                let serializedArgs = try GenericSerialization.serialize(value: args, encoder: encoderFactory.encoder())

                guard let ipcClient = ipcClientHolder.ipcClient else {
                    throw ErrorString("ipcClientHolder.ipcClient is nil")
                }
                
                let method = CallIpcCallbackIpcMethod()
                let arguments = CallIpcCallbackIpcMethod.Arguments(
                    callbackId: callbackId,
                    callbackArguments: serializedArgs
                )
                let completion: (DataResult<String?, Error>) -> () = { (result: DataResult<String?, Error>) -> () in
                    switch result {
                    case .data(let string):
                        guard let string = string else {
                            completion(.error(ErrorString("TBD"))) // TODO: Better error
                            return
                        }
                        
                        do {
                            let deserialized: ReturnValue = try GenericSerialization.deserialize(string: string, decoder: decoderFactory.decoder())
                            completion(.data(deserialized))
                        } catch {
                            completion(.error(error))
                        }
                    case .error(let error):
                        completion(.error(error))
                    }
                }

                ipcClient.call(
                    method: method,
                    arguments: arguments,
                    completion: completion
                )
            } catch {
                completion(.error(error))
            }
        }
    }
}

public extension IpcCallback {
    // Synchronous version
    func call(
        arguments: Arguments)
        -> DataResult<ReturnValue, Error>
    {
        var result: DataResult<ReturnValue, Error>?
        
        call(arguments: arguments) { localResult in
            result = localResult
        }
        
        // TODO: Use a specific tool for non-blocking (kind of) waiting in the current thread.
        while result == nil {
            RunLoop.current.run(until: Date(timeIntervalSinceNow: 1))
        }
        
        return result ?? .error(ErrorString("noResponse")) // TODO: Better error
    }
}

public extension IpcCallback where Arguments == IpcVoid {
    // Synchronous version for methods without arguments
    func call() -> DataResult<ReturnValue, Error> {
        return call(arguments: IpcVoid())
    }
}

public extension IpcCallback where Arguments == IpcVoid {
    // Asynchronous version for methods without arguments
    func call(
        completion: @escaping (DataResult<ReturnValue, Error>) -> ())
    {
        call(arguments: IpcVoid(), completion: completion)
    }
}

#endif
