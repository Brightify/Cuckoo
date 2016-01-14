#
# Be sure to run `pod lib lint Mockery.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "Mockery"
  s.version          = "0.1.0"
  s.summary          = "Mockery - first boilerplate-free Swift mocking framework."
  s.description      = <<-DESC
                        Mockery is a mocking framework with an easy to use API (inspired by Mockito).
                        It generates mocks and some helper structures automatically to enable this functionality.
                       DESC

  s.homepage         = "https://github.com/SwiftKit/Mockery"
  s.license          = 'MIT'
  s.author           = { "Tadeas Kriz" => "tadeas@brightify.org" }
  s.source           = {
      :git => "https://github.com/SwiftKit/Mockery.git",
      :tag => s.version.to_s
  }

  s.ios.deployment_target       = '8.0'
  s.osx.deployment_target       = '10.9'
  #s.watchos.deployment_target   = '2.0' # watchos does not include XCTest framework :(
  s.tvos.deployment_target      = '9.0'
  s.source_files                = 'Source/**/*.swift'
  s.frameworks                  = 'XCTest', 'Foundation'
  s.requires_arc                = true
  s.pod_target_xcconfig         = { 'ENABLE_BITCODE' => 'NO' }
end
