import Foundation

@discardableResult
func shell(_ args: [String], inDir dir: String? = nil) -> Int32 {
    let task = Process()
    task.launchPath = "/usr/bin/env"
    task.arguments = args
    if let dir = dir {
        task.currentDirectoryPath = dir
    }
    task.launch()
    task.waitUntilExit()
    return task.terminationStatus
}

let projectDir = ProcessInfo.processInfo.environment["PROJECT_DIR", default: "."]

let output = "\(projectDir)/Tests/Swift/Generated/GeneratedMocks.swift"

// Use seperate variables for each file.
let generatorArguments = [
    "generate",
    "--testable",
    "Cuckoo",
    "--exclude",
    "ExcludedTestClass,ExcludedProtocol",
    "--output",
    output,
    "\(projectDir)/Tests/Swift/Source/ClassForStubTesting.swift",
    "\(projectDir)/Tests/Swift/Source/ClassWithOptionals.swift",
    "\(projectDir)/Tests/Swift/Source/ObjcProtocol.swift",
    "\(projectDir)/Tests/Swift/Source/UnicodeTestProtocol.swift",
    "\(projectDir)/Tests/Swift/Source/TestedProtocol.swift",
    "\(projectDir)/Tests/Swift/Source/TestedClass.swift",
    "\(projectDir)/Tests/Swift/Source/TestedSubclass.swift",
    "\(projectDir)/Tests/Swift/Source/TestedSubProtocol.swift",
    "\(projectDir)/Tests/Swift/Source/ExcludedTestClass.swift",
    "\(projectDir)/Tests/Swift/Source/GenericClass.swift",
    "\(projectDir)/Tests/Swift/Source/GenericProtocol.swift",
    "\(projectDir)/Tests/Swift/Source/GenericMethodClass.swift",
]

let useRun = Bool(ProcessInfo.processInfo.environment["USE_RUN", default: "false"]) ?? false

if useRun {
    shell(["\(projectDir)/run", "--clean"] + generatorArguments)
} else {
    shell(["swift", "run", "cuckoo_generator"] + generatorArguments, inDir: "\(projectDir)/Generator/")
}
