#
#  Be sure to run `pod spec lint UICommonKits.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see https://guides.cocoapods.org/syntax/podspec.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |spec|
  spec.name         = "UICommonKits"
  spec.version      = "1.0.0"
  spec.summary      = "a common user interface Kits."
  spec.description  = <<-DESC
                     a common user interface Kits.
                   DESC
  spec.homepage     = "https://github.com/zhang2/UICommonKits"
  spec.license       = { :type => 'MIT', :file => 'LICENSE' }
  spec.author       = { "zjg" => "zhang1314520648@163.com" }
  spec.platform     = :ios, "9.0"
  spec.source       = { :git => "https://github.com/zhang2/UICommonKits.git", :tag => "#{spec.version}" }
  spec.source_files  = "SourceFiles/Classes/**/*.{h,m}"
  spec.requires_arc = true

end
