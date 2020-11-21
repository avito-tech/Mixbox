import SourceryRuntime

extension Type {
    var allMethodsDefinedInTypeDeclaration: [Method] {
        allMethods.filter {
            if let definedInType = $0.definedInType {
                return !definedInType.isExtension
            } else {
                return false
            }
        }
    }
    
    var allVariablesDefinedInTypeDeclaration: [Variable] {
        allVariables.filter {
            if let definedInType = $0.definedInType {
                return !definedInType.isExtension
            } else {
                return false
            }
        }
    }
}

// All functons and properties declared in protocol are required to implement.
// However, we can check if it's true always for current code by using `preconditionFailure`.
// Anything might happen actually.
extension Protocol {
    var allMethodsToImplement: [Method] {
        let allMethodsDefinedInTypeDeclaration = self.allMethodsDefinedInTypeDeclaration
        let allMethodsDefinedToImplement = allMethodsDefinedInTypeDeclaration.filter {
            !$0.isFinal
        }
        
        if allMethodsDefinedInTypeDeclaration.count != allMethodsDefinedToImplement.count {
            preconditionFailure("Unexpected situation: detected final variables in protocol")
        }
        
        return allMethodsDefinedToImplement
    }
    
    var allVariablesToImplement: [Variable] {
        let allVariablesDefinedInTypeDeclaration = self.allVariablesDefinedInTypeDeclaration
        let allVariablesToImplement = allVariablesDefinedInTypeDeclaration.filter {
            !$0.isFinal
        }
        
        if allVariablesDefinedInTypeDeclaration.count != allVariablesToImplement.count {
            preconditionFailure("Unexpected situation: detected final variables in protocol")
        }
        
        return allVariablesToImplement
    }
}
