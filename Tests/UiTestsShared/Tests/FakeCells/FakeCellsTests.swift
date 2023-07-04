import MixboxUiTestsFoundation
import MixboxTestsFoundation
import MixboxUiKit
import XCTest
import TestsIpc

// This test check if "Fake Cells" mechanism works.
// This mechanism make all cells in collection view accessible by
// testing framework, even those that are not on screen and have
// no views in hierarchy. This test performs `assertIsDisplayed` checks
// on UI elements, those UI elements should have known frames,
// because they are provided by "Fake Cells" mechanism, which
// instantiate cells in memory based on collection view data source and delegate.
// The test scrolls in known direction and views become visible on screen.
// TODO: Test also UITableView.
final class FakeCellsTests: TestCase {
    override var reuseState: Bool {
        return false
    }
    
    override func precondition() {
        super.precondition()
        
        openScreen(name: "FakeCellsTestsView")
    }
    
    func test___this_test___is_configured_properly() {
        // If every element in test is visible on screen
        // then the test is not checking what it is supposed to check.
        
        // First element is visible.
        pageObjects.screen.element(id: firstCellSubviewId, set: 0)
            .withoutScrolling
            .assertIsDisplayed()
        
        // None of elements of last set is visible (initially)
        for id in allElementIds {
            pageObjects.screen.element(id: id, set: lastSetId)
                .withoutScrolling.withoutTimeout
                .assertIsNotDisplayed()
        }
    }
    
    func test___mixbox___can_access_every_invisible_element_in_collection_view___after_no_reload() {
        parameterized_test_ifEveryInvisibleElementCanBeAccessed(
            reloadType: nil,
            function: #function
        )
    }
    
    func test___mixbox___can_access_every_invisible_element_in_collection_view___after_reloadData() {
        parameterized_test_ifEveryInvisibleElementCanBeAccessed(
            reloadType: .reloadData,
            function: #function
        )
    }
    
    func test___mixbox___can_access_every_invisible_element_in_collection_view___after_performBatchUpdates_using_reloadItems() {
        parameterized_test_ifEveryInvisibleElementCanBeAccessed(
            reloadType: .performBatchUpdates(.reloadItems),
            function: #function
        )
    }
    
    func test___mixbox___can_access_every_invisible_element_in_collection_view___after_performBatchUpdates_using_reconfigureItems() {
        // `reconfigureItems` is only available in iOS 15
        if iosVersionProvider.iosVersion() >= MixboxIosVersions.Supported.iOS15 {
            parameterized_test_ifEveryInvisibleElementCanBeAccessed(
                reloadType: .performBatchUpdates(.reconfigureItems),
                function: #function
            )
        }
    }
    
    func test___mixbox___can_access_every_invisible_element_in_collection_view___after_performBatchUpdates_using_deleteAndInsert() {
        parameterized_test_ifEveryInvisibleElementCanBeAccessed(
            reloadType: .performBatchUpdates(.deleteAndInsert),
            function: #function
        )
    }
    
    // Fake cells should not replace AX hierachy completely.
    // They should append it. Collection view can contain a regular manually inserted subviews (not via
    // UICollectionView interfaces, but via addSubview).
    func test_ifManuallyAddedSubviewsArePresentInHierarchy_nonCellSubviewOfCollectionView() {
        pageObjects.screen.element(id: "nonCellSubviewOfCollectionView").assertIsDisplayed()
    }
    
    // TODO: Fix this test!
    func disabled_test_ifManuallyAddedSubviewsArePresentInHierarchy_notFromDatasourceCellSubviewOfCollectionView() {
        pageObjects.screen.element(id: "notFromDatasourceCellSubviewOfCollectionView").assertIsDisplayed()
        pageObjects.screen.element(id: "notFromDatasourceCellSubviewOfCollectionViewSubview").assertIsDisplayed()
    }
    
    // How test should look like:
    // Scrolling down, scrolling up, it will seem that it is doing same thing multiple times.
    // What are "sets": a collection of cells. There are multiple duplicated collections to
    // make some of elements offscreen.
    func parameterized_test_ifEveryInvisibleElementCanBeAccessed(
        reloadType: FakeCellsReloadType?,
        function: StaticString)
    {
        var generation = 0
        
        var elementToScrollToToHideTargetElement: ViewElement {
            return pageObjects.screen.element(
                id: firstCellSubviewId,
                set: 0,
                generation: generation
            )
        }
        
        // Wait with timout (later timeouts will be disabled)
        elementToScrollToToHideTargetElement.assertIsDisplayed()
        
        let patchedAllElementIds: [ElementId]
        if reloadType == nil {
            patchedAllElementIds = allElementIds
        } else {
            // Prepend array of checked elements with extra 1 element,
            // because without it we may not found failure when working with first element
            // of original allElementIds array.
            patchedAllElementIds = [allElementIds.last].compactMap { $0 } + allElementIds
        }
        
        let applicationFrameProvider: ApplicationFrameProvider = dependencies.resolve()
        let screenHeight = applicationFrameProvider.applicationFrame.size.height
        
        for id in patchedAllElementIds {
            logBlock(text: "Checking \(id)") {
                // isDisplayed triggers scrolling. We need to hide last element.
                // TODO: Add some scrolling function
                elementToScrollToToHideTargetElement.withoutTimeout.assertIsDisplayed()
                
                reloadCells(generation: &generation, reloadType: reloadType)
                
                let targetElement = pageObjects.screen.element(id: id, set: lastSetId, generation: generation)
                
                // Check if previous action had effect
                targetElement.withoutScrolling.withoutTimeout.assertIsNotDisplayed()
                
                // Target check: we should be able to find any view in a cell that is not displayed / exists in view hierarchy
                targetElement.withoutTimeout.assertIsDisplayed()
                
                reloadCells(generation: &generation, reloadType: reloadType)
                
                checkCountOfSubviews(
                    generation: generation,
                    screenHeight: screenHeight,
                    function: function
                )
            }
        }
    }
    
    // It is easy to mess up with real hierarchy (and there was a bug with tons of visible views in real hierarchy after
    // several updates of a collection view).
    private func checkCountOfSubviews(
        generation: Int,
        screenHeight: CGFloat,
        function: StaticString)
    {
        // Lower boundary of count of subviews
        // +- --+
        // |  #1|
        // |  --+
        // |  #2|
        // +- --+
        let minimumVisibleCells = max(
            1,
            Int(ceil(screenHeight / FakeCellsTestsConstants.itemHeight))
        )
        let minimumVisibleViews = minimumVisibleCells
            + FakeCellsTestsConstants.customSubviewsCount
        
        // Upper boundary of count of subviews
        //    --+
        //    #1|
        //    --+
        // +- #2|
        // |  --+
        // |  #3|
        // |  --+
        // +- #4|
        //    --+
        //    #5|
        //    --+
        
        // e.g. [#2,#3,#4].count == 3 in the example above, while screen height is 2 and cell height is 1.
        let extraCellsForSpecificContentOffsets = 1
        
        // #1 and #5 in the example above
        let someArbitraryValueOfHowManyCellsOfCollectionViewCanBePresentedInHiererchy = 6
        
        let maximumVisibleViews = minimumVisibleViews
            + extraCellsForSpecificContentOffsets
            + someArbitraryValueOfHowManyCellsOfCollectionViewCanBePresentedInHiererchy
        
        let subviewInfos = self.subviewInfos()
        let countOfVisibleSubviews = subviewInfos.filter { !$0.isHidden }.count
        
        XCTAssert(
            countOfVisibleSubviews >= minimumVisibleViews && countOfVisibleSubviews <= maximumVisibleViews,
            "\(function): At generation \(generation) countOfVisibleSubviews is \(countOfVisibleSubviews)"
                + " while it was expected to be in range of \(minimumVisibleViews)...\(maximumVisibleViews)"
        )
        
        let idsOfVisibleCellsOfPreviousGenerations = subviewInfos
            .filter { !$0.isHidden }
            .compactMap { $0.accessibilityIdentifier }
            .filter { $0.contains("cell-gen") && !$0.hasSuffix("cell-gen\(generation)") }
        
        XCTAssert(
            idsOfVisibleCellsOfPreviousGenerations.isEmpty,
            "\(function): At generation \(generation) there are \(idsOfVisibleCellsOfPreviousGenerations.count) extra cells from previous generations: \(idsOfVisibleCellsOfPreviousGenerations)"
        )
        
        // CollectionView uses additional cells for animations
        let duplicationOfCellsDueToAnimations = 2
        let totalPossibleSubviewsIfThereWillBeNoReusageOfCells = FakeCellsTestsConstants.customSubviewsCount
            + FakeCellsTestsConstants.setsCount * FakeCellsTestsConstants.cellsInSetCount * duplicationOfCellsDueToAnimations
        
        XCTAssert(
            subviewInfos.count < totalPossibleSubviewsIfThereWillBeNoReusageOfCells,
            "\(function): At generation \(generation) total number of subviews in collection view (\(subviewInfos.count))"
            + " exceeds hypothetical upper limit (\(totalPossibleSubviewsIfThereWillBeNoReusageOfCells))."
            + " This can be a sign of leaked cells or other type of mess in UI hierarchy in the app due to support of fake cells"
        )
    }
    
    private func subviewInfos() -> [FakeCellsSubviewsInfoIpcMethod.SubviewInfo] {
        return synchronousIpcClient.callOrFail(
            method: FakeCellsSubviewsInfoIpcMethod()
        )
    }
    
    private func reloadCells(generation: inout Int, reloadType: FakeCellsReloadType?) {
        guard let reloadType = reloadType else {
            return
        }
        
        generation = synchronousIpcClient.callOrFail(
            method: FakeCellsReloadIpcMethod(),
            arguments: reloadType
        ).getReturnValueOrFail()
    }
}

// Just a shortcut
let lastSetId = FakeCellsTestsConstants.lastSetId

final class ElementId: CustomStringConvertible {
    let caseId: String
    let viewType: String
    let suffix: String?
    
    init(_ caseId: String, _ viewType: String, _ suffix: String? = nil) {
        self.caseId = caseId
        self.viewType = viewType
        self.suffix = suffix
    }
    
    var description: String {
        return [caseId, viewType, suffix].compactMap { $0 }.joined(separator: "-")
    }
}

// We need a subview of the cell to test an issue in iOS 10.
// We use fake cells to find element that is not a subview of a collection view (it is that for cells that
// are not displayed on the screen). Animations in collection view creates temporary cells, these temporary cells
// become hidden after an animation and remain hidden after they are put into reuse pool. When we create fake cell
// we use dequeue function of a collection view. And get hidden cells. Hidden cells do not contain any children in
// AX hierarchy in iOS 11. So we fake isHidden property for our fake cells via swizzling.
// So the tests also check if the fixed behavior is not broken and we need subview of the cell for that.
let firstCellSubviewId = ElementId("Alpha", "view")

let allElementIds: [ElementId] = [
    ElementId("Alpha", "cell"),
    firstCellSubviewId,

    ElementId("Beta", "cell"),

    ElementId("Gamma", "cell"),
    ElementId("Gamma", "view"),

    ElementId("Delta", "cell"),
    ElementId("Delta", "view", "0"),
    ElementId("Delta", "view", "1"),
    ElementId("Delta", "view", "2"),
    ElementId("Delta", "view", "3")
]

final class ScreenForFakeCellsTesting: BasePageObjectWithDefaultInitializer {
    func element(id: ElementId, set: Int, generation: Int = 0) -> ViewElement {
        let accessibilityId: String = FakeCellsTestsConstants.accessibilityId(
            id.caseId,
            id.viewType,
            set,
            id.suffix,
            generation
        )
        
        return element(accessibilityId) { element in
            element.id == accessibilityId
        }
    }
    
    func element(id: String) -> ViewElement {
        return element(id) { element in
            element.id == id
        }
    }
}

private extension PageObjects {
    var screen: ScreenForFakeCellsTesting {
        return pageObject()
    }
}
