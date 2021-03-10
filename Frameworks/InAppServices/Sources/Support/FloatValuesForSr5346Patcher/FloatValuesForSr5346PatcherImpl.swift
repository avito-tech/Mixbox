#if MIXBOX_ENABLE_IN_APP_SERVICES

import UIKit
import MixboxUiKit

// Use this if values can be encoded and decoded. If not, consider using NoopFloatValuesForSr5346Patcher
public final class FloatValuesForSr5346PatcherImpl: FloatValuesForSr5346Patcher {
    private let shouldApplyPatch: Bool
    
    public init(iosVersionProvider: IosVersionProvider) {
        self.shouldApplyPatch = iosVersionProvider.iosVersion().majorVersion <= 10
    }
    
    // See https://bugs.swift.org/browse/SR-5346, it is a bug in JSONEncoder,
    // caused by a bug in NSGenericSerialization. Also see tests.
    public func patched(float: CGFloat) -> CGFloat {
        // Note that there is no actual boundary
        // E.g:
        // 1.79+142               : Wounds up as Nan after encodeing+decoding
        // 1.79769313486231e+142  : Wounds up as Nan after encodeing+decoding
        // 1.797693134862315e+142 : Works perfectly
        // 1.8+142                : Wounds up as Nan after encodeing+decoding
        //
        // Both encoding and decoding is flawed in JSONEncoder.
        //
        let maxValue = CGFloat(Float.greatestFiniteMagnitude)
        let minValue = CGFloat(-Float.greatestFiniteMagnitude)
        
        if float > maxValue {
            return maxValue
        } else if float < minValue {
            return minValue
        } else {
            return float
        }
    }
}

#endif
