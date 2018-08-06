import UIKit

// Easy way to store array of cell models for collection view,
// Suitable for testing tests, not suitable for real app.

protocol FakeCellModel {
    var cellClass: UICollectionViewCell.Type { get }
    func update(cell: UICollectionViewCell)
}

extension FakeCellModel {
    var reuseIdentifier: String {
        return fakeCellReuseIdentifier(cellClass: cellClass)
    }
}

// OOP is no my best
func fakeCellReuseIdentifier(cellClass: UICollectionViewCell.Type) -> String {
    return "\(cellClass)"
}

struct GenericFakeCellModel<T: UICollectionViewCell>: FakeCellModel {
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
