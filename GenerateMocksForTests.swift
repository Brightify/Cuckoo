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

let output = "\(projectDir)/Tests/Generated/GeneratedMocks.swift"

// Use seperate variables for each file.
let generatorArguments = [
    "generate",
    "--testable",
    "Cuckoo",
    "--exclude",
    "ExcludedTestClass,ExcludedProtocol",
    "--output",
    output,
    "\(projectDir)/Tests/Source/ClassForStubTesting.swift",
    "\(projectDir)/Tests/Source/ClassWithOptionals.swift",
    "\(projectDir)/Tests/Source/ObjcProtocol.swift",
    "\(projectDir)/Tests/Source/UnicodeTestProtocol.swift",
    "\(projectDir)/Tests/Source/TestedProtocol.swift",
    "\(projectDir)/Tests/Source/TestedClass.swift",
    "\(projectDir)/Tests/Source/TestedSubclass.swift",
    "\(projectDir)/Tests/Source/TestedSubProtocol.swift",
    "\(projectDir)/Tests/Source/ExcludedTestClass.swift",
    "\(projectDir)/Tests/Source/GenericClass.swift",
    "\(projectDir)/Tests/Source/GenericProtocol.swift",
]

let useRun = Bool(ProcessInfo.processInfo.environment["USE_RUN", default: "false"]) ?? false

if useRun {
    shell(["\(projectDir)/run", "--clean"] + generatorArguments)
} else {
    shell(["swift", "run", "cuckoo_generator"] + generatorArguments, inDir: "\(projectDir)/Generator/")
}
