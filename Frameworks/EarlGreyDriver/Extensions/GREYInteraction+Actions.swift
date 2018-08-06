import EarlGrey

extension GREYInteraction {
    @discardableResult
    func performSafeAction(_ action: GREYAction) -> GREYInteraction? {
        var error: NSError?
        
        let interaction = perform(action, error: &error)
        
        let actionSucceeded = (error == nil)
        
        return actionSucceeded
            ? interaction
            : nil 
    }
    
    @discardableResult
    func performAction(_ action: GREYAction) -> GREYInteraction {
        if let result = performSafeAction(action) {
            return result
        } else {            
            printUnderlyingElement()
            print("test will fail soon due to an unsupported interaction on the following element:")
            perform(action) // This line will invoke `EarlGrey`'s error handing
        }
        
        return self
    }
}
