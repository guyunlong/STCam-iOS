
source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '8.0'
def shared_pods
    pod 'ReactiveCocoa', '~> 2.3.1'
    pod 'TPKeyboardAvoiding'
    pod 'Masonry'
    pod 'MBProgressHUD'
    pod 'BEMCheckBox'
    pod 'YBImageBrowser'
    pod 'JPush'
    pod 'MJRefresh'
    pod 'RealReachability'
    pod 'SGQRCode', '~> 2.5.4'
    pod 'SpinKit', '~> 1.1'
    pod 'Bugly'
    pod 'CustomIOSAlertView'
    pod 'Fabric'
    pod 'Crashlytics'
    pod 'CocoaLumberjack', '3.4.2'
end
target 'STCam' do
    shared_pods
end
target 'GraveTime' do
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





