# Uncomment the next line to define a global platform for your project
platform :ios, '13.0'
# Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!
  use_modular_headers!
  inhibit_all_warnings!

workspace 'App'
source 'https://github.com/CocoaPods/Specs.git'

def dev_pods
  pod 'PokemonServices', :path => 'Modules/PokemonServices' #, :testspecs => ['ModuloATests', 'ModuloAUITests']

  pod 'CommonCore', :path => 'Modules/CommonCore'
end

target 'PokemonWorld' do
  project 'PokemonWorld/PokemonWorld.xcodeproj', 'Debug (Staging)' => :debug, 'Debug (Production)' => :debug, 'Release (Staging)' => :release, 'Release (Production)' => :release

  dev_pods

end

target 'PokemonLand' do
  project 'PokemonLand/PokemonLand.xcodeproj', 'Debug (Staging)' => :debug, 'Debug (Production)' => :debug, 'Release (Staging)' => :release, 'Release (Production)' => :release

  dev_pods

end
