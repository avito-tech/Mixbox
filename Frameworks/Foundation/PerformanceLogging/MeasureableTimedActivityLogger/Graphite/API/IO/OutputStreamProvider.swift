#if MIXBOX_ENABLE_IN_APP_SERVICES

import Foundation

public protocol OutputStreamProvider {
    func createOutputStream() throws -> OutputStream
}

#endif
