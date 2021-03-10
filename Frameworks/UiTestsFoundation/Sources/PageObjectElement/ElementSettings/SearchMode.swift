public enum ScrollMode: Equatable {
    // Scrolling is disabled.
    case none
    
    // Default scrolling mode.
    // Is used in cases when there is a definite answer to the following questions:
    //
    // 1. Is there a possibility to scroll to element?
    //    Element can be not present in hierarchy, have no size, be places to some inaccessible place.
    //
    // 2. Is there a necessity to scroll to element to check its appearance?
    //    Element can be hidden and thus scrolling will make no sense.
    //
    // 3. What are exact gestures for scrolling to the element?
    //
    case definite
    
    // In some rare cases scolling engine can not answer one of the questions about element.
    // For example, element is not present in UI, in datasources of collection or table view and the
    // only way to even answer the question about possibility to scroll to element is just try to scroll
    // in random directions to find it (it can appear in hierarchy after that or it is already in hierarchy but
    // gestures can not be calculated until it visually appears on screen).
    case blind
    
    public static let `default`: ScrollMode = .definite
}
