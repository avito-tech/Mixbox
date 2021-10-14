import MixboxUiKit
import MixboxFoundation
import MixboxTestsFoundation

final class ValuesByIosVersionInFinalState<T>: ValuesByIosVersion<T> {
    init(
        iosVersionProvider: IosVersionProvider,
        previousState: ValuesByIosVersionInIntermediateState<T>,
        laterNotSupportedVersion: IosVersion
    ) {
        super.init(
            iosVersionProvider: iosVersionProvider,
            getValue: { iosVersion in
                if iosVersion >= laterNotSupportedVersion {
                    throw ErrorString(
                        "Versions since iOS \(laterNotSupportedVersion) are not supported for this value (given version: \(iosVersion))"
                    )
                }
                
                return previousState.getValueFor(iosVersion: iosVersion)
            }
        )
    }
}
