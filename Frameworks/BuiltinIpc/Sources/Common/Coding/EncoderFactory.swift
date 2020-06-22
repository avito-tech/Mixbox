#if MIXBOX_ENABLE_IN_APP_SERVICES
import Foundation

public protocol EncoderFactory: class {
    func encoder() -> JSONEncoder
}

#endif
