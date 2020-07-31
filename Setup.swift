import ProjectDescription

let generatorProject = "Generator/CuckooGenerator.xcodeproj"
let generatedMocks = "Tests/Swift/GeneratedMocks.swift"

let setup = Setup([
    .custom(name: "Generator project must be created.", meet: ["make", "dev"], isMet: ["ls", generatorProject]),
    .custom(name: "Ensure Generated mocks file exists, so that it needn't be added manually.", meet: ["touch", generatedMocks], isMet: ["ls", generatedMocks]),
])
