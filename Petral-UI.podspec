#
# Be sure to run `pod lib lint Petral.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'Petral-UI'
  s.version          = '1.0.0'
  s.summary          = '以Swift实现的 UI布局框架，以最少的代码，实现UI的搭建、属性设置以及布局控制'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
Petral-UI是一个以Swift实现的 UI布局框架，以最少的代码，实现UI的搭建、属性设置以及布局控制。
                       DESC

  s.homepage         = 'https://github.com/HuangZhiBin/Petral-UI'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'ikrboy@163.com' => 'BinHuang' }
  s.source           = { :git => 'https://github.com/HuangZhiBin/Petral-UI.git', :tag => s.version }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '8.0'
  s.swift_version = '4.2.1'

  s.source_files = 'Petral/Classes/**/*'
  
  # s.resource_bundles = {
  #   'Petral' => ['Petral/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
