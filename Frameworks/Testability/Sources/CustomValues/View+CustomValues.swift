import SwiftUI

#if MIXBOX_ENABLE_FRAMEWORK_TESTABILITY && MIXBOX_DISABLE_FRAMEWORK_TESTABILITY
#error("Testability is marked as both enabled and disabled, choose one of the flags")
#elseif MIXBOX_DISABLE_FRAMEWORK_TESTABILITY || (!MIXBOX_ENABLE_ALL_FRAMEWORKS && !MIXBOX_ENABLE_FRAMEWORK_TESTABILITY)

extension View {
    public func mb_testability_customValues(_ values: [String: Any]) -> some View {
        self
    }
}

#else

extension View {
    @ViewBuilder
    public func mb_testability_customValues(_ values: [String: Any]) -> some View {
        let serializedValues = values.mapValues { serialize($0) ?? "" }

        if #available(iOS 14.0, *), let string = serialize(serializedValues) {
            accessibilityHint(Text(string))
        } else {
            self
        }
    }

    private func serialize(_ value: Any) -> String? {
        guard
            let data = try? JSONSerialization.data(withJSONObject: value, options: [.fragmentsAllowed]),
            let string = String(data: data, encoding: .utf8)
        else {
            return nil
        }

        return string
    }
}

#endif
