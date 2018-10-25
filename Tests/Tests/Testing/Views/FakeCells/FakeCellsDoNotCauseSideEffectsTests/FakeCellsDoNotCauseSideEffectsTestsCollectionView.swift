import UIKit

class FakeCellsDoNotCauseSideEffectsTestsCollectionView:
    UICollectionView,
    UICollectionViewDelegate,
    UICollectionViewDataSource
{
    enum CellConfigurationTime {
        case cellForItemAt
        case willDisplayCell
    }
    
    private let cellConfigurationTime: CellConfigurationTime
    private let onConfigure: (UICollectionViewCell) -> ()
    
    init(cellConfigurationTime: CellConfigurationTime, onConfigure: @escaping (UICollectionViewCell) -> ()) {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        layout.sectionInset = .zero
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width, height: 50)
        
        self.cellConfigurationTime = cellConfigurationTime
        self.onConfigure = onConfigure
        
        super.init(frame: .zero, collectionViewLayout: layout)
        
        dataSource = self
        delegate = self
        
        register(SingleViewCell<UILabel>.self, forCellWithReuseIdentifier: "cell")
        
        backgroundColor = .white
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UICollectionViewDelegate / UICollectionViewDataSource
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath)
        -> UICollectionViewCell
    {
        let cell: SingleViewCell<UILabel>
        
        let untypedCell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        
        if let typedCell = untypedCell as? SingleViewCell<UILabel> {
            cell = typedCell
        } else {
            return untypedCell
        }
        
        if cell.mb_isFakeCell() {
            cell.mb_configureAsFakeCell = { [weak self, weak cell] in
                if let cell = cell {
                    self?.configure(cell: cell)
                }
            }
        } else {
            if cellConfigurationTime == .cellForItemAt {
                configure(cell: cell)
            }
        }
            
        return cell
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        willDisplay cell: UICollectionViewCell,
        forItemAt indexPath: IndexPath)
    {
        guard let cell = cell as? SingleViewCell<UILabel> else {
            assertionFailure("Wrong type of cell")
            return
        }
        
        if cellConfigurationTime == .willDisplayCell {
            configure(cell: cell)
        }
    }
    
    func configure(cell: SingleViewCell<UILabel>) {
        onConfigure(cell)
        cell.view.text = "\(ObjectIdentifier(cell))"
    }
}
