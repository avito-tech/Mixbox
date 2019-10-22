import MixboxUiTestsFoundation

final class FakeCellsDoNotCrashAppTests: TestCase {
    override var reuseState: Bool {
        return false
    }
    
    func test() {
        openScreen(name: "FakeCellsDoNotCrashAppTestsView")
        
        // Fallback: visible cells are present in hierarchy
        pageObjects.screen.goodCell(index: 0).assertIsDisplayed()
        
        // Crashing fake cells are obviously not present in hierarchy
        pageObjects.screen.crashingCell(index: 0).withoutTimeout.assertIsNotDisplayed()
        pageObjects.screen.cellThatCrashesAtInit(index: 0).withoutTimeout.assertIsNotDisplayed()
    }
}

// The original problem:
//
// After months of running hundreds of tests we found a situation, where Fake Cells made app crash.
// I think that just suppressing crashes of app is not an ideal solution, because it can make checks for invisiblity
// return false positive results. However, we do not want to crash app when some code in which we are not interested
// crash in the situation that its developer wouldn't imagine (usage of fake cells and lots of swizzling).
//
// Options:
// - notify about exception
// - make list of ignored code, e.g. suppress any exception with UIKeyboardCandidateGridOverlayBackgroundViewAttributes in stacktrace
// - make list of not ignored code, e.g. always fail test if stacktrace contains code that is being tested (your code)
// - ...
//
// Printing description of exception:
// -[UIKeyboardCandidateGridOverlayBackgroundViewAttributes visualStyling]: unrecognized selector sent to instance 0x7ff6eb624220
//
// 0   CoreFoundation                      0x0000000117f0f1e6 __exceptionPreprocess + 294
// 1   libobjc.A.dylib                     0x0000000104bfc031 objc_exception_throw + 48
// 2   CoreFoundation                      0x0000000117f90784 -[NSObject(NSObject) doesNotRecognizeSelector:] + 132
// 3   CoreFoundation                      0x0000000117e91898 ___forwarding___ + 1432
// 4   CoreFoundation                      0x0000000117e91278 _CF_forwarding_prep_0 + 120
// 5   UIKit                               0x00000001149d9951 -[UIKeyboardCandidateGridCell applyLayoutAttributes:] + 98
// 6   UIKit                               0x0000000114b37352 -[UICollectionReusableView _setLayoutAttributes:] + 583
// 7   UIKit                               0x0000000114b38b14 -[UICollectionViewCell _setLayoutAttributes:] + 59
// 8   UIKit                               0x0000000114af9c32 -[UICollectionView _applyLayoutAttributes:toView:] + 186
// 9   UIKit                               0x0000000114b0edfb __88-[UICollectionView _dequeueReusableViewOfKind:withIdentifier:forIndexPath:viewCategory:]_block_invoke + 35
// 10  UIKit                               0x00000001140f5d7a +[UIView(Animation) performWithoutAnimation:] + 90
// 11  UIKit                               0x0000000114b0eb35 -[UICollectionView _dequeueReusableViewOfKind:withIdentifier:forIndexPath:viewCategory:] + 2028
// 12  UIKit                               0x000000013983959e -[UICollectionViewAccessibility _dequeueReusableViewOfKind:withIdentifier:forIndexPath:viewCategory:] + 660
// 13  UIKit                               0x0000000114b0ef82 -[UICollectionView dequeueReusableCellWithReuseIdentifier:forIndexPath:] + 169
// 14  UIKit                               0x000000011430d227 -[UIKeyboardCandidateGridCollectionViewController collectionView:cellForItemAtIndexPath:] + 233
// 15  MixboxInAppServices                 0x000000010ff3430e _T0So16UICollectionViewC19MixboxInAppServicesE27updateAccessibilityElements33_BEA1BC44F1D2DE8197E580DB6D905B13LLyyF + 1662
// 16  MixboxInAppServices                 0x000000010ff33c4e _T0So16UICollectionViewC19MixboxInAppServicesE010collectionB34Swizzler_accessibilityElementCount33_BEA1BC44F1D2DE8197E580DB6D905B13LLSiyF + 94
// 17  MixboxInAppServices                 0x000000010ff35395 _T0So6UIViewC19MixboxInAppServicesE57swizzled_CollectionViewSwizzler_accessibilityElementCount33_BEA1BC44F1D2DE8197E580DB6D905B13LLSiyF + 149
// 18  MixboxInAppServices                 0x000000010ff353f4 _T0So6UIViewC19MixboxInAppServicesE57swizzled_CollectionViewSwizzler_accessibilityElementCount33_BEA1BC44F1D2DE8197E580DB6D905B13LLSiyFTo + 36
// 19  UIAccessibility                     0x00000001354274e7 -[NSObject(AXPrivCategory) _accessibilityHasOrderedChildren] + 46
// 20  UIKit                               0x000000013983a905 -[UICollectionViewAccessibility _accessibilityHasOrderedChildren] + 63
// 21  UIAccessibility                     0x000000013543d526 -[NSObject(AXPrivCategory) _accessibilityFrameForSorting] + 29
// 22  UIAccessibility                     0x000000013543d5ab -[NSObject(AXPrivCategory) accessibilityCompareGeometry:] + 74
// 23  CoreFoundation                      0x0000000117e87ca7 __CFSimpleMergeSort + 71
// 24  CoreFoundation                      0x0000000117e87c1b CFSortIndexes + 811
// 25  CoreFoundation                      0x0000000117ea875e -[NSMutableArray sortRange:options:usingComparator:] + 462
// 26  CoreFoundation                      0x0000000117eba695 -[NSMutableArray sortUsingSelector:] + 165
// 27  UIKit                               0x000000013982712b -[UIViewAccessibility _accessibilityUserTestingChildren] + 301
// 28  UIAccessibility                     0x000000013543429e -[NSObject(AXPrivCategory) accessibilityAttributeValue:] + 6600
// 29  UIAccessibility                     0x000000013545c9c5 -[NSObject(UIAccessibilityAutomation) _accessibilityUserTestingSnapshotDescendantsWithAttributes:maxDepth:maxChildren:maxArrayCount:] + 2577
// 30  UIAccessibility                     0x000000013545e899 -[NSObject(UIAccessibilityAutomation) _accessibilityUserTestingSnapshotWithOptions:] + 830
// 31  UIAccessibility                     0x0000000135431a1c -[NSObject(AXPrivCategory) accessibilityAttributeValue:forParameter:] + 9492
// 32  UIAccessibility                     0x0000000135410030 _copyParameterizedAttributeValueCallback + 258
// 33  AXRuntime                           0x0000000135cae782 ___AXXMIGCopyParameterizedAttributeValue_block_invoke + 66
// 34  AXRuntime                           0x0000000135cadff5 _handleNonMainThreadCallback + 55
// 35  AXRuntime                           0x0000000135cae5f4 _AXXMIGCopyParameterizedAttributeValue + 312
// 36  AXRuntime                           0x0000000135ca8533 _XCopyParameterizedAttributeValue + 461
// 37  AXRuntime                           0x0000000135cbb410 mshMIGPerform + 247
// 38  CoreFoundation                      0x0000000117e9e3f9 __CFRUNLOOP_IS_CALLING_OUT_TO_A_SOURCE1_PERFORM_FUNCTION__ + 41
// 39  CoreFoundation                      0x0000000117e9e361 __CFRunLoopDoSource1 + 465
// 40  CoreFoundation                      0x0000000117e95f64 __CFRunLoopRun + 2532
// 41  CoreFoundation                      0x0000000117e9530b CFRunLoopRunSpecific + 635
// 42  GraphicsServices                    0x000000011b622a73 GSEventRunModal + 62
// 43  UIKit                               0x0000000114035267 UIApplicationMain + 159
// 44  LovelyApp                           0x0000000103ca64b9 main + 1689
// 45  libdyld.dylib                       0x0000000119483955 start + 1
// 46  ???                                 0x0000000000000019 0x0 + 25                               0x0000000000000019 0x0 + 25

private final class Screen: BasePageObjectWithDefaultInitializer {
    func goodCell(index: Int) -> ViewElement {
        return element("GoodCell") { element in
            element.id == "GoodCell" && element.customValues["index"] == index
        }
    }
    func crashingCell(index: Int) -> ViewElement {
        return element("CrashingCell") { element in
            element.id == "GoodCrashingCellCell" && element.customValues["index"] == index
        }
    }
    func cellThatCrashesAtInit(index: Int) -> ViewElement {
        return element("CellThatCrashesAtInit") { element in
            element.id == "CellThatCrashesAtInit" && element.customValues["index"] == index
        }
    }
}

private extension PageObjects {
    var screen: Screen {
        return apps.mainDefaultHierarchy.pageObject()
    }
}
