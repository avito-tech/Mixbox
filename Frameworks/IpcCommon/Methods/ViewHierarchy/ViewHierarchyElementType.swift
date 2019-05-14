// TODO: Do not use UInt. There is no reason to match XCUIElementType.
// It can produce errors if rawValue is used for conversion.
// Note that `debugDescription` can be removed after removing UInt as enum type.
// swiftlint:disable:next type_body_length
public enum ViewHierarchyElementType: UInt, Codable, CustomDebugStringConvertible {
    case other = 1
    case application
    case group
    case window
    case sheet
    case drawer
    case alert
    case dialog
    case button
    case radioButton
    case radioGroup
    case checkBox
    case disclosureTriangle
    case popUpButton
    case comboBox
    case menuButton
    case toolbarButton
    case popover
    case keyboard
    case key
    case navigationBar
    case tabBar
    case tabGroup
    case toolbar
    case statusBar
    case table
    case tableRow
    case tableColumn
    case outline
    case outlineRow
    case browser
    case collectionView
    case slider
    case pageIndicator
    case progressIndicator
    case activityIndicator
    case segmentedControl
    case picker
    case pickerWheel
    case `switch`
    case toggle
    case link
    case image
    case icon
    case searchField
    case scrollView
    case scrollBar
    case staticText
    case textField
    case secureTextField
    case datePicker
    case textView
    case menu
    case menuItem
    case menuBar
    case menuBarItem
    case map
    case webView
    case incrementArrow
    case decrementArrow
    case timeline
    case ratingIndicator
    case valueIndicator
    case splitGroup
    case splitter
    case relevanceIndicator
    case colorWell
    case helpTag
    case matte
    case dockItem
    case ruler
    case rulerMarker
    case grid
    case levelIndicator
    case cell
    case layoutArea
    case layoutItem
    case handle
    case stepper
    case tab
    case touchBar
    case statusItem
    
    public var debugDescription: String {
        switch self {
        case .other:
            return "other"
        case .application:
            return "application"
        case .group:
            return "group"
        case .window:
            return "window"
        case .sheet:
            return "sheet"
        case .drawer:
            return "drawer"
        case .alert:
            return "alert"
        case .dialog:
            return "dialog"
        case .button:
            return "button"
        case .radioButton:
            return "radioButton"
        case .radioGroup:
            return "radioGroup"
        case .checkBox:
            return "checkBox"
        case .disclosureTriangle:
            return "disclosureTriangle"
        case .popUpButton:
            return "popUpButton"
        case .comboBox:
            return "comboBox"
        case .menuButton:
            return "menuButton"
        case .toolbarButton:
            return "toolbarButton"
        case .popover:
            return "popover"
        case .keyboard:
            return "keyboard"
        case .key:
            return "key"
        case .navigationBar:
            return "navigationBar"
        case .tabBar:
            return "tabBar"
        case .tabGroup:
            return "tabGroup"
        case .toolbar:
            return "toolbar"
        case .statusBar:
            return "statusBar"
        case .table:
            return "table"
        case .tableRow:
            return "tableRow"
        case .tableColumn:
            return "tableColumn"
        case .outline:
            return "outline"
        case .outlineRow:
            return "outlineRow"
        case .browser:
            return "browser"
        case .collectionView:
            return "collectionView"
        case .slider:
            return "slider"
        case .pageIndicator:
            return "pageIndicator"
        case .progressIndicator:
            return "progressIndicator"
        case .activityIndicator:
            return "activityIndicator"
        case .segmentedControl:
            return "segmentedControl"
        case .picker:
            return "picker"
        case .pickerWheel:
            return "pickerWheel"
        case .`switch`:
            return "`switch`"
        case .toggle:
            return "toggle"
        case .link:
            return "link"
        case .image:
            return "image"
        case .icon:
            return "icon"
        case .searchField:
            return "searchField"
        case .scrollView:
            return "scrollView"
        case .scrollBar:
            return "scrollBar"
        case .staticText:
            return "staticText"
        case .textField:
            return "textField"
        case .secureTextField:
            return "secureTextField"
        case .datePicker:
            return "datePicker"
        case .textView:
            return "textView"
        case .menu:
            return "menu"
        case .menuItem:
            return "menuItem"
        case .menuBar:
            return "menuBar"
        case .menuBarItem:
            return "menuBarItem"
        case .map:
            return "map"
        case .webView:
            return "webView"
        case .incrementArrow:
            return "incrementArrow"
        case .decrementArrow:
            return "decrementArrow"
        case .timeline:
            return "timeline"
        case .ratingIndicator:
            return "ratingIndicator"
        case .valueIndicator:
            return "valueIndicator"
        case .splitGroup:
            return "splitGroup"
        case .splitter:
            return "splitter"
        case .relevanceIndicator:
            return "relevanceIndicator"
        case .colorWell:
            return "colorWell"
        case .helpTag:
            return "helpTag"
        case .matte:
            return "matte"
        case .dockItem:
            return "dockItem"
        case .ruler:
            return "ruler"
        case .rulerMarker:
            return "rulerMarker"
        case .grid:
            return "grid"
        case .levelIndicator:
            return "levelIndicator"
        case .cell:
            return "cell"
        case .layoutArea:
            return "layoutArea"
        case .layoutItem:
            return "layoutItem"
        case .handle:
            return "handle"
        case .stepper:
            return "stepper"
        case .tab:
            return "tab"
        case .touchBar:
            return "touchBar"
        case .statusItem:
            return "statusItem"
        }
    }
}
