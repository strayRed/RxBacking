#
# Be sure to run `pod lib lint RxBacking.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'RxBacking'
  s.version          = '0.1.7'
  s.summary          = 'A declarative way to implement delegate and dataSource of tableView and collectionView in iOS.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/strayRed/RxBacking'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'strayRed' => 'strayr3d@gmail.com' }
  s.source           = { :git => 'https://github.com/strayRed/RxBacking.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '11.0'
  s.swift_version  = '5.0'
  s.static_framework = true

  s.source_files = 'RxBacking/Classes/**/*'
  s.dependency 'RxDataSources'
  s.dependency 'ViewSizeCalculation'
  
  # s.resource_bundles = {
  #   'RxBacking' => ['RxBacking/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
