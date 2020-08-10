#if MIXBOX_ENABLE_IN_APP_SERVICES

import MixboxFoundation
import MixboxIpc

// Handy utility to bridge throwing functions via IPC
// TODO: Add assertion that result is unused (and thus exception was not handled)?
public enum IpcThrowingFunctionResult<T: Codable>: Codable {
    case returned(T)
    case threw(ErrorString)
    
    private enum CodingKeys: String, CodingKey {
        case caseId
        case returned
        case threw
    }
    
    private enum CaseId: String, Codable {
        case returned
        case threw
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        switch self {
        case .returned(let nested):
            try container.encode(CaseId.returned, forKey: .caseId)
            try container.encode(nested, forKey: .returned)
        case .threw(let nested):
            try container.encode(CaseId.threw, forKey: .caseId)
            try container.encode(nested, forKey: .threw)
        }
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let caseId = try container.decode(CaseId.self, forKey: .caseId)
        
        switch caseId {
        case .returned:
            self = .returned(try container.decode(T.self, forKey: .returned))
        case .threw:
            self = .threw(try container.decode(ErrorString.self, forKey: .threw))
        }
    }
}

extension IpcThrowingFunctionResult: Equatable where T: Equatable {
    public static func ==(lhs: IpcThrowingFunctionResult, rhs: IpcThrowingFunctionResult) -> Bool {
        switch (lhs, rhs) {
        case let (.returned(lhs), .returned(rhs)):
            return lhs == rhs
        case let (.threw(lhs), .threw(rhs)):
            return lhs == rhs
        default:
            return false
        }
    }
}

extension IpcThrowingFunctionResult {
    public init(throwingClosure: () throws -> T) {
        do {
            self = .returned(try throwingClosure())
        } catch {
            self = .threw(ErrorString("\(error)"))
        }
    }
    
    public func getReturnValue() throws -> T {
        switch self {
        case .returned(let value):
            return value
        case .threw(let error):
            throw error
        }
    }
}

extension IpcThrowingFunctionResult where T == IpcVoid {
    public func getVoidReturnValue() throws {
        switch self {
        case .returned:
            break
        case .threw(let error):
            throw error
        }
    }
    
    public static func void(throwingClosure: () throws -> ()) -> IpcThrowingFunctionResult {
        do {
            try throwingClosure()
            
            return .returned(IpcVoid())
        } catch {
            return .threw(ErrorString("\(error)"))
        }
    }
}

#endif
