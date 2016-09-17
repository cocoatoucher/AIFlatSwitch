Pod::Spec.new do |s|
  s.name = 'AIFlatSwitch'
  s.version = '1.0.0'
  s.license = 'MIT'
  s.summary = 'A flat design switch component alternative to iOS UISwitch'
  s.homepage = 'https://github.com/cocoatoucher/AIFlatSwitch'
  s.authors = { 'cocoatoucher' => 'cocoatoucher@aol.com' }
  s.source = { :git => 'https://github.com/cocoatoucher/AIFlatSwitch.git', :tag => s.version }
  s.ios.deployment_target = '8.0'
  s.source_files = 'Source/*.swift'
  s.requires_arc = true
end
