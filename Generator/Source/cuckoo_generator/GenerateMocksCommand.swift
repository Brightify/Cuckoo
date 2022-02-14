//
//  GenerateMocksCommand.swift
//  CuckooGenerator
//
//  Created by Tadeas Kriz on 12/01/16.
//  Copyright © 2016 Brightify. All rights reserved.
//

import Commandant
import Result
import SourceKittenFramework
import FileKit
import CuckooGeneratorFramework
import Foundation

private func curry<P1, P2, P3, P4, P5, P6, P7, P8, P9, P10, P11, P12, R>
    (_ f: @escaping (P1, P2, P3, P4, P5, P6, P7, P8, P9, P10, P11, P12) -> R)
    -> (P1) -> (P2) -> (P3) -> (P4) -> (P5) -> (P6) -> (P7) -> (P8) -> (P9) -> (P10) -> (P11) -> (P12) -> R {
        return { p1 in { p2 in { p3 in { p4 in { p5 in { p6 in { p7 in { p8 in { p9 in { p10 in { p11 in { p12 in
            f(p1, p2, p3, p4, p5, p6, p7, p8, p9, p10, p11, p12)
        } } } } } } } } } } } }
}

public struct GenerateMocksCommand: CommandProtocol {

    public let verb = "generate"
    public let function = "Generates mock files"

    public func run(_ options: Options) -> Result<Void, CuckooGeneratorError> {
        let getFullPathSortedArray: ([String]) -> [String] = { stringArray in
            Array(Set(stringArray.map { Path($0).standardRawValue })).sorted()
        }
        let inputPathValues: [String]
        if options.globEnabled {
            inputPathValues = getFullPathSortedArray(options.files.flatMap { Glob(pattern: $0).paths })
        } else {
            inputPathValues = getFullPathSortedArray(options.files)
        }
        let inputFiles = inputPathValues.map { File(path: $0) }.compactMap { $0 }
        let tokens = inputFiles.map { Tokenizer(sourceFile: $0, debugMode: options.debugMode).tokenize() }
        let tokensWithInheritance = options.noInheritance ? tokens : mergeInheritance(tokens)

        // filter classes/protocols based on the settings passed to the generator
        var typeFilters = [] as [(Token) -> Bool]
        if options.noClassMocking {
            typeFilters.append(ignoreClasses)
        }
        if !options.regex.isEmpty {
            typeFilters.append(keepMatching(pattern: options.regex))
        }
        if !options.exclude.isEmpty {
            typeFilters.append(ignoreIfExists(in: options.exclude))
        }
        let parsedFiles = removeTypes(from: tokensWithInheritance, using: typeFilters)

        // generating headers and mocks
        let headers = parsedFiles.map { options.noHeader ? "" : FileHeaderHandler.getHeader(of: $0, includeTimestamp: !options.noTimestamp) }
        let imports = parsedFiles.map { FileHeaderHandler.getImports(of: $0, testableFrameworks: options.testableFrameworks) }
        let mocks = parsedFiles.map { try! Generator(file: $0).generate(debug: options.debugMode) }

        let mergedFiles = zip(zip(headers, imports), mocks).map { $0.0 + $0.1 + $1 }
        let outputPath = Path(options.output)

        do {
            if outputPath.isDirectory {
                let inputPaths = inputFiles.compactMap { $0.path }.map { Path($0) }
                for (inputPath, outputText) in zip(inputPaths, mergedFiles) {
                    let fileName = options.filePrefix + inputPath.fileName
                    let outputFile = TextFile(path: outputPath + fileName)
                    try outputText |> outputFile
                }
            } else {
                let outputFile = TextFile(path: outputPath)
                try mergedFiles.joined(separator: "\n") |> outputFile
            }
        } catch let error as FileKitError {
            return .failure(.ioError(error))
        } catch let error {
            return .failure(.unknownError(error))
        }

        return stderrUsed ? .failure(.stderrUsed) : .success(())
    }

    private func mergeInheritance(_ filesRepresentation: [FileRepresentation]) -> [FileRepresentation] {
        return filesRepresentation.compactMap { $0.mergeInheritance(with: filesRepresentation) }
    }

    private func removeTypes(from files: [FileRepresentation], using filters: [(Token) -> Bool]) -> [FileRepresentation] {
        // Only keep those that pass all filters
        let filter: (Token) -> Bool = { token in
            !filters.contains { !$0(token) }
        }

        return files.compactMap { file in
            let filteredDeclarations = file.declarations.filter(filter)
            guard !filteredDeclarations.isEmpty else { return nil }
            return FileRepresentation(sourceFile: file.sourceFile, declarations: filteredDeclarations)
        }
    }

    // filter that keeps the protocols while removing all classes
    private func ignoreClasses(token: Token) -> Bool {
        return !(token is ClassDeclaration)
    }

    // filter that keeps the classes/protocols that match the passed regular expression
    private func keepMatching(pattern: String) -> (Token) -> Bool {
        do {
            let regex = try NSRegularExpression(pattern: pattern, options: [])

            return { token in
                guard let containerToken = token as? ContainerToken else { return true }
                return regex.firstMatch(in: containerToken.name, options: [], range: NSMakeRange(0, containerToken.name.count)) != nil
            }
        } catch {
            fatalError("Invalid regular expression: " + (error as NSError).description)
        }
    }

    // filter that keeps only the classes/protocols that are not supposed to be excluded
    private func ignoreIfExists(in excluded: [String]) -> (Token) -> Bool {
        let excludedSet = Set(excluded)
        return { token in
            guard let containerToken = token as? ContainerToken else { return true }
            return !excludedSet.contains(containerToken.name)
        }
    }


    public struct Options: OptionsProtocol {
        let files: [String]
        let output: String
        let noHeader: Bool
        let noTimestamp: Bool
        let noInheritance: Bool
        let testableFrameworks: [String]
        let exclude: [String]
        let filePrefix: String
        let noClassMocking: Bool
        let debugMode: Bool
        let globEnabled: Bool
        let regex: String

        public init(output: String,
                    testableFrameworks: String,
                    exclude: String,
                    noHeader: Bool,
                    noTimestamp: Bool,
                    noInheritance: Bool,
                    filePrefix: String,
                    noClassMocking: Bool,
                    debugMode: Bool,
                    globEnabled: Bool,
                    regex: String,
                    files: [String]
        ) {
            self.output = output
            self.testableFrameworks = testableFrameworks.components(separatedBy: ",").filter { !$0.isEmpty }
            self.exclude = exclude.components(separatedBy: ",").filter { !$0.isEmpty }.map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
            self.noHeader = noHeader
            self.noTimestamp = noTimestamp
            self.noInheritance = noInheritance
            self.filePrefix = filePrefix
            self.noClassMocking = noClassMocking
            self.debugMode = debugMode
            self.globEnabled = globEnabled
            self.regex = regex
            self.files = files
        }

        // all options are declared here and then parsed by Commandant
        public static func evaluate(_ m: CommandMode) -> Result<Options, CommandantError<CuckooGeneratorError>> {
            let output: Result<String, CommandantError<ClientError>> = m <| Option(key: "output", defaultValue: "GeneratedMocks.swift", usage: "Where to put the generated mocks.\nIf a path to a directory is supplied, each input file will have a respective output file with mocks.\nIf a path to a Swift file is supplied, all mocks will be in a single file.\nDefault value is `GeneratedMocks.swift`.")

            let testable: Result<String, CommandantError<ClientError>> = m <| Option(key: "testable", defaultValue: "", usage: "A comma separated list of frameworks that should be imported as @testable in the mock files.")

            let exclude: Result<String, CommandantError<ClientError>> = m <| Option(key: "exclude", defaultValue: "", usage: "A comma separated list of classes and protocols that should be skipped during mock generation.")

            let noHeader: Result<Bool, CommandantError<ClientError>> = m <| Option(key: "no-header", defaultValue: false, usage: "Do not generate file headers.")

            let noTimestamp: Result<Bool, CommandantError<ClientError>> = m <| Option(key: "no-timestamp", defaultValue: false, usage: "Do not generate timestamp.")

            let noInheritance: Result<Bool, CommandantError<ClientError>> = m <| Option(key: "no-inheritance", defaultValue: false, usage: "Do not generate stubs/mock for super class/protocol even if available.")

            let filePrefix: Result<String, CommandantError<ClientError>> = m <| Option(key: "file-prefix", defaultValue: "", usage: "Names of generated files in directory will start with this prefix. Only works when output path is directory.")

            let noClassMocking: Result<Bool, CommandantError<ClientError>> = m <| Option(key: "no-class-mocking", defaultValue: false, usage: "Do not generate mocks for classes.")

            let debugMode: Result<Bool, CommandantError<ClientError>> = m <| Switch(flag: "d", key: "debug", usage: "Run generator in debug mode.")

            let globEnabled: Result<Bool, CommandantError<ClientError>> = m <| Switch(flag: "g", key: "glob", usage: "Use glob for specifying input paths.")

            let regex: Result<String, CommandantError<ClientError>> = m <| Option(key: "regex", defaultValue: "", usage: "A regular expression pattern that is used to match Classes and Protocols.\nAll that do not match are excluded.\nCan be used alongside `--exclude`.")

            let input: Result<[String], CommandantError<ClientError>> = m <| Argument(usage: "Files to parse and generate mocks for.")

            return curry(Options.init)
                <*> output
                <*> testable
                <*> exclude
                <*> noHeader
                <*> noTimestamp
                <*> noInheritance
                <*> filePrefix
                <*> noClassMocking
                <*> debugMode
                <*> globEnabled
                <*> regex
                <*> input
        }
    }
}
