public final class ComparisonOperatorInfo<T: Comparable> {
    public let description: String
    public let comparisonOperator: (T, T) -> Bool
    public let isGreater: Bool
    
    public init(
        description: String,
        comparisonOperator: @escaping (T, T) -> Bool,
        isGreater: Bool
    ) {
        self.description = description
        self.comparisonOperator = comparisonOperator
        self.isGreater = isGreater
    }
    
    public static var greaterThan: ComparisonOperatorInfo {
        ComparisonOperatorInfo(
            description: "greater than",
            comparisonOperator: >,
            isGreater: true
        )
    }
    
    public static var greaterThanOrEqualTo: ComparisonOperatorInfo {
        ComparisonOperatorInfo(
            description: "greater than or equal to",
            comparisonOperator: >=,
            isGreater: true
        )
    }
    
    public static var lessThan: ComparisonOperatorInfo {
        ComparisonOperatorInfo(
            description: "less than",
            comparisonOperator: <,
            isGreater: false
        )
    }
    
    public static var lessThanOrEqualTo: ComparisonOperatorInfo {
        ComparisonOperatorInfo(
            description: "less than than or equal to",
            comparisonOperator: <=,
            isGreater: false
        )
    }
}
