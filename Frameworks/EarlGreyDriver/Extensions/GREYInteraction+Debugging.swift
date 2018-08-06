import EarlGrey

extension GREYInteraction {
    func underlyingElement() -> EarlGreyDisambiguatedInteractionResult<Any> {
        var element: Any?
        
        let action = GREYActionBlock.action(
            withName: "Retrieve underlying element",
            perform: { (localElement: Any?, _: UnsafeMutablePointer<NSError?>?) -> Bool in
                element = localElement
                
                return true // return `true` to avoid `EarlGrey`'s errors
            }
        )
        
        if let action = action {
            let result = performOnDisambiguatedInteraction(action: action)
            
            return result.mapSuccess { _ -> EarlGreyDisambiguatedInteractionResult<Any> in
                if let element = element {
                    return .success(element)
                } else {
                    assertionFailure("perform returned success, but element is nil")
                    return .otherError(NSError())
                }
            }
        } else {
            assertionFailure("TODO: handle optionality properly or make PR to EarlGrey with annotations for Obj-C")
            return .otherError(NSError())
        }
    }
    
    func printUnderlyingElement() {
        guard case .success(let element) = underlyingElement() else {
            print("can't get underlyingElement()")
            return
        }
        
        if let view = element as? UIView {
            print("view is \(view)")
            print("accessibilityIdentifier: \(view.accessibilityIdentifier as Any)")
            print("isAccessibilityElement: \(view.isAccessibilityElement)")
            print("isUserInteractionEnabled: \(view.isUserInteractionEnabled)")
            print("isHidden: \(view.isHidden)")
            print("backgroundColor: \(view.backgroundColor as Any)")
            
            if let control = view as? UIControl {
                print("isEnabled: \(control.isEnabled)")
                print("isHighlighted: \(control.isHighlighted)")
                print("isSelected: \(control.isSelected)")
                print("state: \(control.state)")
                
                if let button = control as? UIButton {
                    print("title: \(button.currentTitle ?? button.currentAttributedTitle as Any)")
                    print("image: \(button.currentImage as Any)")
                    print("backgroundImage: \(button.currentBackgroundImage as Any)")
                }
            }
            
            if let scrollView = view as? UIScrollView {
                print("contentSize: \(scrollView.contentSize)")
                print("bounds: \(scrollView.bounds)")
                print("contentOffset: \(scrollView.contentOffset)")
                print("contentInset: \(scrollView.contentInset)")
            }
            
            print("superviews:")
            var superviewI = view.superview
            while superviewI != nil {
                print(String(describing: superviewI))
                superviewI = superviewI?.superview
            }
            
            print("frame in window: \(view.convert(view.bounds, to: nil))")
        }
    }
}
