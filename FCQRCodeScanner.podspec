Pod::Spec.new do |s|
  s.name     = 'FCQRCodeScanner'
  s.version  = '1.0.0'
  s.license  = 'MIT'
  s.summary  = 'Simple QRcode Scanner(Apple API) & Generator'
  s.homepage = 'https://github.com/wolfcon/FCQRCodeScanner'
  s.author   = { 'Frank' => '472730949@qq.com' }
  s.source   = { :git => 'https://github.com/wolfcon/FCQRCodeScanner.git', :commit => 'd0beb72345889141a39aa736daebae509d9c4f7d' }

  s.description = 'Simple QRcode Scanner(Apple API) & Generator'
  s.platform    = :ios

  s.source_files = 'FCQRCodeScanner/*.{h,m,xib}'
  s.resources = "FCQRCodeScanner/*.{png,mp3}"
  #s.clean_path   = 'Demo'

  s.requires_arc = true
end
