# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'TinkoffFintech' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for TinkoffFintech
pod 'Firebase/Firestore'
pod 'SwiftLint'

target 'TinkoffFintechTests' do
  inherit! :search_paths
end

target 'TinkoffFintechUITests' do
  inherit! :search_paths
  pod 'Firebase/Firestore'
end

end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings.delete 'IPHONEOS_DEPLOYMENT_TARGET'
    end
  end
end
