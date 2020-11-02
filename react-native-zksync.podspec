require "json"

package = JSON.parse(File.read(File.join(__dir__, "package.json")))

Pod::Spec.new do |s|
  s.name         = "react-native-zksync"
  s.version      = package["version"]
  s.summary      = package["description"]
  s.description  = <<-DESC
                  react-native-zksync
                   DESC
  s.homepage     = "https://github.com/emailnjv/react-native-zksync"
  # brief license entry:
  s.license      = "MIT"
  # optional - use expanded license entry instead:
  # s.license    = { :type => "MIT", :file => "LICENSE" }
  s.authors      = { "Nicholas Vincent" => "nick@quantik.solutions" }
  s.platforms    = { :ios => "9.0" }
  s.source       = { :git => "https://github.com/emailnjv/react-native-zksync.git", :tag => "#{s.version}" }

  s.source_files = "ios/**/*.{h,c,m,swift}"
  s.requires_arc = true

  s.dependency "React"
  # ...
  # s.dependency "..."
  s.subspec "ZkSyncSign" do |zks|
    zks.vendored_libraries = "ios/libs/libzksyncsign.a"
    zks.source_files   = 'ios/include/ZkSyncSign.{h,m}'
end

