import ProjectDescription

let generatorProject = "Generator/CuckooGenerator.xcodeproj"

let setup = Setup([
    .custom(name: "Generator project must be created.", meet: ["make", "dev"], isMet: isMet: ["ls", generatorProject])
])
