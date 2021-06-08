import UIKit

public protocol ApplicationFrameProvider: AnyObject {
    var applicationFrame: CGRect { get }
}
