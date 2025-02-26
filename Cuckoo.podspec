Pod::Spec.new do |s|
  s.name             = 'Cuckoo'
  s.version          = '2.0.14'
  s.summary          = 'Cuckoo - first boilerplate-free Swift mocking framework.'
  s.description      = <<-DESC
                        Cuckoo is a mocking framework with an easy to use API (inspired by Mockito).
                        It generates mocks and some helper structures automatically to enable this functionality.
                       DESC

  s.homepage         = 'https://github.com/Brightify/Cuckoo'
  s.license          = 'MIT'
  s.author           = { 'Matyas Kriz' => 'm@tyas.cz', 'Tadeas Kriz' => 'tadeas@brightify.org', 'Filip Dolnik' => 'filip@brightify.org' }
  s.source           = { :git => 'https://github.com/Brightify/Cuckoo.git', :tag => s.version.to_s }

  s.ios.deployment_target       = '13.0'
  s.osx.deployment_target       = '10.15'
  s.watchos.deployment_target   = '8.0'
  s.tvos.deployment_target      = '13.0'
  generator_name                = 'cuckoonator'
  s.swift_version               = '6.0'
  s.preserve_paths              = ['Generator/**/*', 'version', 'run', 'build_generator', generator_name]
  s.prepare_command             = <<-CMD
                                    curl -Lo #{generator_name} https://github.com/Brightify/Cuckoo/releases/download/#{s.version}/#{generator_name}
                                    chmod +x #{generator_name}
                                CMD
  s.frameworks                  = 'XCTest', 'Foundation'
  s.requires_arc                = true
  s.pod_target_xcconfig         = {
    'ENABLE_BITCODE' => 'NO',
    'SWIFT_REFLECTION_METADATA_LEVEL' => 'none',
    'OTHER_LDFLAGS' => '$(inherited) -weak-lXCTestSwiftSupport',
  }
  s.default_subspec             = 'Swift'

  s.subspec 'Swift' do |sub|
    sub.source_files = ['Source/**/*.swift']
  end

  s.subspec 'OCMock' do |sub|
    sub.source_files = 'OCMock/**/*.{h,m,swift}'
    sub.source_files = []
    sub.dependency 'Cuckoo/Swift'
    sub.dependency 'OCMock', '3.9.3'
  end
end
