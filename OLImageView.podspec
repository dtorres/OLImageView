Pod::Spec.new do |s|
  s.name         = "OLImageView"
  s.version      = "1.3.2"
  s.summary      = "Animated GIFs implemented the right way."
  s.homepage     = "https://www.github.com/ondalabs/OLImageView"
  s.license      = { :type => 'MIT', :file => 'LICENSE' }
  s.author       = { "Diego Torres" => "contact@dtorres.me" }
  s.source       = { :git => "https://github.com/ondalabs/OLImageView.git", :tag => s.version.to_s }
  s.platform     = :ios, '5.0'
  s.framework  = 'ImageIO', 'MobileCoreServices', 'QuartzCore'
  s.requires_arc = true
  s.default_subspec = 'Core'

  s.subspec 'Core' do |core|
    core.source_files = 'OLImage.{h,m}', 'OLImageView.{h,m}'
  end

  s.subspec 'AFNetworking' do |af|
    af.dependency 'OLImageView/Core'
    af.dependency 'AFNetworking', '~> 1.0'
    af.source_files = "Categories/AFImageRequestOperation+OLImage.{h,m}"
  end

  s.subspec 'AFNetworking2' do |ss|
    s.platform = :ios, '6.0'
    ss.dependency 'OLImageView/Core'
    ss.dependency 'AFNetworking', '~> 2.0'
    ss.source_files = "AFNetworking/OLImageResponseSerializer.{h,m}"
  end
end
