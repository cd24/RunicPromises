#
# Be sure to run `pod lib lint RunicPromises.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'RunicPromises'
  s.version          = '0.1.0'
  s.summary          = 'Runes operators for PromiseKit'

  s.description      = <<-DESC
Promises lend themselves handily to functional implementations for everything from functors to monads. These operators simplify interactions with promises through definitions declared in the Runes library.
                       DESC

  s.homepage         = 'https://github.com/cd24/RunicPromises'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'cd24' => 'mcaveyjc@gmail.com' }
  s.source           = { :git => 'https://github.com/cd24/RunicPromises.git', :tag => s.version.to_s }

  s.ios.deployment_target = '8.0'

  s.source_files = 'RunicPromises/Classes/**/*'

  s.dependency 'PromiseKit', '~> 4.2'
  s.dependency 'Runes', '~> 4.1'
end
