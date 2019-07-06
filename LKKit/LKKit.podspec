
Pod::Spec.new do |s|

  s.name = 'LKKit'
  s.summary = "LaKaTV local Kit"
  s.homepage = "http://lakatv.com"
  s.license = { :type => 'MIT', :file => 'LICENSE.md' }
  s.author = { "RoyLei" => "redwarly@gmail.com" }
  s.version = '0.0.1'
  s.platform = :ios
  s.ios.deployment_target = '8.0'
  s.source = { :path => ".", :tag => "0.0.1" }
  s.source_files = 'LKKit/*.{h,m}','LKKit/**/*.{h,m}','LKKit/**/**/*.{h,m}'
  s.resource     = 'LKKit/Resource/LSYAlertView.bundle','LKKit/Resource/LKImages.bundle'
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