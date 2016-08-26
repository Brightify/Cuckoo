require 'aruba/cucumber'

Aruba.configure do |config|
  config.exit_timeout = 1000
  config.root_directory = '../Build'
  config.working_directory = 'tmp'
end