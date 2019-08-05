Pod::Spec.new do |s|
  s.name = 'AIFlatSwitch'
  s.version = '1.0.7'
  s.license = 'MIT'
  s.summary = 'Nicely animated flat design switch alternative to UISwitch'
  s.homepage = 'https://github.com/cocoatoucher/AIFlatSwitch'
  s.authors = { 'cocoatoucher' => 'cocoatoucher@posteo.se' }
  s.swift_version = '5.0'
  
  s.ios.deployment_target = '8.0'
  s.tvos.deployment_target = '12.0'
  
  s.source = { :git => 'https://github.com/cocoatoucher/AIFlatSwitch.git', :tag => s.version }
  s.source_files = 'Sources/*.swift'
end
