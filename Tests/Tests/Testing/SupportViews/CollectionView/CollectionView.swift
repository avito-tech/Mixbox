import UIKit

class CollectionView:
    UICollectionView,
    UICollectionViewDelegate,
    UICollectionViewDataSource
{
    private(set) var cellModels = [CellModel]()
    
    init(
        itemSize: CGSize,
        sectionInset: UIEdgeInsets = .zero)
    {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        layout.sectionInset = sectionInset
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width, height: FakeCellsTestsConstants.itemHeight)
        
        super.init(frame: .zero, collectionViewLayout: layout)
        
        dataSource = self
        delegate = self
        
        register(UICollectionViewCell.self, forCellWithReuseIdentifier: "blank")
        
        backgroundColor = .white
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func removeCells() {
        cellModels = []
    }
    
    func addCell<C: UICollectionViewCell>(_ updateFunction: @escaping (_ cell: C) -> ()) {
        let cellModel = GenericCellModel<C>(updateFunction: updateFunction)
        let cellClass = C.self
        register(cellClass, forCellWithReuseIdentifier: cellReuseIdentifier(cellClass: cellClass))
        cellModels.append(cellModel)
    }
    
    // MARK: - UICollectionViewDelegate / UICollectionViewDataSource
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cellModels.count
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath)
        -> UICollectionViewCell
    {
        guard let model = cellModels.mb_elementAtIndex(indexPath.row) else {
            return collectionView.dequeueReusableCell(withReuseIdentifier: "blank", for: indexPath)
        }
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: model.reuseIdentifier, for: indexPath)
        
        if cell.mb_isFakeCell() {
            cell.mb_configureAsFakeCell = { [weak cell] in
                if let cell = cell {
                    model.update(cell: cell)
                }
            }
        } else {
            model.update(cell: cell)
        }
        
        return cell
    }
}
