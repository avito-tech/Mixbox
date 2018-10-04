import UIKit

final class FakeCellsDoNotCrashAppTestsView: CollectionView {
    @objc init() {
        super.init(
            itemSize: CGSize(
                width: UIScreen.main.bounds.width,
                height: FakeCellsTestsConstants.itemHeight
            ),
            sectionInset: UIEdgeInsets(
                top: 0,
                bottom: 0
            )
        )
        
        setUpCellModels()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpCellModels() {
        removeCells()
        
        // Visible cells:
        
        for i in 0..<100 {
            addCell { (cell: SingleViewCell<UILabel>) in
                cell.accessibilityIdentifier = "GoodCell"
                cell.testability_customValues["index"] = i
                
                cell.view.text = "I am a good cell. I do not crash apps."
                cell.view.backgroundColor = .green
            }
        }
        
        // Not visible cells:
        
        for i in 0..<100 {
            addCell { (cell: CrashingCell) in
                cell.accessibilityIdentifier = "CrashingCell"
                cell.testability_customValues["index"] = i
                
                cell.crashPlace = i
                cell.backgroundColor = .red
            }
        }
        
        for i in 0..<100 {
            addCell { (cell: CellThatCrashesAtInit) in
                cell.testability_customValues["index"] = i
                
                cell.accessibilityIdentifier = "CellThatCrashesAtInit"
                cell.backgroundColor = .red
            }
        }
    }
}


