Pod::Spec.new do |s|
  s.name = 'Sheepdog'
  s.version = '0.1.0'
  s.summary = 'Obj-C higher order methods.'
  s.homepage = 'https://github.com/AstroHQ/Sheepdog'
  s.license = { :type => 'MIT', :file => 'LICENSE' }
  s.author = { 'Matt Ronge' => 'mronge@mronge.com' }
  s.source = { :git => 'https://github.com/AstroHQ/Sheepdog.git', :tag => s.version.to_s }
  s.source_files  = 'Sheepdog/*.{h,m}'
  s.requires_arc = true
  s.ios.deployment_target = '6.0'
  s.osx.deployment_target = '10.8'
end