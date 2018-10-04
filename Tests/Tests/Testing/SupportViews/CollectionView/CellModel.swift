import UIKit

// Easy way to store array of cell models for collection view,
// Suitable for testing tests, not suitable for real app.

protocol CellModel {
    var cellClass: UICollectionViewCell.Type { get }
    func update(cell: UICollectionViewCell)
}

extension CellModel {
    var reuseIdentifier: String {
        return cellReuseIdentifier(cellClass: cellClass)
    }
}

// Not the best example of software architecture:
func cellReuseIdentifier(cellClass: UICollectionViewCell.Type) -> String {
    return "\(cellClass)"
}

struct GenericCellModel<T: UICollectionViewCell>: CellModel {
    let updateFunction: (T) -> ()
    
    var cellClass: UICollectionViewCell.Type {
        return T.self
    }
    
    func update(cell: UICollectionViewCell) {
        if let cell = cell as? T {
            updateFunction(cell)
        }
    }
}
