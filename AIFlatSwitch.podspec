Pod::Spec.new do |s|
  s.name = 'AIFlatSwitch'
  s.version = 'v0.0.1'
  s.license = 'MIT'
  s.summary = 'An alternative flat component to UISwitch on iOS'
  s.homepage = 'https://github.com/cocoatoucher/AIFlatSwitch'
  s.authors = { 'cocoatoucher' => 'cocoatoucher@aol.com' }
  s.source = { :git => 'https://github.com/cocoatoucher/AIFlatSwitch.git', :tag => s.version }
  s.ios.deployment_target = '8.0'
  s.source_files = 'Source/*.swift'
  s.requires_arc = true
end
