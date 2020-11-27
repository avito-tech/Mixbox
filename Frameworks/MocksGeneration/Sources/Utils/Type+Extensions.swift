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
// However, it's not certain whether there aren't any bugs in Sourcery/SourceKit,
// additional check might help. This code was added on 2020.11.21, you can remove
// it if you wish.
extension Protocol {
    var allMethodsToImplement: [Method] {
        let allMethodsDefinedInTypeDeclaration = self.allMethodsDefinedInTypeDeclaration
        let allMethodsDefinedToImplement = allMethodsDefinedInTypeDeclaration.filter {
            !$0.isFinal
        }
        
        if allMethodsDefinedInTypeDeclaration.count != allMethodsDefinedToImplement.count {
            preconditionFailure("Unexpected situation: detected final final in protocol")
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
