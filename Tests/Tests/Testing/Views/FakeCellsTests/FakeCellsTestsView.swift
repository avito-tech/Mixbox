import UIKit

final class FakeCellsTestsView:
    UICollectionView,
    UICollectionViewDelegate,
    UICollectionViewDataSource
{
    private var cellModels = [FakeCellModel]()
    private var generation: Int = -1
    
    private let nonCellSubviewOfCollectionView = UILabel()
    private let notFromDatasourceCellSubviewOfCollectionView = SingleViewCell<UILabel>()
    private let notFromDatasourceViewsHeight: CGFloat = FakeCellsTestsConstants.itemHeight
    
    init() {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        layout.sectionInset = UIEdgeInsets(
            top: notFromDatasourceViewsHeight,
            bottom: notFromDatasourceViewsHeight
        )
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width, height: FakeCellsTestsConstants.itemHeight)
        
        super.init(frame: .zero, collectionViewLayout: layout)
        
        nonCellSubviewOfCollectionView.backgroundColor = .purple
        nonCellSubviewOfCollectionView.text = "I'm added via addSubview"
        nonCellSubviewOfCollectionView.accessibilityIdentifier = "nonCellSubviewOfCollectionView"
        addSubview(nonCellSubviewOfCollectionView)
        
        notFromDatasourceCellSubviewOfCollectionView.backgroundColor = .purple
        notFromDatasourceCellSubviewOfCollectionView.accessibilityIdentifier = "notFromDatasourceCellSubviewOfCollectionView"
        notFromDatasourceCellSubviewOfCollectionView.view.accessibilityIdentifier = "notFromDatasourceCellSubviewOfCollectionViewSubview"
        notFromDatasourceCellSubviewOfCollectionView.view.text = "I'm added via addSubview"
        addSubview(notFromDatasourceCellSubviewOfCollectionView)
        
        dataSource = self
        delegate = self
        
        register(UICollectionViewCell.self, forCellWithReuseIdentifier: "blank")
        
        FakeCellsReloadIpcMethodHandler.instance.onHandle = { [weak self] type, completion in
            guard let strongSelf = self else {
                completion(0)
                assertionFailure("self is nil")
                return
            }
            
            strongSelf.regenerate(type: type, completion: completion)
        }
        
        FakeCellsSubviewsInfoIpcMethodHandler.instance.subviewsInfoGetter = { [weak self] in
            guard let strongSelf = self else {
                assertionFailure("self is nil")
                return []
            }
            
            return strongSelf.subviews.map {
                FakeCellsSubviewsInfoIpcMethod.SubviewInfo(
                    accessibilityIdentifier: $0.accessibilityIdentifier,
                    isHidden: $0.isHidden
                )
            }
        }
        
        setUpCellModels()
        
        backgroundColor = .white
    }
    
    private func regenerate(type: FakeCellsReloadType, completion: @escaping (Int) -> ()) {
        switch type {
        case .performBatchUpdates(let style):
            performBatchUpdates(
                {
                    setUpCellModels()
                    let indexPaths = cellModels.enumerated().map { IndexPath(item: $0.0, section: 0) }
                    
                    switch style {
                    case .reload:
                        reloadItems(at: indexPaths)
                    case .deleteAndInsert:
                        deleteItems(at: indexPaths)
                        insertItems(at: indexPaths)
                    }
                },
                completion: { _ in
                    completion(self.generation)
                }
            )
        case .reloadData:
            setUpCellModels()
            reloadData()
            completion(self.generation)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        nonCellSubviewOfCollectionView.frame = CGRect(
            left: bounds.mb_left,
            right: bounds.mb_right,
            top: 0,
            height: notFromDatasourceViewsHeight
        )
        notFromDatasourceCellSubviewOfCollectionView.frame = CGRect(
            left: bounds.mb_left,
            right: bounds.mb_right,
            bottom: contentSize.height,
            height: notFromDatasourceViewsHeight
        )
    }
    
    private func setUpCellModels() {
        cellModels = []
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
                    // because of ambigous locator. It should be ambigous if there are multiple same views.
                    // It can be a sign of an issue of this check for ambiguity. Or everything was fine and
                    // the view somehow wasn't shown in hierarchy or somehow locator was not ambigous.
                    // Anyway, ideally in that situation the framework could detect that something was wrong.
                    // It did it, but it detected that view is not visible, not that the locator is ambigous.
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
    
    private func addCell<C: UICollectionViewCell>(_ updateFunction: @escaping (_ cell: C) -> ()) {
        let cellModel = GenericFakeCellModel<C>(updateFunction: updateFunction)
        let cellClass = C.self
        register(cellClass, forCellWithReuseIdentifier: fakeCellReuseIdentifier(cellClass: cellClass))
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
        
        model.update(cell: cell)
        
        return cell
    }
}
