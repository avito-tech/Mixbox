import UIKit

final class ScrollTestsCollectionView:
    UICollectionView,
    UICollectionViewDelegate,
    UICollectionViewDataSource
{
    private class ContentCell: UICollectionViewCell {
        private let label = UILabel()
        
        override init(frame: CGRect) {
            label.textAlignment = .center
            super.init(frame: frame)
            
            addSubview(label)
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        override func layoutSubviews() {
            super.layoutSubviews()
            
            label.frame = bounds
        }
        
        func setViewData(id: String, text: String) {
            label.accessibilityIdentifier = id
            label.text = text
        }
    }
    
    init() {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        
        super.init(frame: .zero, collectionViewLayout: layout)
        
        dataSource = self
        delegate = self
        
        register(ContentCell.self, forCellWithReuseIdentifier: "content")
        register(UICollectionViewCell.self, forCellWithReuseIdentifier: "blank")
        
        backgroundColor = .white
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return ScrollTests.contentHeightInScreens
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath)
        -> UICollectionViewCell
    {
        func contentCell(
            id: String,
            text: String)
            -> UICollectionViewCell
        {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "content", for: indexPath)
            if let contentCell = cell as? ContentCell {
                contentCell.setViewData(id: id, text: text)
            }
            return cell
        }
        
        switch indexPath.row {
        case 0:
            return contentCell(id: ScrollTests.viewIds[0], text: ScrollTests.viewTexts[0])
        case (ScrollTests.contentHeightInScreens - 1) / 2:
            return contentCell(id: ScrollTests.viewIds[1], text: ScrollTests.viewTexts[1])
        case ScrollTests.contentHeightInScreens - 1:
            return contentCell(id: ScrollTests.viewIds[2], text: ScrollTests.viewTexts[2])
        default:
            return collectionView.dequeueReusableCell(withReuseIdentifier: "blank", for: indexPath)
        }
    }
}
