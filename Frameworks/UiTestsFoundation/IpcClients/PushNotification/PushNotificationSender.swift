import Foundation

public protocol PushNotificationSender: class {
    func send(pushNotification: [AnyHashable: Any]) throws
}
