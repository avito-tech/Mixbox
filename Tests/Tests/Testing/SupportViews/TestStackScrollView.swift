import UIKit

struct ViewAndLabel {
    let view: UIView
    let label: UILabel
}

class TestStackScrollView: UIScrollView {
    private var views = [ViewAndLabel]()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .white
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @discardableResult
    func addLabel(id: String, configure: (LabelWithClosures) -> ()) -> LabelWithClosures {
        let view = LabelWithClosures()
        view.textAlignment = .center
        view.textColor = .black
        view.font = UIFont.systemFont(ofSize: 17)
        configure(view)
        addView(view, id: id)
        return view
    }
    
    @discardableResult
    func addButton(id: String, configure: (ButtonWithClosures) -> ()) -> ButtonWithClosures {
        let view = ButtonWithClosures()
        view.setTitleColor(.black, for: .normal)
        view.titleLabel?.font = UIFont.systemFont(ofSize: 17)
        configure(view)
        addView(view, id: id)
        return view
    }
    
    @discardableResult
    func addButton(idAndText: String, configure: (ButtonWithClosures) -> ()) -> ButtonWithClosures {
        return addButton(id: idAndText) {
            $0.setTitle(idAndText, for: .normal)
            configure($0)
        }
    }
    
    @discardableResult
    func addTextField(id: String, configure: (TextFieldWithClosures) -> ()) -> TextFieldWithClosures {
        let view = TextFieldWithClosures()
        view.textColor = .black
        view.font = UIFont.systemFont(ofSize: 17)
        configure(view)
        addView(view, id: id)
        return view
    }
    
    @discardableResult
    func addTextView(id: String, configure: (TextViewWithClosures) -> ()) -> TextViewWithClosures {
        let view = TextViewWithClosures()
        view.textColor = .black
        view.font = UIFont.systemFont(ofSize: 17)
        configure(view)
        addView(view, id: id)
        return view
    }
    
    private func addView(_ view: UIView, id: String) {
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.lightGray.cgColor
        view.accessibilityIdentifier = id
        addSubview(view)
        
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 11)
        label.text = id
        label.textColor = UIColor.gray
        addSubview(label)
        
        views.append(ViewAndLabel(view: view, label: label))
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let viewHeight: CGFloat = 50
        let labelHeight: CGFloat = 20
        //            // Эта вьюшка используется в тестах на проверки и действия.
        //            // Вообще тесты на скролл должны быть отдельно от тестов на действия и чеки.
        //            // Но так как тестов мало, мы немного реюзаем тесты на чеки как тесты еще и на скролл.
        //            // Поэтому делаем большое расстояние между элементами:
        //            let spaceBeforeAndAfter: CGFloat = 400
        // FIXME
        
        let spaceBeforeAndAfter: CGFloat = 8
        
        contentSize = CGSize(
            width: frame.width,
            height: CGFloat(views.count) * (viewHeight + spaceBeforeAndAfter * 2 + labelHeight)
        )
        
        for (index, viewAndLabel) in views.enumerated() {
            let viewTop = CGFloat(index) * (viewHeight + spaceBeforeAndAfter * 2 + labelHeight) + spaceBeforeAndAfter
            viewAndLabel.view.frame = CGRect(
                left: bounds.mb_left,
                right: bounds.mb_right,
                top: viewTop,
                height: viewHeight
            )
            
            viewAndLabel.label.frame = CGRect(
                left: bounds.mb_left,
                right: bounds.mb_right,
                top: viewTop + viewHeight,
                height: labelHeight
            )
        }
    }
}
