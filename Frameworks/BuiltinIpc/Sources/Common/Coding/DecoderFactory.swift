#if MIXBOX_ENABLE_IN_APP_SERVICES
import Foundation

public protocol DecoderFactory: class {
    func decoder() -> JSONDecoder
}

#endif
