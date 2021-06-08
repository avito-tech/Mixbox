import Foundation

public protocol UrlOpener: AnyObject {
    func open(url: URL) throws
}
