#if MIXBOX_ENABLE_FRAMEWORK_IN_APP_SERVICES && MIXBOX_DISABLE_FRAMEWORK_IN_APP_SERVICES
#error("InAppServices is marked as both enabled and disabled, choose one of the flags")
#elseif MIXBOX_DISABLE_FRAMEWORK_IN_APP_SERVICES || (!MIXBOX_ENABLE_ALL_FRAMEWORKS && !MIXBOX_ENABLE_FRAMEWORK_IN_APP_SERVICES)
// The compilation is disabled
#else

import MixboxTestability
#if SWIFT_PACKAGE
import MixboxTestabilityObjc
#endif
import MixboxIpcCommon

public final class TestabilityElementTypeConverter {
    // swiftlint:disable:next cyclomatic_complexity function_body_length
    public static func convertToViewHierarchyElementType(
        elementType: TestabilityElementType)
        -> ViewHierarchyElementType
    {
        switch elementType {
        case .activityIndicator:
            return .activityIndicator
        case .alert:
            return .alert
        case .application:
            return .application
        case .browser:
            return .browser
        case .button:
            return .button
        case .cell:
            return .cell
        case .checkBox:
            return .checkBox
        case .collectionView:
            return .collectionView
        case .colorWell:
            return .colorWell
        case .comboBox:
            return .comboBox
        case .datePicker:
            return .datePicker
        case .decrementArrow:
            return .decrementArrow
        case .dialog:
            return .dialog
        case .disclosureTriangle:
            return .disclosureTriangle
        case .dockItem:
            return .dockItem
        case .drawer:
            return .drawer
        case .grid:
            return .grid
        case .group:
            return .group
        case .handle:
            return .handle
        case .helpTag:
            return .helpTag
        case .icon:
            return .icon
        case .image:
            return .image
        case .incrementArrow:
            return .incrementArrow
        case .key:
            return .key
        case .keyboard:
            return .keyboard
        case .layoutArea:
            return .layoutArea
        case .layoutItem:
            return .layoutItem
        case .levelIndicator:
            return .levelIndicator
        case .link:
            return .link
        case .map:
            return .map
        case .matte:
            return .matte
        case .menu:
            return .menu
        case .menuBar:
            return .menuBar
        case .menuBarItem:
            return .menuBarItem
        case .menuButton:
            return .menuButton
        case .menuItem:
            return .menuItem
        case .navigationBar:
            return .navigationBar
        case .other:
            return .other
        case .outline:
            return .outline
        case .outlineRow:
            return .outlineRow
        case .pageIndicator:
            return .pageIndicator
        case .picker:
            return .picker
        case .pickerWheel:
            return .pickerWheel
        case .popUpButton:
            return .popUpButton
        case .popover:
            return .popover
        case .progressIndicator:
            return .progressIndicator
        case .radioButton:
            return .radioButton
        case .radioGroup:
            return .radioGroup
        case .ratingIndicator:
            return .ratingIndicator
        case .relevanceIndicator:
            return .relevanceIndicator
        case .ruler:
            return .ruler
        case .rulerMarker:
            return .rulerMarker
        case .scrollBar:
            return .scrollBar
        case .scrollView:
            return .scrollView
        case .searchField:
            return .searchField
        case .secureTextField:
            return .secureTextField
        case .segmentedControl:
            return .segmentedControl
        case .sheet:
            return .sheet
        case .slider:
            return .slider
        case .splitGroup:
            return .splitGroup
        case .splitter:
            return .splitter
        case .staticText:
            return .staticText
        case .statusBar:
            return .statusBar
        case .statusItem:
            return .statusItem
        case .stepper:
            return .stepper
        case .`switch`:
            return .`switch`
        case .tab:
            return .tab
        case .tabBar:
            return .tabBar
        case .tabGroup:
            return .tabGroup
        case .table:
            return .table
        case .tableColumn:
            return .tableColumn
        case .tableRow:
            return .tableRow
        case .textField:
            return .textField
        case .textView:
            return .textView
        case .timeline:
            return .timeline
        case .toggle:
            return .toggle
        case .toolbar:
            return .toolbar
        case .toolbarButton:
            return .toolbarButton
        case .touchBar:
            return .touchBar
        case .valueIndicator:
            return .valueIndicator
        case .webView:
            return .webView
        case .window:
            return .window
        }
    }
}

#endif
