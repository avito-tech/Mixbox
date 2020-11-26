// swiftlint:disable all

import Foundation

let knownImportsToIgnore = [
    "Foundation",
    "XCTest",
    "CryptoKit",
    "Dispatch",
]

// .product(name: "ArgumentParser", package: "swift-argument-parser")
let explicitlyIdentifiedPackages = [
    "SourceKittenFramework": "SourceKitten",
    "SourceryFramework": "Sourcery",
    "SourceryRuntime": "Sourcery"
]

let importStatementExpression = try NSRegularExpression(
    pattern: "^(@testable )?import ([a-zA-Z0-9_]+)$",
    options: [.anchorsMatchLines]
)

let moduleDescriptions: [ModuleDescription] = [
    try generate(
        moduleName: "MixboxMocksGeneration",
        path: "Frameworks/MocksGeneration/Sources",
        isTestTarget: false
    ),
    try generate(
        moduleName: "MixboxMocksGenerator",
        path: "MocksGenerator/Sources",
        isTestTarget: false
    )
]

func main() throws {
    var generatedTargetStatements = [String]()
    let sortedModuleDescriptions: [ModuleDescription] = moduleDescriptions.sorted { $0.name < $1.name }
    
    for moduleDescription in sortedModuleDescriptions {
        generatedTargetStatements.append(".\(!moduleDescription.isTest ? "target" : "testTarget")(")
        generatedTargetStatements.append("    // MARK: \(moduleDescription.name)")
        generatedTargetStatements.append("    name: " + "\"\(moduleDescription.name)\"" + ",")
        generatedTargetStatements.append("    dependencies: [")
        for dependency in moduleDescription.deps {
            if explicitlyIdentifiedPackages.keys.contains(dependency) {
                let package = explicitlyIdentifiedPackages[dependency]!
                generatedTargetStatements.append("        .product(name: \"\(dependency)\", package: \"\(package)\"),")
            } else {
                generatedTargetStatements.append("        \"\(dependency)\",")
            }
        }
        generatedTargetStatements.append("    ],")
        generatedTargetStatements.append("    path: " + "\"" + moduleDescription.path + "\"")
        generatedTargetStatements.append("),")
    }
    
    try generatePackageSwift(replacementForTargets: generatedTargetStatements)
}

func generate(moduleName: String, path: String, isTestTarget: Bool) throws -> ModuleDescription {
    let moduleFolderUrl = repoRoot().appendingPathComponent(path)
    
    guard directoryExists(url: moduleFolderUrl) else {
        throw ErrorString("Directory doesn't exist at \(moduleFolderUrl)")
    }
    
    let moduleEnumerator = FileManager().enumerator(
        at: moduleFolderUrl,
        includingPropertiesForKeys: [.isRegularFileKey],
        options: [.skipsHiddenFiles]
    )
    
    log("Analyzing \(moduleName) at \(moduleFolderUrl)")
    
    var importedModuleNames = Set<String>()
    
    while let moduleFile = moduleEnumerator?.nextObject() as? URL {
        if moduleFile.pathExtension != "swift" {
            log("    Skipping \(moduleFile.lastPathComponent): is not Swift file")
            continue
        }
        
        log("    Analyzing \(moduleFile.lastPathComponent)")
        
        guard try moduleFile.resourceValues(forKeys: [.isRegularFileKey]).isRegularFile == true else {
            log("    Skipping \(moduleFile.lastPathComponent): is not regular file")
            continue
        }
        
        let fileContents = try String(contentsOf: moduleFile)
            .split(separator: "\n")
            .filter { !$0.starts(with: "//") }

        for line in fileContents {
            let matches = importStatementExpression.matches(in: String(line), options: [], range: NSMakeRange(0, line.count))
            
            guard matches.count == 1 else {
                continue
            }
            
            let importedModuleName = (line as NSString).substring(with: matches[0].range(at: 2))
            importedModuleNames.insert(importedModuleName)
        }
    }

    importedModuleNames.remove(moduleName)
    
    let dependencies = importedModuleNames.filter { !knownImportsToIgnore.contains($0) }.sorted()
    
    return ModuleDescription(
        name: moduleName,
        deps: dependencies, 
        path: String(path),
        isTest: isTestTarget
    )
}

func generatePackageSwift(replacementForTargets: [String]) throws {
    log("Loading template")
    var templateContents = try String(contentsOf: URL(fileURLWithPath: "Package.template.swift"))
    
    templateContents = templateContents.replacingOccurrences(
        of: "<__TARGETS__>",
        with: replacementForTargets.map { "        \($0)" }.joined(separator: "\n")
    )
    
    templateContents = templateContents.replacingOccurrences(
        of: "<__SOURCERY_PACKAGE__>",
        with: sourceryPackage()
    )
    
    if ProcessInfo.processInfo.environment["MIXBOX_CI_IS_CI_BUILD"] != nil {
        log("Checking for Package.swift consistency")
        let existingContents = try String(contentsOf: URL(fileURLWithPath: "Package.swift"))
        if existingContents != templateContents {
            print("\(#file):\(#line): MIXBOX_CI_IS_CI_BUILD is set, and Package.swift differs. Please update and commit Package.swift!")
            exit(1)
        }
    }
    
    log("Saving Package.swift")
    try templateContents.write(to: URL(fileURLWithPath: "Package.swift"), atomically: true, encoding: .utf8)
}

// MARK: - Development dependencies support: Sourcery

func sourceryPackage() -> String {
    do {
        if ProcessInfo.processInfo.environment["SYNC_WITH_DEV_PODS"] != "true" {
            throw ErrorString("Development pods are disabled")
        }
        
        return """
        .package(name: "Sourcery", path: "\(try sourceryDevelopmentPath())")
        """
    } catch {
        return """
        .package(url: "https://github.com/avito-tech/Sourcery.git", .revision("4f311aca6c474ee93cac3186399089dc18fc12bd")),
        """
    }
}

func sourceryDevelopmentPath() throws -> String {
    return try developmentPodPath(
        podName: "Sourcery",
        podfileLockContents: mixboxPodfileLockContents()
    )
}

func repoRoot() -> URL {
    return URL(fileURLWithPath: #file, isDirectory: false)
        .deletingLastPathComponent()
}

func mixboxPodfileLockContents() throws -> String {
    
    let podfileLockPath = repoRoot()
        .appendingPathComponent("Tests")
        .appendingPathComponent("Podfile.lock")

    return try String(contentsOf: podfileLockPath)
}

// MARK: - Development dependencies support: Shared

func developmentPodPath(podName: String, podfileLockContents: String) throws -> String {
    return fixPathForSpm(
        path: try singleMatch(
            regex: "\(podName) \\(from `(.*?)`\\)",
            string: podfileLockContents,
            groupIndex: 1
        )
    )
}

// Without slash SPM fails with this error:
// error: the Package.resolved file is most likely severely out-of-date and is preventing correct resolution; delete the resolved file and try again
func fixPathForSpm(path: String) -> String {
    if path.hasSuffix("/") {
        return path
    } else {
        return "\(path)/"
    }
}

func singleMatch(regex: String, string: String, groupIndex: Int) throws -> String {
    let regex = try NSRegularExpression(pattern: regex)
    let results = regex.matches(
        in: string,
        range: NSRange(string.startIndex..., in: string)
    )
    
    guard let first = results.first, results.count == 1 else {
        throw ErrorString("Expected exactly one match") 
    }
    
    guard let range = Range(first.range(at: groupIndex), in: string) else {
        throw ErrorString("Failed to get range from match")
    }
    
    return String(string[range])
}

// MARK: - Models

struct ErrorString: Error, CustomStringConvertible {
    let description: String
    
    init(_ description: String) {
        self.description = description
    }
}

struct ModuleDescription {
    let name: String
    let deps: [String]
    let path: String
    let isTest: Bool
}

// MARK: - Utility

func log(_ text: String) {
    if ProcessInfo.processInfo.environment["DEBUG"] != nil {
        print(text)
    }
}

func directoryExists(url: URL) -> Bool {
    var isDirectory = ObjCBool(false)
    return FileManager().fileExists(atPath: url.path, isDirectory: &isDirectory) && isDirectory.boolValue
}

// MARK: - Main

try main()