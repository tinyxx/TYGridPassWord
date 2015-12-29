
Pod::Spec.new do |s|

  s.name         = "TYGridPassWord"
  s.version      = "1.0.0"
  s.summary      = "A iOS7 Style Grid PassWord View by Objective-C."
  s.description  = <<-DESC
                    A iOS7 Style Grid PassWord View used in iOS, which implement by Objective-C.
                   DESC
  s.homepage     = "https://github.com/tinyxx/TYGridPassWord"
  s.license      = "MIT"

  s.author             = { "tinyxx" => "tinyxx415@gmail.com" }
  s.platform     = :ios, "8.0"
  s.source       = { :git => "https://github.com/tinyxx/TYGridPassWord.git", :tag => "1.0.0" }
  s.source_files  = "TYGridPassWord/*"
  s.frameworks = "UIKit"

end
