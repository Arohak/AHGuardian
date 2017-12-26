# Uncomment the next line to define a global platform for your project
platform :ios, '9.0'

target 'AHGuardian' do
  use_frameworks!

#  keep production keys ( good security practice )
  plugin 'cocoapods-keys', {
    :project => "AHGuardian",
    :target => "AHGuardian",
    :keys => ["GuardianaApiKey"]
  }

  pod 'Alamofire'
  pod 'AlamofireImage'
  pod 'RealmSwift'
  pod 'SwiftyJSON'
  pod 'Reusable'
  pod 'PureLayout'
  pod 'Texture'
  pod 'PKHUD'
  pod 'WatchdogInspector'

end
