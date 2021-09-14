# Uncomment the next line to define a global platform for your project
platform :ios, '14.0'

target 'PlacesDemo' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for PlacesDemo
  pod 'Swinject'
  pod 'SwinjectAutoregistration'
  pod 'RealmSwift'
  pod 'Cosmos'
  pod 'SDWebImage'
  
  target 'PlacesDemoTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'PlacesDemoUITests' do
    # Pods for testing
    pod 'Cuckoo'
  end

end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '13.0'
    end
  end
end
