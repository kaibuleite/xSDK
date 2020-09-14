#
# Be sure to run `pod lib lint xSDK.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'xSDK'
  s.version          = '0.1.5'  # SDK版本号
  s.summary          = '自定义框架'
  s.swift_version    = '5.0'    # Swift版本号

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/kaibuleite/xSDK'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'kaibuleite' => '177955297@qq.com' }
  s.source           = { :git => 'https://github.com/kaibuleite/xSDK.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '9.0'

  s.source_files = 'xSDK/Classes/**/*'
  
  # s.resource_bundles = {
  #   'xSDK' => ['xSDK/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
  
  # 必备框架
  s.dependency 'Alamofire', '~> 4.9.1'  # API代码基于4.x，5.x后代码变动太大
  s.dependency 'SDWebImage', '~> 5.8.3' # 可根据情况提高版本
  s.dependency 'MJRefresh', '~> 3.4.3'  # 可根据情况提高版本
end
