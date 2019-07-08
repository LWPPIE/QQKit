
Pod::Spec.new do |s|

  s.name = 'QQKit'
  s.summary = "QQKit local Kit"
  s.homepage = "http://www.baidu.com"
  s.license = { :type => 'MIT', :file => 'LICENSE.md' }
  s.author = { "Pie" => "610310337@qq.com" }
  s.version = '1.0.0'
  s.platform = :ios
  s.ios.deployment_target = '8.0'
  s.source = { :git => "https://gitee.com/iOSlwp/QQKit.git", :tag => "1.0.0" }
  s.source_files = 'QQKit/*.{h,m}','QQKit/**/*.{h,m}','QQKit/**/**/*.{h,m}'
  s.resource     = 'QQKit/Resource/LSYAlertView.bundle','QQKit/Resource/LKImages.bundle'
  s.frameworks = 'UIKit'
  
  s.dependency 'Masonry'
  s.dependency 'YYKit'
  s.dependency 'pop'
  s.dependency 'CAAnimationBlocks'
  s.dependency 'RBBAnimation'
  s.dependency 'FTCoreText'
  s.dependency 'SVProgressHUD'
  s.dependency 'UIActionSheet+Blocks'
  s.dependency 'UIAlertView+Blocks'

  s.requires_arc = true

end