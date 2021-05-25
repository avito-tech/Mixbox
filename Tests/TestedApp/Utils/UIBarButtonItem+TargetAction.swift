import UIKit
import MixboxFoundation

extension UIBarButtonItem {
    convenience init(
        title: String?,
        style: UIBarButtonItem.Style,
        action: @escaping () -> ())
    {
        let targetAction = TargetAction(closure: action)
        
        self.init(
            title: title,
            style: style,
            target: targetAction.target,
            action: targetAction.action
        )
        
        // Just store it to prevent deallocation:
        self.targetAction.value = targetAction
    }
    
    private var targetAction: AssociatedObject<TargetAction> {
        return AssociatedObject(container: self, key: #function)
    }
}
