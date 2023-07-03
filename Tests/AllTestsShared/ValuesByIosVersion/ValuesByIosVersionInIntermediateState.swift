import MixboxUiKit
import MixboxFoundation
import MixboxTestsFoundation

final class ValuesByIosVersionInIntermediateState<T>: ValuesByIosVersion<T> {
    private let iosVersionProvider: IosVersionProvider
    private let valueForPriorIosVersions: T?
    private let valuesForLaterIosVersions: [ValueStartingFromGivenIosVersion<T>]
    
    fileprivate init(
        iosVersionProvider: IosVersionProvider,
        valueForPriorIosVersions: T?,
        valuesForLaterIosVersions: [ValueStartingFromGivenIosVersion<T>]
    ) {
        self.iosVersionProvider = iosVersionProvider
        self.valueForPriorIosVersions = valueForPriorIosVersions
        self.valuesForLaterIosVersions = valuesForLaterIosVersions
        
        super.init(
            iosVersionProvider: iosVersionProvider,
            getValue: { iosVersion in
                var value = valueForPriorIosVersions
                
                for valueStartingFromGivenIosVersion in valuesForLaterIosVersions {
                    if iosVersion < valueStartingFromGivenIosVersion.iosVersion {
                        break
                    }
                    value = valueStartingFromGivenIosVersion.value
                }
                
                return try value.unwrapOrThrow(
                    message: "No value is set for iOS version \(iosVersion)"
                )
            }
        )
    }
    
    static func initial(
        iosVersionProvider: IosVersionProvider,
        valueForPriorIosVersions: T?
    ) -> ValuesByIosVersionInIntermediateState {
        return ValuesByIosVersionInIntermediateState(
            iosVersionProvider: iosVersionProvider,
            valueForPriorIosVersions: valueForPriorIosVersions,
            valuesForLaterIosVersions: []
        )
    }
    
    // MARK: - Builder
    
    func since(
        _ iosVersion: IosVersion
    ) -> ValuesByIosVersionBuilderWithIosVersion<T> {
        if valuesForLaterIosVersions.contains(where: { $0.iosVersion >= iosVersion }) {
            UnavoidableFailure.fail("You should specify iOS versions in ascending order")
        }
        
        return ValuesByIosVersionBuilderWithIosVersion(
            iosVersionProvider: iosVersionProvider,
            valueForPriorIosVersions: valueForPriorIosVersions,
            valuesForLaterIosVersions: valuesForLaterIosVersions,
            iosVerson: iosVersion
        )
    }
    
    func until(
        _ iosVersion: IosVersion
    ) -> ValuesByIosVersionInFinalState<T> {
        return ValuesByIosVersionInFinalState<T>(
            iosVersionProvider: iosVersionProvider,
            previousState: self,
            laterNotSupportedVersion: iosVersion
        )
    }
}

final class ValuesByIosVersionBuilderWithIosVersion<T> {
    private let iosVersionProvider: IosVersionProvider
    private let valueForPriorIosVersions: T?
    private let valuesForLaterIosVersions: [ValueStartingFromGivenIosVersion<T>]
    private let iosVerson: IosVersion
    
    init(
        iosVersionProvider: IosVersionProvider,
        valueForPriorIosVersions: T?,
        valuesForLaterIosVersions: [ValueStartingFromGivenIosVersion<T>],
        iosVerson: IosVersion
    ) {
        self.iosVersionProvider = iosVersionProvider
        self.valueForPriorIosVersions = valueForPriorIosVersions
        self.valuesForLaterIosVersions = valuesForLaterIosVersions
        self.iosVerson = iosVerson
    }
    
    func value(_ value: T) -> ValuesByIosVersionInIntermediateState<T> {
        return ValuesByIosVersionInIntermediateState(
            iosVersionProvider: iosVersionProvider,
            valueForPriorIosVersions: valueForPriorIosVersions,
            valuesForLaterIosVersions: valuesForLaterIosVersions + [
                ValueStartingFromGivenIosVersion(
                    iosVersion: iosVerson,
                    value: value
                )
            ]
        )
    }
}
