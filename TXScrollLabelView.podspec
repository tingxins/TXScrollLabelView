
Pod::Spec.new do |s|
  s.name         = "TXScrollLabelView"
  s.version      = "1.1.1"
  s.summary      = "The best way to show & display such as adverts,boardcast,OnSale e.g. with a customView.（快速接入自定义滚动视图，可以做广告栏、广播栏等等展示）"
  s.homepage     = "https://github.com/tingxins/TXScrollLabelView"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author             = { "tingxins" => "tingxins@sina.com" }
  s.platform     = :ios, "7.0"
  s.source       = { :git => "https://github.com/tingxins/TXScrollLabelView.git", :tag => 'v1.1.1' }
  s.source_files  = 'TXScrollLabelView/**/*.{h,m}'
  s.requires_arc = true
end
