Pod::Spec.new do |s|
  s.name             = 'liquid_glass_bridge'
  s.version          = '0.1.2'
  s.summary          = 'Platform-adaptive liquid glass widgets for Flutter.'
  s.description      = <<-DESC
A Flutter package that renders liquid-glass UI. On iOS it can use a native UIKit visual effect view.
                       DESC
  s.homepage         = 'https://github.com/DrRaspec/liquid_glass_bridge'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'liquid_glass_bridge' => 'dev@example.com' }
  s.source           = { :path => '.' }
  s.source_files     = 'Classes/**/*'
  s.dependency       'Flutter'

  s.platform = :ios, '13.0'
  s.swift_version = '5.0'
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES' }
  s.static_framework = true
end
