Pod::Spec.new do |s|
  s.name             = "AFRaptureXMLRequestOperation"
  s.version          = '1.0.1'
  s.summary          = "RaptureXML support for AFNetworking's AFHTTPClient"
  s.license          = 'MIT'
  s.author           = { "Jan Sanchez" => "jan.sanchez@outlook.com" }
  s.source           = { :git => 'https://github.com/jansanz/AFRaptureXMLRequestOperation.git', :tag => '1.0.1' }
  s.platform         = :ios, '5.0'
  s.source_files     = 'AFRaptureXMLRequestOperation/*.{h,m}'
  s.dependency       'AFNetworking', '~> 1.2.1'
  s.dependency       'RaptureXML', '~> 1.0.1'
end