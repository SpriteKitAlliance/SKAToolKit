Pod::Spec.new do |s|
  s.name     = 'SKAToolKit'
  s.version  = '1.0'
  s.license  = 'MIT'
  s.summary  = 'SKAToolKit is a free set of tools to be used with Apples Sprite Kit framework.'
  s.homepage = 'http://spritekitalliance.com/'
  s.social_media_url = 'https://twitter.com/SKADevs'
  s.authors  = {
                 'Norman Croan'  => 'ncroan@gmail.com', 
                 'Ben Kane'      => 'ben.kane27@gmail.com',
                 'Skyler Lauren' => 'skyler@skymistdevelopment.com',
                 'Marc Vandehey' => 'marc.vandehey@gmail.com' 
               }
  s.source   = { 
                 :git => 'https://github.com/SpriteKitAlliance/SKAToolKit.git',
                 :tag => s.version.to_s 
               }

  s.ios.deployment_target = '8.0'

  s.requires_arc = true
  s.source_files = 'SKAToolKit', 'SKAToolKit/Categories', 'SKAToolKit/Model', 'SKAToolKit/SKAButtons', 'SKAToolKit/SKAMaps', 'SKAToolKit/SKATest', 'SKAToolKit/Utilities'
  s.frameworks  = 'SpriteKit', 'UIKit'
  s.library = 'z'
  s.xcconfig       = { 'FRAMEWORK_SEARCH_PATHS' => '"$(PODS_ROOT)/"' }
  s.requires_arc = true
end