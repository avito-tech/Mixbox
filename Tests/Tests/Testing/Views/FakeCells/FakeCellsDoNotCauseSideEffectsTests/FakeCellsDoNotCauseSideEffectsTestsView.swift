#if DEBUG

import UIKit

final class FakeCellsDoNotCauseSideEffectsTestsView: TestStackScrollView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let cellConfigurationTimes: [FakeCellsDoNotCauseSideEffectsTestsCollectionView.CellConfigurationTime] = [
            .cellForItemAt,
            .willDisplayCell
        ]
        
        for cellConfigurationTime in cellConfigurationTimes {
            let configurationId = "\(cellConfigurationTime)"
            
            // Cell will display its ObjectIdentifier.
            // realCellId will display it too.
            // fakeCellId will display that of a fake cell.
            //
            // Test will check that:
            //
            // cell.text == realCellId.text,
            // realCellId.text != fakeCellId.text,
            // realCellId.text is set,
            // fakeCellId.text is set
            //
            let fakeCellId = addLabel(id: "\(configurationId).fakeCellId") { label in
                label.text = ""
            }
            let realCellId = addLabel(id: "\(configurationId).realCellId") { label in
                label.text = ""
            }
            add(
                view: FakeCellsDoNotCauseSideEffectsTestsCollectionView(
                    cellConfigurationTime: cellConfigurationTime,
                    onConfigure: { cell in
                        if cell.mb_isFakeCell() {
                            fakeCellId.text = "\(ObjectIdentifier(cell))"
                        } else {
                            realCellId.text = "\(ObjectIdentifier(cell))"
                        }
                    }
                ),
                id: "\(cellConfigurationTime)"
            )
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

#endif
