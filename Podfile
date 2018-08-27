
source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '8.0'
def shared_pods
    pod 'ReactiveCocoa', '~> 2.3.1'
    pod 'TPKeyboardAvoiding'
    pod 'Masonry'
    pod 'MBProgressHUD'
end
target 'STCam' do
    shared_pods
end

post_install do |installer_representation|
  installer_representation.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['ONLY_ACTIVE_ARCH'] = 'NO'
      config.build_settings['VALID_ARCHS'] = 'arm64 i386 armv7 armv7s'
    end
  end
end





