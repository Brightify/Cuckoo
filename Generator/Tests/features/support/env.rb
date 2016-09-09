require 'aruba/cucumber'
%x'rm -rf ../Build/log'
%x'mkdir ../Build/log'

Before do |scenario|
	%x'ln -s ../../Tests/SourceFiles ../Build/tmp/SourceFiles'
	%x'ln -s ../../Tests/SourceFiles/Expected ../Build/tmp/Expected'
end

After do |scenario|
	%x'cp -R ../Build/tmp ../Build/log/"#{scenario.name}"'
	%x'rm ../Build/log/"#{scenario.name}"/SourceFiles'
	%x'rm ../Build/log/"#{scenario.name}"/Expected'
end