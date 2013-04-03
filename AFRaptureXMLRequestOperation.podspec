Pod::Spec.new do |s|
  s.name             = "AFRaptureXMLRequestOperation"
  s.description      = "RaptureXML support for AFNetworking's AFHTTPClient"
  s.version          = '1.0.0'

  s.source           = { 
    :git => 'https://github.com/jansanz/AFRaptureXMLRequestOperation.git', 
    :tag => s.version.to_s 
  }

  s.source_files     = '*.{h,m}'
  s.dependency       'AFNetworking', '~> 1.1.0'
  s.dependency       'RaptureXML', '~> 1.0.0'
end
