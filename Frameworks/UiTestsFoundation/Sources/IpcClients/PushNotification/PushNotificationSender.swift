import Foundation

public protocol PushNotificationSender: AnyObject {
    func send(pushNotification: [AnyHashable: Any]) throws
}
