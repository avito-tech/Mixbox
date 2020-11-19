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
    
    let parser = SourceFileParserImpl()
    
    let parsedSourceFiles = ParsedSourceFiles(
        sourceFiles: try inputFiles.map { file in
            try parser.parse(path: Path(file), moduleName: moduleName)
        }
    )
    
    let template = AllMocksTemplate(
        parsedSourceFiles: parsedSourceFiles,
        destinationModuleName: destinationModuleName
    )
    
    try NSString(string: try template.render()).write(
        toFile: outputFile,
        atomically: true,
        encoding: String.Encoding.utf8.rawValue
    )
} catch {
    print(error)
    exit(1)
}
