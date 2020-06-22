import Foundation

public protocol DateProvider: class {
    func currentDate() -> Date
}
