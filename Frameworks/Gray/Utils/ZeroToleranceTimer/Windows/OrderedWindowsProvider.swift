import Foundation
import UIKit

public protocol OrderedWindowsProvider: class {
    func windowsFromTopMostToBottomMost() -> [UIWindow]
    func windowsFromBottomMostToTopMost() -> [UIWindow]
}

extension OrderedWindowsProvider {
    public func windowsFromTopMostToBottomMost() -> [UIWindow] {
        return windowsFromBottomMostToTopMost().reversed()
    }
}
