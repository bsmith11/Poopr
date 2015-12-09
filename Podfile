source 'https://github.com/CocoaPods/Specs'

platform :ios, '8.0'

# Ignore all warnings from all pods
inhibit_all_warnings!

pod 'RZCollectionList', '~> 0.7'
pod 'RZDataBinding', '~> 2.0'
pod 'RZImport', '~> 1.3'
pod 'RZVinyl', '~> 1.1'
pod 'RZUtils', '~> 2.5'
pod 'Parse', '~> 1.8'
pod 'ParseCrashReporting', '~> 1.8'
pod 'CocoaLumberjack', '~> 2.0'
pod 'INTULocationManager', '~> 4.0'
pod 'SSPullToRefresh', '~> 1.2'
pod 'pop', '~> 1.0'

target :unit_tests, :exclusive => true do
  link_with 'UnitTests'
  pod 'Specta'
  pod 'Expecta'
  pod 'OCMock'
  pod 'OHHTTPStubs'
end

# Patch RZCollectionList for iOS 9 FRC bug
# Copy acknowledgements to the Settings.bundle

post_install do | installer |
  require 'fileutils'

  puts 'Patching RZCollectionList for iOS 9 FRC bug'
  `patch -p0 < Diffs/RZBaseCollectionList.m.diff`

  pods_acknowledgements_path = 'Pods/Target Support Files/Pods/Pods-Acknowledgements.plist'
  settings_bundle_path = Dir.glob("**/*Settings.bundle*").first

  if File.file?(pods_acknowledgements_path)
    puts 'Copying acknowledgements to Settings.bundle'
    FileUtils.cp_r(pods_acknowledgements_path, "#{settings_bundle_path}/Acknowledgements.plist", :remove_destination => true)
  end
end

