require 'aruba/cucumber'
%x'rm -rf ../.build/log'
%x'mkdir ../.build/log'

Before do |scenario|
	%x'ln -s ../../Tests/SourceFiles ../.build/tmp/SourceFiles'
	%x'ln -s ../../Tests/SourceFiles/Expected ../.build/tmp/Expected'
end

After do |scenario|
	%x'cp -R ../.build/tmp ../.build/log/"#{scenario.name}"'
	%x'rm ../.build/log/"#{scenario.name}"/SourceFiles'
	%x'rm ../.build/log/"#{scenario.name}"/Expected'
end
