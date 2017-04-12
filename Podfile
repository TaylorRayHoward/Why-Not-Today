inhibit_all_warnings!

target 'Why Not Today' do
    use_frameworks!
    pod 'RealmSwift'
    pod 'JTAppleCalendar', '~> 7.0'
end
target 'Why Not TodayTests' do
    use_frameworks!
    pod 'RealmSwift'
    pod 'Quick'
    pod 'Nimble'
end

post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['SWIFT_VERSION'] = '3.1'
        end
    end
end
