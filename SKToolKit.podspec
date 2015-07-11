Pod::Spec.new do |s|
  s.name     = 'SKAToolKit'
  s.version  = '1.0'
  s.license  = 'MIT'
  s.summary  = 'SKAToolKit is a free set of tools to be used with Apples Sprite Kit framework.'
  s.homepage = 'https://www.spritekitalliance.com'
  s.social_media_url = 'https://twitter.com/SKADevs'
  s.authors  = { 'Skyler Lauren' => 'skyler@skymistdevelopment.com', 'Ben Kane' => 'ben.kane27@gmail.com' }
  s.source   = { :git => 'https://github.com/marcjv/SKAToolKit/SKAToolKit.git' }
  s.requires_arc = true

  s.ios.deployment_target = '8.0'

end