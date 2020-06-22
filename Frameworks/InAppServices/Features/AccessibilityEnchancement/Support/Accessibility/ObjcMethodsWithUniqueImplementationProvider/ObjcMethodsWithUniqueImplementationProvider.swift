#if MIXBOX_ENABLE_IN_APP_SERVICES

import MixboxFoundation
import Foundation
import UIKit

public protocol ObjcMethodsWithUniqueImplementationProvider {
    func objcMethodsWithUniqueImplementation(
        baseClass: NSObject.Type,
        selector: Selector,
        methodType: MethodType)
        -> [ObjcMethodWithUniqueImplementation]
}

#endif
