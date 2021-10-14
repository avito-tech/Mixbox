import MixboxUiKit

/// Builds sequence of values that are changing depending on iOS version.
///
/// It can be visualised as (example):
/// (all prior iOS versions) value 1 (sinc: iOS 12.1) value 2 (since 15.3) value 3
///
/// Structure from this example looks like:
///
/// ```
///     .value("value 1")
///     .since(ios: 12, 1)
///     .value("value 2")
///     .since(ios: 15, 3)
///     .value("value 3")
///     .getValue() // "value 2" for iOS 13, for example
/// ```

final class ValuesByIosVersionInInitialState<T> {
    private let iosVersionProvider: IosVersionProvider

    init(iosVersionProvider: IosVersionProvider) {
        self.iosVersionProvider = iosVersionProvider
    }
    
    func value(
        _ value: T
    ) -> ValuesByIosVersionInIntermediateState<T> {
        return ValuesByIosVersionInIntermediateState<T>.initial(
            iosVersionProvider: iosVersionProvider,
            valueForPriorIosVersions: value
        )
    }
    
    func since(
        ios versionComponents: IosVersion.VersionComponent...
    ) -> ValuesByIosVersionBuilderWithIosVersion<T> {
        return ValuesByIosVersionBuilderWithIosVersion<T>(
            iosVersionProvider: iosVersionProvider,
            valueForPriorIosVersions: nil,
            valuesForLaterIosVersions: [],
            iosVerson: IosVersion(
                versionComponents: versionComponents
            )
        )
    }
}
