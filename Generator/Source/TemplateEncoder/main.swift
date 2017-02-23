import Foundation
let templateDirectory = CommandLine.arguments.suffix(from: 1).first ?? "Templates"

var s = ""
s += "// GENERATED: DO NOT EDIT\n"
s += "//\n"
s += "// This file contains base64 encodings of templates used for Swift GRPC code generation.\n"
s += "//\n"
s += "func loadTemplates() -> [String:String] {\n"
s += "  var templates : [String:String] = [:]\n"

let filenames = try FileManager.default.contentsOfDirectory(atPath: templateDirectory)
for filename in filenames {
  if filename.hasSuffix(".swift.stencil") {
    let fileURL = URL(fileURLWithPath: templateDirectory + "/" + filename)
    let filedata = try Data(contentsOf:fileURL)
    let encoding = filedata.base64EncodedString()
    s += "\n"
    s += "  templates[\"" + filename + "\"] = \"" + encoding + "\"\n"
  }
}

s += "  return templates\n"
s += "}\n"
print(s)
