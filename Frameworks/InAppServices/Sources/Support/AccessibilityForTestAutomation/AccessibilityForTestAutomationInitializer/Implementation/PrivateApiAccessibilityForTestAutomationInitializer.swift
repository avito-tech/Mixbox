#if MIXBOX_ENABLE_IN_APP_SERVICES

import MixboxFoundation
import MixboxUiKit

// WARNING: Unstable on iOS 14. Not recommended.
// TODO: Maybe there is a reliable private API for waiting for enabling accessibility?
//
// In Apple's "UI tests" there is a full support of using accessibility for testing.
// All elements provide their frames, labels, values, etc, correctly.
// Many methods are available at runtime. This class attempts to recreate same
// behavior in unit tests (which is what we use for graybox UI testing).
public final class PrivateApiAccessibilityForTestAutomationInitializer:
    AccessibilityForTestAutomationInitializer
{
    // Our primary (and the only) method of enabling UI-tests-like accessibility before iOS 14.
    // It became unstable since iOS 14.
    private let accessibilityUtilitiesAccessibilityInitializer = AccessibilityUtilitiesAccessibilityInitializer()
    
    // A second version, not known to be working reliably either:
    private let libAccessibilityAccessibilityInitializer = LibAccessibilityAccessibilityInitializer()
        
    // Another way of "doing something" (in order to make AX work, I can't even call it enabling AX).
    // Experiments showed that loading this grants few necessary implementations
    // (i.e. `_accessibilityUserTestingChildren` method), but
    // doesn't really fixes the issue on iOS 14. It can be used as a last resort.
    // I ran tests. In the first test I didn't enable AX at all. In the second test I only
    // used `AccessibilityUtilities` framework. First method gave 0 passed tests. Second gave
    // 56 passed tests (and 140 failed tests nonetheless). All errors I've seen were because
    // elements didn't provide their correct accessibilityFrame.
    private let uiAccessibilityAccessibilityInitializer = UIAccessibilityAccessibilityInitializer()
    
    private let runLoopSpinningWaiter: RunLoopSpinningWaiter
    private let accessibilityInitializationStatusProvider: AccessibilityInitializationStatusProvider
    private let iosVersionProvider: IosVersionProvider
    
    public init(
        runLoopSpinningWaiter: RunLoopSpinningWaiter,
        accessibilityInitializationStatusProvider: AccessibilityInitializationStatusProvider,
        iosVersionProvider: IosVersionProvider)
    {
        self.runLoopSpinningWaiter = runLoopSpinningWaiter
        self.accessibilityInitializationStatusProvider = accessibilityInitializationStatusProvider
        self.iosVersionProvider = iosVersionProvider
    }
    
    public func initializeAccessibility() throws {
        var lastError: Error?
        
        let result = runLoopSpinningWaiter.wait(
            timeout: 60,
            interval: 1,
            until: { [accessibilityInitializationStatusProvider] in
                if accessibilityInitializationStatusProvider.accessibilityInitializationStatus.isInitialized {
                    return true
                } else {
                    do {
                        try self.initializeUsingRegularMethod()
                        lastError = nil
                    } catch {
                        lastError = error
                    }
                    
                    return false // will wait until next iteration
                }
            }
        )
        
        switch result {
        case .stopConditionMet:
            // Ok!
            return
        case .timedOut:
            try initializeUsingFallbackMethod(lastError: lastError)
        }
    }
    
    private func initializeUsingRegularMethod() throws {
        var errors = [String]()
        
        // It was never necessary on iOS versions prior to 14, so there's no need to call it,
        // because what it does is really unknown.
        if iosVersionProvider.iosVersion().majorVersion >= 14 {
            if let error = libAccessibilityAccessibilityInitializer.initializeAccessibilityOrReturnError() {
                errors.append(error)
            }
        }
        
        if let error = accessibilityUtilitiesAccessibilityInitializer.initializeAccessibilityOrReturnError() {
            errors.append(error)
        }
        
        if let error = errors.first, errors.count == 1 {
            throw ErrorString(error)
        } else if !errors.isEmpty {
            throw ErrorString(errors.joined(separator: ", "))
        }
    }
    
    private func initializeUsingFallbackMethod(lastError: Error?) throws {
        var errorComponents = lastError.map(default: []) {
            ["nested error: \($0)"]
        }
        
        // Last resort (for iOS 14, because it works fine on previous iOS versions without it,
        // and we don't want it to fail silently on previously fine iOS versions):
        if iosVersionProvider.iosVersion().majorVersion >= 14 {
            let error = uiAccessibilityAccessibilityInitializer.initializeAccessibilityOrReturnError()
            let status = accessibilityInitializationStatusProvider.accessibilityInitializationStatus
            let wrappedFallbackError: String
            
            switch (status, error) {
            case (.initialized, _):
                // Ok!
                return
            case (.notInitialized, let error?):
                wrappedFallbackError = "fallback with UIAccessibility.framework also failed: \(error)"
            case (.notInitialized, nil):
                wrappedFallbackError = "fallback with UIAccessibility.framework also failed (but returned no error)"
            }
            
            errorComponents.append(wrappedFallbackError)
        }
        
        throw ErrorString(
            "Failed to enable AX: \(errorComponents.joined(separator: ", "))"
        )
    }
}

#endif
