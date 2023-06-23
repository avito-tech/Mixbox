import MixboxUiTestsFoundation
import MixboxFoundation
import MixboxInAppServices

public final class GrayTextTyper: TextTyper {
    private let keyboardPrivateApi: KeyboardPrivateApi
    
    public init(
        keyboardPrivateApi: KeyboardPrivateApi
    ) {
        self.keyboardPrivateApi = keyboardPrivateApi
    }
    
    public func type(instructions: [TextTyperInstruction]) throws {
        try instructions.forEach(type)
    }
    
    private func type(instruction: TextTyperInstruction) throws {
        switch instruction {
        case .text(let text):
            try type(text: text)
        case .key(let key):
            try type(key: key)
        }
    }
    
    private func type(text: String) throws {
        // The following line prevents text to be shifted if autoshift is enabled.
        // Note that autoshift is often enabled if text is empty.
        // How it looks without the line:
        // type(text: "foo") ===> "FOO" is typed (strangely all characters in text are uppercased).
        // This repoduced on iOS 12 and not on iOS 9/10/11.
        keyboardPrivateApi.set(shift: false, autoshift: false)
        
        keyboardPrivateApi.addInputString(text)
    }
    
    private func type(key: TextTyperKey) throws {
        switch key {
        case .delete:
            keyboardPrivateApi.deleteBackward()
        }
    }
}
