import UIKit

public protocol UiEventObserver {
    func eventWasSent(event: UIEvent)
}
