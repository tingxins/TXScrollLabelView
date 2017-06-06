
Pod::Spec.new do |s|
  s.name         = "TXScrollLabelView"
  s.version      = "1.3.2"
  s.summary      = "TXScrollLabelView (Objective-C), the best way to show & display informations such as Adverts / Boardcast / OnSale e.g. with a customView."
  s.homepage     = "https://github.com/tingxins/TXScrollLabelView"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author             = { "tingxins" => "tingxins@sina.com" }
  s.platform     = :ios, "7.0"
  s.source       = { :git => "https://github.com/tingxins/TXScrollLabelView.git", :tag => 'v1.3.2' }
  s.source_files  = 'TXScrollLabelView/**/*.{h,m}'
  s.requires_arc = true
end
