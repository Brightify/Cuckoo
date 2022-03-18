Pod::Spec.new do |s|
  s.name             = "Cuckoo"
  s.version          = "1.7.1"
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

  s.ios.deployment_target       = '9.0'
  s.osx.deployment_target       = '11.0'
  #s.watchos.deployment_target   = '2.0' # watchos does not include XCTest framework :(
  s.tvos.deployment_target      = '9.0'
  generator_name                = 'cuckoo_generator'
  s.swift_version               = '5.0'
  s.preserve_paths              = ['Generator/**/*', 'run', 'build_generator', generator_name]
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

  # When building for iOS versions 12 and lower in Xcode 11, a wild `image not found` appears.
  # This is a workaround for that annoying error.
  s.xcconfig = (8..12).map { |major| (0..5).map { |minor| [major, minor] } }.flatten(1).inject(Hash.new) do |hash, (major, minor)|
    hash["LIBRARY_SEARCH_PATHS[sdk=iphoneos#{major}.#{minor}]"] = '$(inherited) $(TOOLCHAIN_DIR)/usr/lib/swift-$(SWIFT_VERSION)/$(PLATFORM_NAME)'
    hash
  end

  s.subspec 'Swift' do |sub|
    sub.source_files = 'Source/**/*.swift'
  end

  s.subspec 'OCMock' do |sub|
    sub.source_files = 'OCMock/**/*.{h,m,swift}'
    sub.dependency 'Cuckoo/Swift'
    sub.dependency 'OCMock', '3.8.1'
  end
end
