import UIKit

struct ViewAndLabel {
    let view: UIView
    let label: UILabel
}

typealias AddViewHandler = (_ defaultConfig: () -> (), _ setId: () -> (), _ userConfig: () -> (), _ addSubview: () -> ()) -> ()

class TestStackScrollView: UIScrollView, UIGestureRecognizerDelegate {
    private var views = [ViewAndLabel]()
    
    var addViewHandler: AddViewHandler = defaultAddViewHandler()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .white
        
        panGestureRecognizer.delegate = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @discardableResult
    final func addLabel(id: String, configure: (LabelWithClosures) -> ()) -> LabelWithClosures {
        let view = LabelWithClosures()
        
        add(
            view: view,
            id: id,
            userConfig: {
                configure(view)
            },
            defaultConfig: {
                view.textAlignment = .center
                view.textColor = .black
                view.font = UIFont.systemFont(ofSize: 17)
            }
        )
        
        return view
    }
    
    @discardableResult
    final func addButton(id: String, configure: (ButtonWithClosures) -> ()) -> ButtonWithClosures {
        let view = ButtonWithClosures()
        
        add(
            view: view,
            id: id,
            userConfig: {
                configure(view)
            },
            defaultConfig: {
                view.setTitleColor(.black, for: .normal)
                view.titleLabel?.font = UIFont.systemFont(ofSize: 17)
            }
        )
        
        return view
    }
    
    @discardableResult
    final func addButton(idAndText: String, configure: (ButtonWithClosures) -> ()) -> ButtonWithClosures {
        return addButton(id: idAndText) {
            $0.setTitle(idAndText, for: .normal)
            configure($0)
        }
    }
    
    @discardableResult
    final func addTextField(id: String, configure: (TextFieldWithClosures) -> ()) -> TextFieldWithClosures {
        let view = TextFieldWithClosures()
        
        add(
            view: view,
            id: id,
            userConfig: {
                configure(view)
            },
            defaultConfig: {
                view.textColor = .black
                view.font = UIFont.systemFont(ofSize: 17)
            }
        )
        
        return view
    }
    
    @discardableResult
    final func addTextView(id: String, configure: (TextViewWithClosures) -> ()) -> TextViewWithClosures {
        let view = TextViewWithClosures()
        
        add(
            view: view,
            id: id,
            userConfig: {
                configure(view)
            },
            defaultConfig: {
                view.textColor = .black
                view.font = UIFont.systemFont(ofSize: 17)
            }
        )
        
        return view
    }
    
    final func add(
        view: UIView,
        id: String,
        userConfig: () -> (),
        defaultConfig: () -> ())
    {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 11)
        label.text = "id: \(id)"
        label.textColor = UIColor.gray
        addSubview(label)
        
        addViewHandler(
            {
                view.layer.borderWidth = 1
                view.layer.borderColor = UIColor.lightGray.cgColor
            },
            {
                view.accessibilityIdentifier = id
            },
            userConfig,
            {
                addSubview(view)
            }
        )
        
        views.append(ViewAndLabel(view: view, label: label))
    }
    
    final func removeAllViews() {
        for viewAndLabel in views {
            viewAndLabel.view.removeFromSuperview()
            viewAndLabel.label.removeFromSuperview()
        }
        views = []
    }
    
    final func defaultAddViewHandler() -> AddViewHandler {
        return TestStackScrollView.defaultAddViewHandler()
    }
    
    private static func defaultAddViewHandler() -> AddViewHandler {
        return { defaultConfig, setId, userConfig, addSubview in
            defaultConfig()
            setId()
            userConfig()
            addSubview()
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let viewHeight: CGFloat = 50
        let labelHeight: CGFloat = 20
        let spaceBeforeAndAfter: CGFloat = 8
        
        contentSize = CGSize(
            width: frame.width,
            height: CGFloat(views.count) * (viewHeight + spaceBeforeAndAfter * 2 + labelHeight)
        )
        
        for (index, viewAndLabel) in views.enumerated() {
            let viewTop = CGFloat(index) * (viewHeight + spaceBeforeAndAfter * 2 + labelHeight) + spaceBeforeAndAfter
            viewAndLabel.view.frame = CGRect.mb_init(
                left: bounds.mb_left,
                right: bounds.mb_right,
                top: viewTop,
                height: viewHeight
            )
            
            viewAndLabel.label.frame = CGRect.mb_init(
                left: bounds.mb_left,
                right: bounds.mb_right,
                top: viewTop + viewHeight,
                height: labelHeight
            )
        }
    }
    
    final func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
