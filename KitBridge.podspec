#!pod

# KitBridge.podspec - Requires `sudo gem install cocoapods -v 1.6.0.beta.1`

Pod::Spec.new do |s|
  s.name             = 'KitBridge'
  s.module_name      = 'KitBridge'
  s.version          = '1.1'
  s.summary          = 'KitBridge: Bringing UIKit and AppKit Closer Together'
  s.description      = "KitBridge allows you to create views which can be used in both iOS and macOS applications."
  s.homepage         = 'https://github.com/alfwatt/KitBridge'
  s.license          = { :type => 'MIT', :file => 'README.md' }
  s.authors          = { 'iStumbler Labs, Alf Watt' => 'alf@istumbler.net' }
  s.source           = { :git => 'https://github.com/alfwatt/KitBridge.git', :branch => 'master' }

  s.ios.deployment_target = '10.0'
  s.osx.deployment_target = '10.10'

  s.source_files = '**/*.{h,m,swift}'
  s.exclude_files = '**/colorist/**'
  s.public_header_files = '**/*.h'
  s.requires_arc = true
  s.framework = 'QuartzCore'
  s.ios.framework  = 'UIKit'
  s.osx.framework  = 'AppKit'
end
