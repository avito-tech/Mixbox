import UIKit
import MixboxGenerators

public final class NavigationBarCanBeFoundTestsViewConfiguration: Codable {
    public enum BarButtonItemAction: String, Codable, CaseIterable, DefaultGeneratorProvider {
        case pop
        case none
    }
    
    public final class BarButtonItem: Codable, InitializableWithFields {
        public let title: String
        public let action: BarButtonItemAction
        
        public init(
            title: String,
            action: BarButtonItemAction)
        {
            self.title = title
            self.action = action
        }
        
        public init(fields: Fields<BarButtonItem>) throws {
            title = try fields.title.get()
            action = try fields.action.get()
        }
    }
    
    public enum TestType: Codable {
        case defaultBackButton
        case customBackButton(BarButtonItem)
        case rightBarButtonItem(BarButtonItem)
        case rightBarButtonItems([BarButtonItem])
        
        private enum CodingKeys: String, CodingKey {
            case type
            case value
        }
        
        private enum ValueType: String, Codable {
            case defaultBackButton
            case customBackButton
            case rightBarButtonItem
            case rightBarButtonItems
        }
        
        public func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            
            switch self {
            case .defaultBackButton:
                try container.encode(ValueType.defaultBackButton, forKey: CodingKeys.type)
            case .customBackButton(let nested):
                try container.encode(ValueType.customBackButton, forKey: CodingKeys.type)
                try container.encode(nested, forKey: CodingKeys.value)
            case .rightBarButtonItem(let nested):
                try container.encode(ValueType.rightBarButtonItem, forKey: CodingKeys.type)
                try container.encode(nested, forKey: CodingKeys.value)
            case .rightBarButtonItems(let nested):
                try container.encode(ValueType.rightBarButtonItems, forKey: CodingKeys.type)
                try container.encode(nested, forKey: CodingKeys.value)
            }
        }
        
        public init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            let type = try container.decode(ValueType.self, forKey: .type)
            
            switch type {
            case .defaultBackButton:
                self = .defaultBackButton
            case .customBackButton:
                let nested = try container.decode(BarButtonItem.self, forKey: CodingKeys.value)
                self = .customBackButton(nested)
            case .rightBarButtonItem:
                let nested = try container.decode(BarButtonItem.self, forKey: CodingKeys.value)
                self = .rightBarButtonItem(nested)
            case .rightBarButtonItems:
                let nested = try container.decode([BarButtonItem].self, forKey: CodingKeys.value)
                self = .rightBarButtonItems(nested)
            }
        }
    }
    
    public let testType: TestType
    
    public init(
        testType: TestType)
    {
        self.testType = testType
    }
}
