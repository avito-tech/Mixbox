import MixboxFoundation
import UIKit

public final class ElementSettings {
    public struct CustomizedSettings {
        public var name: String
        public var matcher: ElementMatcher
        public var scrollMode: CustomizableScalar<ScrollMode>
        public var interactionTimeout: CustomizableScalar<TimeInterval>
        public var interactionMode: CustomizableScalar<InteractionMode>
        public var percentageOfVisibleArea: CustomizableScalar<CGFloat>
        public var pixelPerfectVisibilityCheck: CustomizableScalar<Bool>
    }
    
    // The priority increases from top to bottom:
    public let interactionSettingsDefaultsProvider: InteractionSettingsDefaultsProvider
    public let elementFactoryElementSettings: ElementFactoryElementSettings
    public let customizedSettings: CustomizedSettings
    
    // Non-customizeable settings:
    public let functionDeclarationLocation: FunctionDeclarationLocation
    
    // Settings not related to interaction
    
    public var name: String {
        return customizedSettings.name
    }
    
    public var matcher: ElementMatcher {
        return customizedSettings.matcher
    }
    
    // MARK: - Init
    
    public init(
        interactionSettingsDefaultsProvider: InteractionSettingsDefaultsProvider,
        elementFactoryElementSettings: ElementFactoryElementSettings,
        functionDeclarationLocation: FunctionDeclarationLocation,
        customizedSettings: CustomizedSettings)
    {
        self.interactionSettingsDefaultsProvider = interactionSettingsDefaultsProvider
        self.elementFactoryElementSettings = elementFactoryElementSettings
        self.functionDeclarationLocation = functionDeclarationLocation
        self.customizedSettings = customizedSettings
    }
    
    public convenience init(
        interactionSettingsDefaultsProvider: InteractionSettingsDefaultsProvider,
        elementFactoryElementSettings: ElementFactoryElementSettings,
        functionDeclarationLocation: FunctionDeclarationLocation,
        name: String,
        matcher: ElementMatcher)
    {
        self.init(
            interactionSettingsDefaultsProvider: interactionSettingsDefaultsProvider,
            elementFactoryElementSettings: elementFactoryElementSettings,
            functionDeclarationLocation: functionDeclarationLocation,
            customizedSettings: CustomizedSettings(
                name: name,
                matcher: matcher,
                scrollMode: .automatic,
                interactionTimeout: .automatic,
                interactionMode: .automatic,
                percentageOfVisibleArea: .automatic,
                pixelPerfectVisibilityCheck: .automatic
            )
        )
    }
    
    // MARK: -
    
    public var with: FieldBuilder<SubstructureFieldBuilderCallImplementation<ElementSettings, CustomizedSettings>> {
        return FieldBuilder(
            callImplementation: SubstructureFieldBuilderCallImplementation(
                structure: self,
                getSubstructure: { $0.customizedSettings },
                getResult: { structure, substructure in
                    structure.with(customizedSettings: substructure)
                }
            )
        )
    }
    
    public func with(customizedSettings: CustomizedSettings) -> ElementSettings {
        return ElementSettings(
            interactionSettingsDefaultsProvider: interactionSettingsDefaultsProvider,
            elementFactoryElementSettings: elementFactoryElementSettings,
            functionDeclarationLocation: functionDeclarationLocation,
            customizedSettings: customizedSettings
        )
    }
    
    public func interactionSettings(interaction: ElementInteraction) -> InteractionSettings {
        let interactionSettingsDefaults = interactionSettingsDefaultsProvider.interactionSettingsDefaults(
            interaction: interaction
        )
        
        return InteractionSettings(
            name: customizedSettings.name,
            matcher: customizedSettings.matcher,
            functionDeclarationLocation: functionDeclarationLocation,
            scrollMode: resolve(
                customizedSettings.scrollMode,
                elementFactoryElementSettings.scrollMode,
                interactionSettingsDefaults.scrollMode
            ),
            interactionTimeout: resolve(
                customizedSettings.interactionTimeout,
                elementFactoryElementSettings.interactionTimeout,
                interactionSettingsDefaults.interactionTimeout
            ),
            interactionMode: resolve(
                customizedSettings.interactionMode,
                elementFactoryElementSettings.interactionMode,
                interactionSettingsDefaults.interactionMode
            ),
            percentageOfVisibleArea: resolve(
                customizedSettings.percentageOfVisibleArea,
                elementFactoryElementSettings.percentageOfVisibleArea,
                interactionSettingsDefaults.percentageOfVisibleArea
            ),
            pixelPerfectVisibilityCheck: resolve(
                customizedSettings.pixelPerfectVisibilityCheck,
                elementFactoryElementSettings.pixelPerfectVisibilityCheck,
                interactionSettingsDefaults.pixelPerfectVisibilityCheck
            )
        )
    }
    
    private func resolve<T>(
        _ first: CustomizableScalar<T>,
        _ second: CustomizableScalar<T>,
        _ third: T)
        -> T
    {
        switch first {
        case .customized(let value):
            return value
        case .automatic:
            break
        }
        
        switch second {
        case .customized(let value):
            return value
        case .automatic:
            break
        }
        
        return third
    }
}
