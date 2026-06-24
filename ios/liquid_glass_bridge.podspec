Pod::Spec.new do |s|
  s.name             = 'liquid_glass_bridge'
  s.version          = '0.3.2'
  s.summary          = 'Native-backed liquid glass widgets and controls for Flutter.'
  s.description      = <<-DESC
A Flutter package that renders native-backed liquid-glass surfaces and controls across iOS, Android, web, and desktop.
                       DESC
  s.homepage         = 'https://github.com/DrRaspec/liquid_glass_bridge'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'DrRaspec' => 'DrRaspec' }
  s.source           = { :path => '.' }
  s.source_files     = 'Classes/**/*'
  s.dependency       'Flutter'

  s.platform = :ios, '13.0'
  s.swift_version = '5.0'
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES' }
  s.static_framework = true
end
