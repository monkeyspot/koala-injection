#
# Be sure to run `pod lib lint koala-injection.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'KoalaInjection'
  s.version          = '0.2.2'
  s.summary          = 'Evil but simple code injection, don\'t use!'

  s.description      = <<-DESC
Evil but simple code injection, don't use!
                       DESC

  s.homepage         = 'https://github.com/monkeyspot/koala-injection'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Oliver Letterer' => 'oliver.letterer@gmail.com' }
  s.source           = { :git => 'https://github.com/monkeyspot/koala-injection.git', :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/OliverLetterer'

  s.ios.deployment_target = '10.0'

  s.source_files = 'koala-injection/*'
end
