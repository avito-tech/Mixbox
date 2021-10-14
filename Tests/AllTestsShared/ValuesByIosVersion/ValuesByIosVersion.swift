import MixboxUiKit
import MixboxTestsFoundation

/// See: `ValuesByIosVersionInInitialState`
class ValuesByIosVersion<T> {
    private let iosVersionProvider: IosVersionProvider
    private let getValueClosure: (IosVersion) throws -> T
    
    init(
        iosVersionProvider: IosVersionProvider,
        getValue: @escaping (IosVersion) throws -> T
    ) {
        self.iosVersionProvider = iosVersionProvider
        self.getValueClosure = getValue
    }
    
    func getValue() -> T {
        return UnavoidableFailure.doOrFail {
            try getValueOrThrow()
        }
    }
    
    func getValueOrThrow() throws -> T {
        return try getValueOrThrowFor(
            iosVersion: iosVersionProvider.iosVersion()
        )
    }
    
    func getValueFor(
        iosVersion: IosVersion
    ) -> T {
        return UnavoidableFailure.doOrFail {
            try getValueOrThrowFor(iosVersion: iosVersion)
        }
    }
    
    func getValueOrThrowFor(
        iosVersion: IosVersion
    ) throws -> T {
        return try getValueClosure(iosVersion)
    }
    
    func getValue(
        defaultValue: T
    ) -> T {
        return getValue(
            iosVersion: iosVersionProvider.iosVersion(),
            defaultValue: defaultValue
        )
    }
    
    func getValue(
        iosVersion: IosVersion,
        defaultValue: T
    ) -> T {
        do {
            return try getValueOrThrow()
        } catch {
            return defaultValue
        }
    }
}
