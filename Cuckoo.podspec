Pod::Spec.new do |s|
  s.name             = "Cuckoo"
  s.version          = "0.11.3"
  s.summary          = "Cuckoo - first boilerplate-free Swift mocking framework."
  s.description      = <<-DESC
                        Cuckoo is a mocking framework with an easy to use API (inspired by Mockito).
                        It generates mocks and some helper structures automatically to enable this functionality.
                       DESC

  s.homepage         = "https://github.com/Brightify/Cuckoo"
  s.license          = 'MIT'
  s.author           = { "Tadeas Kriz" => "tadeas@brightify.org", "Filip Dolnik" => "filip@brightify.org", "Adriaan (Arjan) Duijzer" => "arjan@nxtstep.nl" }
  s.source           = {
      :git => "https://github.com/Brightify/Cuckoo.git",
      :tag => s.version.to_s
  }

  s.ios.deployment_target       = '8.0'
  s.osx.deployment_target       = '10.9'
  #s.watchos.deployment_target   = '2.0' # watchos does not include XCTest framework :(
  s.tvos.deployment_target      = '9.0'
  s.source_files                = ['Source/**/*.swift']
  generator_name                = 'cuckoo_generator'
  s.preserve_paths              = ['Generator/**/*', 'run', 'build_generator', generator_name]
  s.prepare_command             = <<-CMD
                                    curl -Lo #{generator_name} https://github.com/Brightify/Cuckoo/releases/download/#{s.version}/#{generator_name}
                                    chmod +x #{generator_name}
                                CMD
  s.frameworks                  = 'XCTest', 'Foundation'
  s.requires_arc                = true
  s.pod_target_xcconfig         = { 'ENABLE_BITCODE' => 'NO', 'SWIFT_REFLECTION_METADATA_LEVEL' => 'none' }
end
