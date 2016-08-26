require 'aruba/cucumber'
%x'rm -rf ../Build/log'
%x'mkdir ../Build/log'

Before do |scenario|
	%x'ln -s ../../Tests/SourceFiles ../Build/tmp/SourceFiles'
end

After do |scenario|
	%x'cp -R ../Build/tmp ../Build/log/"#{scenario.name}"'
	%x'rm ../Build/log/"#{scenario.name}"/SourceFiles'
end