import ProjectDescription

let generateMocksScript = "Scripts/RunCuckooGen.sh"
let generatorProject = "Generator/CuckooGenerator.xcodeproj"

let setup = Setup([
    .custom(name: "Generator project must be created.", meet: ["make", "dev"], isMet: isMet: ["ls", generatorProject])
    .custom(name: "Generate Mocks script must be executable.", meet: ["chmod", "u+x", generateMocksScript], isMet: ["if [[ -x \"\(generateMocksScript)\" ]]; then return 0; else return 1; fi"]),
])
