Pod::Spec.new do |s|
  s.name     = 'SKAButton'
  s.version  = '1.0'
  s.license  = 'MIT'
  s.summary  = 'SKAButton of the SKAToolKit is a simple button class for SpriteKit that mimics the usefulness of UIButton'
  s.homepage = 'http://spritekitalliance.com/'
  s.social_media_url = 'https://twitter.com/SKADevs'
  s.authors  = {
                 'Norman Croan'  => 'ncroan@gmail.com', 
                 'Ben Kane'      => 'ben.kane27@gmail.com',
                 'Max Kargin'    => 'maksym.kargin@gmail.com',
                 'Skyler Lauren' => 'skyler@skymistdevelopment.com',
                 'Marc Vandehey' => 'marc.vandehey@gmail.com' 
               }
  s.source   = { 
                 :git => 'https://github.com/SpriteKitAlliance/SKAButton.git',
                 :tag => s.version.to_s 
               }

  s.ios.deployment_target = '8.0'

  s.requires_arc = true
  s.source_files = 'SKAToolKit/SKAButton'
  s.frameworks  = 'SpriteKit'
  s.xcconfig       = { 'FRAMEWORK_SEARCH_PATHS' => '"$(PODS_ROOT)/"' }
end
