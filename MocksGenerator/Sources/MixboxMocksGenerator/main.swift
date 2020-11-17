import MixboxMocksGeneration
import PathKit
import Foundation

do {
    let arguments = ProcessInfo.processInfo.arguments
    guard arguments.count >= 4 else {
        exit(1)
    }
    let moduleName = arguments[1]
    let outputFile = arguments[2]
    let inputFiles = Array(arguments.suffix(from: 3))
    
    let parser = SourceFileParserImpl()
    
    let parsedSourceFiles = ParsedSourceFiles(
        sourceFiles: try inputFiles.map { file in
            try parser.parse(path: Path(file), moduleName: moduleName)
        }
    )
    
    let template = AllMocksTemplate(
        parsedSourceFiles: parsedSourceFiles
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
