#if MIXBOX_ENABLE_IN_APP_SERVICES

import UIKit
import MixboxTestability_objc
// TODO: find a method that returns the type for XCUI and use it.

extension UIView {
    @objc override open func testabilityValue_elementType() -> TestabilityElementType {
        return .other
    }
}

extension UIWindow {
    @objc override open func testabilityValue_elementType() -> TestabilityElementType {
        return .window
    }
}

extension UIButton {
    @objc override open func testabilityValue_elementType() -> TestabilityElementType {
        return .button
    }
}

extension UITableView {
    @objc override open func testabilityValue_elementType() -> TestabilityElementType {
        return .table
    }
}

extension UITableViewCell {
    @objc override open func testabilityValue_elementType() -> TestabilityElementType {
        return .cell
    }
}

extension UITextField {
    @objc override open func testabilityValue_elementType() -> TestabilityElementType {
        return isSecureTextEntry ? .secureTextField : .textField
    }
}

extension UITextView {
    @objc override open func testabilityValue_elementType() -> TestabilityElementType {
        return .textView
    }
}

extension UIDatePicker {
    @objc override open func testabilityValue_elementType() -> TestabilityElementType {
        return .datePicker
    }
}

extension UICollectionView {
    @objc override open func testabilityValue_elementType() -> TestabilityElementType {
        return .collectionView
    }
}

extension UICollectionViewCell {
    @objc override open func testabilityValue_elementType() -> TestabilityElementType {
        return .cell
    }
}

extension UISlider {
    @objc override open func testabilityValue_elementType() -> TestabilityElementType {
        return .slider
    }
}

extension UILabel {
    @objc override open func testabilityValue_elementType() -> TestabilityElementType {
        return .staticText
    }
}

extension UIWebView {
    @objc override open func testabilityValue_elementType() -> TestabilityElementType {
        return .webView
    }
}

extension UIScrollView {
    @objc override open func testabilityValue_elementType() -> TestabilityElementType {
        return .scrollView
    }
}

extension UISearchBar {
    @objc override open func testabilityValue_elementType() -> TestabilityElementType {
        return .searchField
    }
}

extension UIPageControl {
    @objc override open func testabilityValue_elementType() -> TestabilityElementType {
        return .pageIndicator
    }
}

extension UISwitch {
    @objc override open func testabilityValue_elementType() -> TestabilityElementType {
        return .`switch`
    }
}

extension UIPickerView {
    @objc override open func testabilityValue_elementType() -> TestabilityElementType {
        return .picker
    }
}

extension UIImageView {
    @objc override open func testabilityValue_elementType() -> TestabilityElementType {
        return .image
    }
}

extension UIActivityIndicatorView {
    @objc override open func testabilityValue_elementType() -> TestabilityElementType {
        return .activityIndicator
    }
}

extension UIToolbar {
    @objc override open func testabilityValue_elementType() -> TestabilityElementType {
        return .toolbar
    }
}

extension UINavigationBar {
    @objc override open func testabilityValue_elementType() -> TestabilityElementType {
        return .navigationBar
    }
}

extension UIProgressView {
    @objc override open func testabilityValue_elementType() -> TestabilityElementType {
        return .progressIndicator
    }
}

extension UISegmentedControl {
    @objc override open func testabilityValue_elementType() -> TestabilityElementType {
        return .segmentedControl
    }
}

extension UIStepper {
    @objc override open func testabilityValue_elementType() -> TestabilityElementType {
        return .stepper
    }
}

/* Is not supported:
 alert
 application
 browser
 checkBox
 colorWell
 comboBox
 decrementArrow
 dialog
 disclosureTriangle
 dockItem
 drawer
 grid
 group
 handle
 helpTag
 icon
 incrementArrow
 key
 keyboard
 layoutArea
 layoutItem
 levelIndicator
 link
 map
 matte
 menu
 menuBar
 menuBarItem
 menuButton
 menuItem
 outline
 outlineRow
 pickerWheel
 popUpButton
 popover
 radioButton
 radioGroup
 ratingIndicator
 relevanceIndicator
 ruler
 rulerMarker
 scrollBar
 sheet
 splitGroup
 splitter
 statusBar
 statusItem
 tab
 tabBar
 tabGroup
 tableColumn
 tableRow
 timeline
 toggle
 toolbar
 toolbarButton
 touchBar
 valueIndicator
 */

#endif
