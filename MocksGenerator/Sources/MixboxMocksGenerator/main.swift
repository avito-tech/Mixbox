import MixboxMocksGeneration
import PathKit
import Foundation

do {
    let arguments = ProcessInfo.processInfo.arguments
    guard arguments.count >= 5 else {
        exit(1)
    }
    let moduleName = arguments[1]
    let destinationModuleName = arguments[2]
    let outputFile = arguments[3]
    let inputFiles = Array(arguments.suffix(from: 4))
    
    let parser = ModuleParserImpl(
        sourceFileParser: SourceFileParserImpl()
    )
    
    let parsedModule = try parser.parse(
        paths: inputFiles.map { Path($0) },
        moduleName: moduleName
    )
    
    let template = AllMocksTemplate(
        parsedModule: parsedModule,
        additionalModuleNamesForImporting: [],
        additionalTestableModuleNamesForImporting: [],
        destinationModuleName: destinationModuleName
    )
    
    try NSString(string: template.render()).write(
        toFile: outputFile,
        atomically: true,
        encoding: String.Encoding.utf8.rawValue
    )
} catch {
    print(error)
    exit(1)
}
