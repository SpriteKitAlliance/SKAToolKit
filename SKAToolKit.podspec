Pod::Spec.new do |s|
  s.name     = 'SKAToolKit'
  s.version  = '0.1'
  s.license  = 'MIT'
  s.summary  = 'SKAToolKit is a free set of tools to be used with Apples Sprite Kit framework.'
  s.homepage = 'http://spritekitalliance.com/'
  s.social_media_url = 'https://twitter.com/SKADevs'
  s.authors  = { 'Skyler Lauren' => 'skyler@skymistdevelopment.com', 'Ben Kane' => 'ben.kane27@gmail.com' }
  s.source   = { :git => 'https://github.com/marcjv/SKAToolKit.git' }

  s.ios.deployment_target = '8.0'

  s.requires_arc = true
  s.source_files = 'SKAToolKit', '**/*.{h,m}'
  s.frameworks  = 'SpriteKit', 'UIKit', 'libz'
  s.xcconfig       = { 'FRAMEWORK_SEARCH_PATHS' => '"$(PODS_ROOT)/"' }
  s.requires_arc = true
end