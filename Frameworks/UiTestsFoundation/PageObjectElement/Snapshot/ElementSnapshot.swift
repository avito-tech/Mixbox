public protocol ElementSnapshot: class, CustomDebugStringConvertible {
    // Common (can be retrieved via Apple's Accessibility feature):
    
    var frameOnScreen: CGRect { get }
    var elementType: ElementType? { get }
    var hasKeyboardFocus: Bool { get }
    var isEnabled: Bool { get }
    
    var accessibilityIdentifier: String { get }
    var accessibilityLabel: String { get }
    var accessibilityValue: Any? { get }
    var accessibilityPlaceholderValue: String? { get }
    
    var parent: ElementSnapshot? { get }
    var children: [ElementSnapshot] { get }
    
    var uikitClass: String? { get }
    var customClass: String? { get }
    
    // Mixbox specific (for apps with Mixbox support):
    
    var uniqueIdentifier: OptionalAvailability<String> { get }
    var isDefinitelyHidden: OptionalAvailability<Bool> { get }
    var text: OptionalAvailability<String?> { get }
    var customValues: OptionalAvailability<[String: String]> { get }
}

extension ElementSnapshot {
    // 1. Возвращает текст (из testabilityValue_text).
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
    public func text(fallback: @autoclosure () -> String?) -> String? {
        switch text {
        case .available(let text):
            if let nonNilText = text {
                return nonNilText
            } else {
                // НЕПРАВИЛЬНО!!! Если доступен нормальный текст, то надо вернуть именно его,
                // даже если он nil. Почему возвращаем fallback? Потому что тесты уже написаны на это поведение...
                // Текущие изменения слишком большие, чтобы изменить еще и это поведение. TODO: убрать это поведение.
                return fallback()
            }
        case .unavailable:
            return fallback()
        }
    }
    
    public var debugDescription: String {
        var fields = [String]()
        if let elementType = elementType {
            fields.append("elementType: \(elementType)")
        }
        fields.append("uniqueIdentifier: \(uniqueIdentifier)")
        fields.append("accessibilityIdentifier: \(accessibilityIdentifier)")
        fields.append("accessibilityLabel: \(accessibilityLabel)")
        if let placeholderValue = accessibilityPlaceholderValue {
            fields.append("placeholderValue: \(placeholderValue)")
        }
        if let value = accessibilityValue {
            fields.append("value: \(value)")
        }
        fields.append("isEnabled: \(isEnabled)")
        return fields.joined(separator: "\n")
    }
}
