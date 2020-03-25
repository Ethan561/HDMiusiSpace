 platform :ios, '10.0'

 use_frameworks!
 source 'https://github.com/CocoaPods/Specs.git'
 target 'HDMiusiSpace'  do
 
 pod 'JoyTool'
 pod 'Masonry'
 pod 'Moya', '~> 12.0'
 pod 'SnapKit'
 pod 'Kingfisher'
 pod 'ZZCircleProgress'
 pod 'Bugly', '~> 2.5.0'
 pod 'JPush'#极光推送
 # 集成百度统计 （埋点技术）
 pod 'BaiduMobStatCodeless'
 pod 'SwiftyStoreKit'
 #pod 'Alamofire'
 pod 'KeychainAccess'
 
 post_install do |installer|
     installer.pods_project.targets.each do |target|
         target.build_configurations.each do |config|
             config.build_settings['DEBUG_INFORMATION_FORMAT'] = 'dwarf'
         end
     end
 end
 
 end





