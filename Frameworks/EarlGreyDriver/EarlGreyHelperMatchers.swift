import EarlGrey
import UIKit
import MixboxUiTestsFoundation

// Matchers for internal needs

final class EarlGreyHelperMatchers {
    static func checkText(checker: @escaping (String) -> (Bool)) -> GREYMatcher {
        return GREYElementMatcherBlock(
            matchesBlock: { (element: Any?) -> Bool in
                if let labelText = (element as? UILabel)?.text {
                    return checker(labelText)
                }
                
                if let textFieldText = (element as? UITextField)?.text {
                    return checker(textFieldText)
                }
                
                if let textViewText = (element as? UITextView)?.text {
                    return checker(textViewText)
                }
                
                if let buttonText = (element as? UIButton)?.currentTitle {
                    return checker(buttonText)
                }
                
                return false
            },
            descriptionBlock: { (description: Any) in
                if let greyDescription = description as? GREYDescription {
                    greyDescription.appendText("Element should have a text")
                }
            }
        )
    }
    
    static func anySubviewCheckText(checker: @escaping (String) -> (Bool)) -> GREYMatcher {
        return GREYElementMatcherBlock(
            matchesBlock: { (element: Any?) -> Bool in
                guard let view = element as? UIView else {
                    return false
                }
                
                return view.checkTextInSubview(checker: checker)
            },
            descriptionBlock: { (description: Any) in
                if let greyDescription = description as? GREYDescription {
                    greyDescription.appendText("Element should have a text")
                }
            }
        )
    }
    
    static func isScrollViewSuitableForAutoScrolling() -> GREYMatcher {
        return grey_allOf(
            [   
                grey_not(isUndesirableForAutoscrollingScrollView()),
                grey_kindOfClass(UIScrollView.self),
                grey_interactable(),
                grey_minimumVisiblePercent(0.1)
            ]
        )
    }
    
    static func isUndesirableForAutoscrollingScrollView() -> GREYMatcher {
        // swiftlint:disable:next force_unwrapping
        let fieldEditorMatcher = grey_kindOfClass(NSClassFromString("UIFieldEditor")!)
        
        // TODO: resolve all possible ambiguities properly
        return fieldEditorMatcher
    }
    
    static func hasImage(_ image: UIImage) -> GREYMatcher {
        return hasImage(
            descriptionText: "ImageView should have the image",
            matchesBlock: { $0 == image }
        )
    }
    
    static func hasNoImage() -> GREYMatcher {
        return hasImage(
            descriptionText: "ImageView should not have an image",
            matchesBlock: { $0 == nil }
        )
    }
    
    static func hasAnyImage() -> GREYMatcher {
        return hasImage(
            descriptionText: "ImageView should have an image",
            matchesBlock: { $0 != nil }
        )
    }
    
    static func swipeToDirection(_ direction: SwipeDirection) -> GREYMatcher {
        return GREYElementMatcherBlock(
            matchesBlock: { (element: Any?) -> Bool in
                guard let scrollView = element as? UIScrollView else {
                    return false
                }
                
                scrollView.swipeToDirection(direction)
                
                return true
            },
            descriptionBlock: { (description: Any) in
                if let greyDescription = description as? GREYDescription {
                    greyDescription.appendText("Element should be scrollable")
                }
            }
        )
    }
    
    static func matchesReference(snapshot: String, in folder: StaticString, utility: SnapshotsComparisonUtility) -> GREYMatcher {
        var errorMessage = ""
        
        return GREYElementMatcherBlock(
            matchesBlock: { (element: Any?) -> Bool in
                guard let folderName = folder.description.split(separator: "/").last?.split(separator: ".").first else {
                    errorMessage = "Failed parse shaphot file path"
                    return false
                }

                guard let actual = GREYScreenshotUtil.snapshotElement(element) else {
                    errorMessage = "Failed create element shapshot"
                    return false
                }
                
                let result = utility.compare(actual: actual, folder: String(folderName), file: snapshot)
                
                switch result {
                case .passed:
                    return true
                case let .failed(message):
                    errorMessage = message
                    return false
                }
            },
            descriptionBlock: { (description: Any) in
                if let greyDescription = description as? GREYDescription {
                    greyDescription.appendText(errorMessage)
                }
            }
        )
    }
    
    // MARK: - Private
    private static func hasImage(descriptionText: String, matchesBlock: @escaping ((UIImage?) -> Bool)) -> GREYMatcher {
        return GREYElementMatcherBlock(
            matchesBlock: { (element: Any?) -> Bool in
                guard let imageView = element as? UIImageView else {
                    return false
                }
                return matchesBlock(imageView.image)
            },
            descriptionBlock: { (description: Any) in
                if let greyDescription = description as? GREYDescription {
                    greyDescription.appendText(descriptionText)
                }
            }
        )
    }
}

private extension UIView {
    func checkTextInSubview(checker: (String) -> (Bool)) -> Bool {
        for subview in subviews {
            if let labelText = (subview as? UILabel)?.text, checker(labelText) {
                return true
            }
            
            if let textFieldText = (subview as? UITextField)?.text, checker(textFieldText) {
                return true
            }
            
            if let textViewText = (subview as? UITextView)?.text, checker(textViewText) {
                return true
            }
            
            if let buttonText = (subview as? UIButton)?.currentTitle, checker(buttonText) {
                return true
            }
            
            if subview.checkTextInSubview(checker: checker) {
                return true
            }
            
        }
        return false
    }
}

private extension UIScrollView {
    func swipeToDirection(_ direction: SwipeDirection) {
        let dx: CGFloat = 300
        let dy: CGFloat = 500
        
        var currentContentOffset = self.contentOffset
        
        switch direction {
        case .up:
            currentContentOffset.y += dy
        case .down:
            currentContentOffset.y -= dy
        case .left:
            currentContentOffset.x += dx
        case .right:
            currentContentOffset.x -= dx
        }
        
        setContentOffset(currentContentOffset, animated: true)
    }
}
