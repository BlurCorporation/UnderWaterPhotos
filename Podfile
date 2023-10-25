source 'https://github.com/CocoaPods/Specs.git'

platform :ios, '14.0'


# Uncomment this line if you're using Swift
use_frameworks!


target 'UnderWaterPhoto' do
  pod 'OpenCV', '4.3.0'
end

post_install do |installer|
    installer.generated_projects.each do |project|
        project.targets.each do |target|
            target.build_configurations.each do |config|
                config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '14.0'
            end
        end
    end
end
