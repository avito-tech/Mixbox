// https://github.com/allure-framework/allure2/blob/master/allure-plugin-api/src/main/java/io/qameta/allure/entity/LabelName.java

public enum AllureLabelName: String, Encodable {
    case owner
    case severity
    case issue
    case tag
    case testType
    case parentSuite
    case suite
    case subSuite
    case package
    case epic
    case feature
    case story
    case testClass
    case testMethod
    case host
    case thread
    case language
    case framework
    case resultFormat
}
