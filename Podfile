# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'BibliographicGuide' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for BibliographicGuide

  target 'BibliographicGuideTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'BibliographicGuideUITests' do
    # Pods for testing
  end

post_install do |installer|
  installer.aggregate_targets.each do |target|
    target.xcconfigs.each do |variant, xcconfig|
      xcconfig_path = target.client_root + target.xcconfig_relative_path(variant)
      IO.write(xcconfig_path, IO.read(xcconfig_path).gsub("DT_TOOLCHAIN_DIR", "TOOLCHAIN_DIR"))
    end
  end
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      if config.base_configuration_reference.is_a? Xcodeproj::Project::Object::PBXFileReference
        xcconfig_path = config.base_configuration_reference.real_path
        IO.write(xcconfig_path, IO.read(xcconfig_path).gsub("DT_TOOLCHAIN_DIR", "TOOLCHAIN_DIR"))
      end
    end
  end
end

pod 'FirebaseAnalytics'
pod 'Firebase'
pod 'ObjectMapper'
pod 'FirebaseAuth'
pod 'FirebaseFirestore'
pod 'FirebaseFirestoreSwift'
pod 'FirebaseStorage'
pod 'FirebaseDatabase'
pod 'SDWebImageSwiftUI'

end
