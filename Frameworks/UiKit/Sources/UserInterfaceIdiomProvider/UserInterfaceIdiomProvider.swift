#if MIXBOX_ENABLE_IN_APP_SERVICES

import UIKit

public protocol UserInterfaceIdiomProvider {
    func userInterfaceIdiom() -> UIUserInterfaceIdiom
}

#endif
