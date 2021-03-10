import Foundation

public protocol UrlOpener: class {
    func open(url: URL) throws
}
