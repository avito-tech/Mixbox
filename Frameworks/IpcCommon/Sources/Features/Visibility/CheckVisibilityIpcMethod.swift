#if MIXBOX_ENABLE_FRAMEWORK_IPC_COMMON && MIXBOX_DISABLE_FRAMEWORK_IPC_COMMON
#error("IpcCommon is marked as both enabled and disabled, choose one of the flags")
#elseif MIXBOX_DISABLE_FRAMEWORK_IPC_COMMON || (!MIXBOX_ENABLE_ALL_FRAMEWORKS && !MIXBOX_ENABLE_FRAMEWORK_IPC_COMMON)
// The compilation is disabled
#else

import MixboxIpc
import Foundation
import MixboxFoundation

// Checks visibility of a UIView (per-pixel) or tries to approximately determine if element is
// visible if it is not UIView.
public final class CheckVisibilityIpcMethod: IpcMethod {
    public final class _Arguments: Codable {
        public let elementUniqueIdentifier: String
        public let interactionCoordinates: InteractionCoordinates?
        public let useHundredPercentAccuracy: Bool
        
        public init(
            elementUniqueIdentifier: String,
            interactionCoordinates: InteractionCoordinates?,
            useHundredPercentAccuracy: Bool)
        {
            self.elementUniqueIdentifier = elementUniqueIdentifier
            self.interactionCoordinates = interactionCoordinates
            self.useHundredPercentAccuracy = useHundredPercentAccuracy
        }
    }
    
    public enum _ReturnValue: Codable {
        case view(ViewVisibilityResult)
        case nonView(NonViewVisibilityResult)
        case error(ErrorString)

        private enum CodingKeys: String, CodingKey {
            case type
            case value
        }
        
        private enum ValueType: String, Codable {
            case view
            case nonView
            case error
        }
        
        public func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            
            switch self {
            case .view(let nested):
                try container.encode(ValueType.view, forKey: CodingKeys.type)
                try container.encode(nested, forKey: CodingKeys.value)
            case .nonView(let nested):
                try container.encode(ValueType.nonView, forKey: CodingKeys.type)
                try container.encode(nested, forKey: CodingKeys.value)
            case .error(let nested):
                try container.encode(ValueType.error, forKey: CodingKeys.type)
                try container.encode(nested, forKey: CodingKeys.value)
            }
        }
        
        public init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            let type = try container.decode(ValueType.self, forKey: .type)
            
            switch type {
            case .view:
                let nested = try container.decode(ViewVisibilityResult.self, forKey: CodingKeys.value)
                self = .view(nested)
            case .nonView:
                let nested = try container.decode(NonViewVisibilityResult.self, forKey: CodingKeys.value)
                self = .nonView(nested)
            case .error:
                let nested = try container.decode(ErrorString.self, forKey: CodingKeys.value)
                self = .error(nested)
            }
        }
    }
    
    public final class ViewVisibilityResult: Codable {
        // `percentageOfVisibleArea` for view with specified `elementUniqueIdentifier`
        public let percentageOfVisibleArea: CGFloat
        
        // Guaranteed to be not nil if `interactionCoordinates` are passed.
        public let visibilePointOnScreenClosestToInteractionCoordinates: CGPoint?
        
        public init(
            percentageOfVisibleArea: CGFloat,
            visibilePointOnScreenClosestToInteractionCoordinates: CGPoint?)
        {
            self.percentageOfVisibleArea = percentageOfVisibleArea
            self.visibilePointOnScreenClosestToInteractionCoordinates = visibilePointOnScreenClosestToInteractionCoordinates
        }
    }
    
    public final class NonViewVisibilityResult: Codable {
        // `percentageOfVisibleArea` for view with specified `elementUniqueIdentifier`
        public let percentageOfVisibleArea: CGFloat
        
        public init(
            percentageOfVisibleArea: CGFloat)
        {
            self.percentageOfVisibleArea = percentageOfVisibleArea
        }
    }
    
    public typealias Arguments = _Arguments
    public typealias ReturnValue = _ReturnValue
    
    public init() {
    }
}

#endif
