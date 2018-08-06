import MixboxIpcCommon
import MixboxIpcClients
import MixboxIpc
import MixboxUiKit
import MixboxUiTestsFoundation
import XCTest

extension ElementSnapshot {
    // 1. Возвращает текст (из testabilityVisibleText).
    // 2. Если не удалось, то берется fallback из аргумента, так как текст может быть либо
    // в label, либо в value в зависимости от контекста.
    //
    // Например, для удаления текста нажатием кнопки удаления символа столько же раз,
    // сколько символов в тексте, логично брать value, так как в UITextView/UITextField там лежит текст.
    //
    // Для валидации текста логичнее брать label, так как value - скорее исключение, чаще текст лежит в label.
    //
    // 3. Вместо nil возвращается пустая строка.
    //
    public func visibleText(fallback: @autoclosure () -> String?) -> String {
        if let visibleText = enhancedAccessibilityValue?.visibleText {
            return visibleText
        } else {
            return fallback() ?? ""
        }
    }
    
    public var uikitClass: String? {
        return additionalAttributes[5004 as NSObject] as? String
    }
    
    public var customClass: String? {
        return additionalAttributes[5041 as NSObject] as? String
    }
    
    public var center: XCUICoordinate {
        return XCUIApplication().tappableCoordinate(point: frame.mb_center)
    }
    
    public var originalAccessibilityValue: String? {
        if let enhancedAccessibilityValue = enhancedAccessibilityValue {
            return enhancedAccessibilityValue.originalAccessibilityValue
        } else {
            return value as? String
        }
    }
    
    public var isDefinitelyHidden: Bool {
        guard let enhancedAccessibilityValue = enhancedAccessibilityValue else {
            return false
        }
        return enhancedAccessibilityValue.isDefinitelyHidden
    }
    
    public var hostDefinedValues: [String: String] {
        guard let enhancedAccessibilityValue = enhancedAccessibilityValue else {
            return [:]
        }
        return enhancedAccessibilityValue.customValues
    }
    
    public func percentageOfVisibleArea(ipcClient: IpcClient) -> CGFloat? {
        guard let enhancedAccessibilityValue = enhancedAccessibilityValue else {
            return nil
        }
        
        let result = ipcClient.call(
            method: PercentageOfVisibleAreaIpcMethod(),
            arguments: enhancedAccessibilityValue.uniqueIdentifier
        )
            
        return result.data ?? .none
    }
}
