Pod::Spec.new do |s|
  s.name             = 'CommonUI'
  s.module_name      = 'CommonUI'
  s.version          = '1.0.0'
  s.summary          = 'Framework for CommonUI'
  s.homepage         = "https://github.com/edugonzlz"
  s.license          = 'Code is MIT'
  s.author           = { "Edu González" => "codilogico@gmail.com" }
  s.source           = { :git => "https://www.google.com", :tag => s.version }
  s.static_framework = true
  s.platform     = :ios, '13.0'
  s.requires_arc = true
  s.static_framework = true

  s.source_files = '**/*'

  s.resource_bundles = {
      'ResourcesBundle' => ['CommonUI/**/*.xib']
    }

end
