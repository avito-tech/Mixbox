import Foundation

public final class SystemClockDateProvider: DateProvider {
    public init() {
    }
    
    public func currentDate() -> Date {
        return Date()
    }
}
