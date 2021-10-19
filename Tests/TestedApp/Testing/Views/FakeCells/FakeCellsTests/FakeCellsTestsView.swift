import UIKit
import TestsIpc
import MixboxIpcCommon
import MixboxFoundation

final class FakeCellsTestsView: CollectionView, TestingView {
    private var generation: Int = -1
    
    private let nonCellSubviewOfCollectionView = UILabel()
    private let notFromDatasourceCellSubviewOfCollectionView = SingleViewCell<UILabel>()
    private let notFromDatasourceViewsHeight: CGFloat = FakeCellsTestsConstants.itemHeight
    
    init(testingViewControllerSettings: TestingViewControllerSettings) {
        super.init(
            itemSize: CGSize(
                width: UIScreen.main.bounds.width,
                height: FakeCellsTestsConstants.itemHeight
            ),
            sectionInset: UIEdgeInsets.mb_init(
                top: notFromDatasourceViewsHeight,
                bottom: notFromDatasourceViewsHeight
            )
        )
        
        let viewIpc = testingViewControllerSettings.viewIpc
        
        nonCellSubviewOfCollectionView.backgroundColor = .purple
        nonCellSubviewOfCollectionView.text = "I'm added via addSubview (top)"
        nonCellSubviewOfCollectionView.accessibilityIdentifier = "nonCellSubviewOfCollectionView"
        addSubview(nonCellSubviewOfCollectionView)
        
        notFromDatasourceCellSubviewOfCollectionView.backgroundColor = .purple
        notFromDatasourceCellSubviewOfCollectionView.accessibilityIdentifier = "notFromDatasourceCellSubviewOfCollectionView"
        notFromDatasourceCellSubviewOfCollectionView.view.accessibilityIdentifier = "notFromDatasourceCellSubviewOfCollectionViewSubview"
        notFromDatasourceCellSubviewOfCollectionView.view.isAccessibilityElement = true
        notFromDatasourceCellSubviewOfCollectionView.view.text = "I'm added via addSubview (bottom)"
        addSubview(notFromDatasourceCellSubviewOfCollectionView)
        
        viewIpc.register(method: FakeCellsReloadIpcMethod()) { [weak self] type, completion in
            guard let strongSelf = self else {
                completion(
                    IpcThrowingFunctionResult.threw(ErrorString("self is nil"))
                )
                return
            }
            
            DispatchQueue.main.async {
                strongSelf.regenerate(type: type, completion: completion)
            }
        }
        
        viewIpc.register(method: FakeCellsSubviewsInfoIpcMethod()) { [weak self] _, completion in
            guard let strongSelf = self else {
                assertionFailure("self is nil")
                completion([])
                return
            }
            
            DispatchQueue.main.async {
                let subviewsInfo = strongSelf.subviews.map {
                    FakeCellsSubviewsInfoIpcMethod.SubviewInfo(
                        accessibilityIdentifier: $0.accessibilityIdentifier,
                        isHidden: $0.isHidden
                    )
                }
                completion(subviewsInfo)
            }
        }
        
        setUpCellModels()
    }
    
    private func regenerate(
        type: FakeCellsReloadType,
        completion: @escaping (IpcThrowingFunctionResult<Int>) -> ()
    ) {
        switch type {
        case .performBatchUpdates(let style):
            var error: ErrorString?
            performBatchUpdates(
                {
                    setUpCellModels()
                    let indexPaths = cellModels.enumerated().map { IndexPath(item: $0.0, section: 0) }
                    
                    switch style {
                    case .reloadItems:
                        reloadItems(at: indexPaths)
                    case .deleteAndInsert:
                        deleteItems(at: indexPaths)
                        insertItems(at: indexPaths)
                    case .reconfigureItems:
                        if #available(iOS 15.0, *) {
                            reconfigureItems(at: indexPaths)
                        } else {
                            error = ErrorString("reconfigureItems is unavaliable for current iOS")
                        }
                    }
                },
                completion: { _ in
                    if let error = error {
                        completion(IpcThrowingFunctionResult.threw(error))
                    } else {
                        completion(IpcThrowingFunctionResult.returned(self.generation))
                    }
                }
            )
        case .reloadData:
            setUpCellModels()
            reloadData()
            completion(IpcThrowingFunctionResult.returned(self.generation))
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        nonCellSubviewOfCollectionView.frame = CGRect.mb_init(
            left: bounds.mb_left,
            right: bounds.mb_right,
            top: 0,
            height: notFromDatasourceViewsHeight
        )
        
        notFromDatasourceCellSubviewOfCollectionView.frame = CGRect.mb_init(
            left: bounds.mb_left,
            right: bounds.mb_right,
            bottom: contentSize.height,
            height: notFromDatasourceViewsHeight
        )
    }
    
    // swiftlint:disable:next function_body_length
    private func setUpCellModels() {
        removeCells()
        
        generation += 1
        
        for setId in 0..<FakeCellsTestsConstants.setsCount {
            let generation = self.generation
            
            addCell { (cell: SingleViewCell<UILabel>) in
                let caseId = "Alpha"
                let cellId = FakeCellsTestsConstants.accessibilityId(caseId, "cell", setId, nil, generation)
                let viewId = FakeCellsTestsConstants.accessibilityId(caseId, "view", setId, nil, generation)
                
                cell.accessibilityIdentifier = cellId
                cell.view.accessibilityIdentifier = viewId
                cell.view.text = viewId
                cell.view.backgroundColor = .green
            }
            // No extra subviews
            addCell { (cell: UICollectionViewCell) in
                let caseId = "Beta"
                let cellId = FakeCellsTestsConstants.accessibilityId(caseId, "cell", setId, nil, generation)
                
                cell.accessibilityIdentifier = cellId
                cell.backgroundColor = .red
            }
            // Cell inside cell (why not?)
            addCell { (cell: SingleViewCell<SingleViewCell<UILabel>>) in
                let caseId = "Gamma"
                let cellId = FakeCellsTestsConstants.accessibilityId(caseId, "cell", setId, nil, generation)
                let viewId = FakeCellsTestsConstants.accessibilityId(caseId, "view", setId, nil, generation)
                
                cell.accessibilityIdentifier = cellId
                cell.view.view.accessibilityIdentifier = viewId
                cell.view.view.text = viewId
                cell.view.view.backgroundColor = .blue
            }
            // Cell with many views + UIStackView (it actually found a bug once)
            addCell { (cell: SingleViewCell<UIStackView>) in
                let caseId = "Delta"
                let cellId = FakeCellsTestsConstants.accessibilityId(caseId, "cell", setId, nil, generation)
                var viewInSetId = 0
                
                cell.accessibilityIdentifier = cellId
                cell.view.axis = .vertical
                cell.view.distribution = .fillEqually
                cell.view.arrangedSubviews.forEach {
                    // TODO: investigate a problem. I mistaken the API and used
                    //
                    // `cell.view.removeArrangedSubview($0)`
                    //
                    // instead of this code now:
                    //
                    $0.removeFromSuperview()
                    //
                    // and this cause some extra views in UIStackView. But resolving of element didn't fail
                    // because of ambiguous locator. It should be ambiguous if there are multiple same views.
                    // It can be a sign of an issue of this check for ambiguity. Or everything was fine and
                    // the view somehow wasn't shown in hierarchy or somehow locator was not ambiguous.
                    // Anyway, ideally in that situation the framework could detect that something was wrong.
                    // It did it, but it detected that view is not visible, not that the locator is ambiguous.
                    // It was kind of misleading.
                }
                
                (0..<2).forEach { _ in
                    let innerStackView = UIStackView(arrangedSubviews: (0..<2).map { _ in
                        let viewId = FakeCellsTestsConstants.accessibilityId(
                            caseId, "view", setId, "\(viewInSetId)", generation
                        )
                        let shadeOfYellow = UIColor(red: 1, green: 1 - (CGFloat(viewInSetId) / 8), blue: 0, alpha: 1)
                        
                        let label = UILabel()
                        label.text = viewId
                        label.accessibilityIdentifier = viewId
                        label.backgroundColor = shadeOfYellow
                        
                        viewInSetId += 1
                        
                        return label
                    })
                    
                    innerStackView.axis = .horizontal
                    innerStackView.distribution = .fillEqually
                    
                    cell.view.addArrangedSubview(innerStackView)
                }
            }
        }
    }
}
