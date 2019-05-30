import UIKit

public protocol UiEventObserver: class {
    func eventWasSent(event: UIEvent)
}
