Pod::Spec.new do |s|
  s.name             = 'UserServices'
  s.module_name      = 'UserServices'
  s.version          = '1.0.0'
  s.summary          = 'Framework for UserServices'
  s.homepage         = "https://github.com/edugonzlz"
  s.license          = 'Code is MIT'
  s.author           = { "Edu González" => "codilogico@gmail.com" }
  s.source           = { :git => "https://www.google.com", :tag => s.version }
  s.static_framework = true
  s.platform     = :ios, '13.0'
  s.requires_arc = true

  s.test_spec 'UserTests' do |test_spec|
#    test_spec.requires_app_host = true

    test_spec.source_files = [
      'UserTests/**/*.swift'
    ]
  end

  s.source_files = 'Source/**/*'

  s.dependency 'CommonCore'

end
