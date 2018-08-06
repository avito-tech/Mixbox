import Foundation
import MixboxFoundation

public final class HostDefinedValueComparator {
    
    public static let doubeValueComparator: HostDefinedValueComparator = HostDefinedValueComparator {
        (hostedValue: String?, referenceValue: String) -> Bool in
        guard let hostedValue = hostedValue?.mb_toDouble(),
            let referenceValue = referenceValue.mb_toDouble() else { return false }
        return fabs(hostedValue - referenceValue) < 0.001
    }
    
    public static let directComparator: HostDefinedValueComparator = HostDefinedValueComparator {
        (hostedValue: String?, referenceValue: String) -> Bool in
        guard let hostedValue = hostedValue else { return false }
        return hostedValue == referenceValue
    }
    
    private typealias Comparator = (
        String?,    // hostValue
        String      // referenceValue
        ) -> (Bool)
    
    private let comparator: Comparator
    
    private init(_ comparator: @escaping Comparator) {
        self.comparator = comparator
    }
    
    public func compare(hostedValue: String?, referenceValue: String) -> Bool {
        return comparator(hostedValue, referenceValue)
    }
}
