Pod::Spec.new do |s|
  s.name             = 'PopUper'
  s.version          = '0.1'
  s.summary          = 'Easy way to show popover controller'
  s.homepage         = 'https://github.com/DmitrySmolyakov/PopUper'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Dmitry Smolyakov' => 'dm.smolyakov@gmail.com' }
  s.source           = { :git => 'https://github.com/DmitrySmolyakov/PopUper.git', :tag => s.version.to_s }
  s.ios.deployment_target = '8.0'
  s.source_files = 'PopUper/Classes/**/*'
  s.resource_bundles = {
      'PopUper' => ['PopUper/Assets/*']
  }
  s.resources = "PopUper/Assets/*.xcassets"
end
