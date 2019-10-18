import UIKit

extension UIButton {
    func setText(_ text: String?, isAttributed: Bool, state: UIControl.State) {
        if isAttributed {
            setAttributedTitle(text.flatMap { text in NSAttributedString(string: text) }, for: state)
        } else {
            setTitle(text, for: state)
        }
    }
}

final class TextTestsView: TestStackScrollView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        iterateTextVariants { text, isAttributed, elementName in
            addLabel(id: "label_\(elementName)") {
                if isAttributed {
                    $0.attributedText = text.flatMap { text in NSAttributedString(string: text) }
                } else {
                    $0.text = text
                }
            }
        }
        
        iterateTextVariants { text, isAttributed, elementName in
            addButton(id: "button_normal_\(elementName)") {
                $0.setText(text, isAttributed: isAttributed, state: .normal)
            }
        }
        iterateTextVariants { text, isAttributed, elementName in
            addButton(id: "button_disabled_\(elementName)") {
                $0.setTitle("Normal State Text", for: .normal)
                $0.setText(text, isAttributed: isAttributed, state: .disabled)
                $0.isEnabled = false
            }
        }
        iterateTextVariants { text, isAttributed, elementName in
            addButton(id: "button_selected_\(elementName)") {
                $0.setTitle("Normal State Text", for: .normal)
                $0.setText(text, isAttributed: isAttributed, state: .selected)
                $0.isSelected = true
            }
        }
        
        iterateTextVariants(nonEmptyText: "Текст") { text_t, isAttributed_t, elementName_t in
            iterateTextVariants(nonEmptyText: "Плейсхолдер") { text_p, isAttributed_p, elementName_p in
                addTextField(id: "textField_text:\(elementName_t)_placeholder:\(elementName_p)") {
                    if isAttributed_t {
                        $0.attributedText = text_t.flatMap { text in NSAttributedString(string: text) }
                    } else {
                        $0.text = text_t
                    }
                    if isAttributed_p {
                        $0.attributedPlaceholder = text_p.flatMap { text in NSAttributedString(string: text) }
                    } else {
                        $0.placeholder = text_p
                    }
                }
            }
        }
        
        iterateTextVariants { text, isAttributed, elementName in
            addTextView(id: "textView_\(elementName)") {
                if isAttributed {
                    $0.attributedText = text.flatMap { text in NSAttributedString(string: text) }
                } else {
                    $0.text = text
                }
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func iterateTextVariants(nonEmptyText: String = "Текст", _ closure: (_ text: String?, _ isAttributed: Bool, _ elementName: String) -> ()) {
        for isAttributed: Bool in [false, true] {
            for text: String? in [nil, "", nonEmptyText] {
                let isAttributedToElementName: String = (isAttributed ? "attributed" : "plain")
                let textToElementName: String = text.flatMap { $0.isEmpty ? "textIsEmpty" : "text==" + $0 }
                    ?? "textIsNil"
                
                let elementName =  "\(isAttributedToElementName)_\(textToElementName)"
                
                closure(text, isAttributed, elementName)
            }
        }
    }
}
