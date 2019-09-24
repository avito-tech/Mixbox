import UIKit
import MixboxUiKit

final class LocatorsPerformanceTestsView: UIView {
    final class RecursiveView: UIView {
        let views: [UIView]
        
        init(level: Int, path: [Int] = []) {
            if level > 0 {
                views = (0..<4).map { index in
                    RecursiveView(
                        level: level - 1,
                        path: path + [index]
                    )
                }
            } else {
                let colors: [UIColor] = [.red, .green, .blue, .yellow]
                views = colors.enumerated().map { index, color in
                    let label = UILabel()
                    
                    label.textAlignment = .center
                    label.font = .systemFont(ofSize: 4)
                    label.numberOfLines = 0
                    label.backgroundColor = color
                    
                    let id = (path + [index]).reduce(0) { accumulator, element in
                        accumulator * 4 + element
                    }
                    
                    let paragraphStyle = NSMutableParagraphStyle()
                    paragraphStyle.lineSpacing = 0
                    paragraphStyle.paragraphSpacing = 0
                    paragraphStyle.paragraphSpacingBefore = 0
                    paragraphStyle.lineBreakMode = .byCharWrapping
                    
                    label.attributedText = NSAttributedString(
                        string: String(format:"%X", id),
                        attributes: [
                            .paragraphStyle: paragraphStyle
                        ]
                    )
                    
                    return label
                }
            }
            
            super.init(frame: .zero)
            
            views.enumerated().forEach { index, view in
                addSubview(view)
                view.accessibilityIdentifier = "\(index)"
                view.clipsToBounds = false
            }
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        override func layoutSubviews() {
            super.layoutSubviews()
            
            for (index, view) in views.enumerated() {
                let normalizedOffset = CGVector(
                    dx: CGFloat(index % 2) / 2,
                    dy: CGFloat(index / 2) / 2
                )
                
                view.frame = CGRect(
                    origin: normalizedOffset * CGPoint(
                        x: bounds.width,
                        y: bounds.height
                    ),
                    size: bounds.size / 2
                )
            }
        }
    }
    
    private let recursiveView = RecursiveView(level: 5)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(recursiveView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        recursiveView.frame = bounds
    }
}
