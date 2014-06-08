#
# Be sure to run `pod lib lint NAME.podspec' to ensure this is a
# valid spec and remove all comments before submitting the spec.
#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#
Pod::Spec.new do |s|
  s.name             = "ADTiledMapSlicer"
  s.version          = File.read('0.1')
  s.summary          = "ADTiledMapSlicer is the image slicer to use with NATiledMap."
  s.description      = <<-DESC
                       ADTiledMapSlicer prepare image in different zoom level images to use with NATiledImageMapView or ARTiledImageView
                       DESC
  s.homepage         = "http://anhd.at"
  s.license          = 'MIT'
  s.author           = { "Dat Truong" => "mr.anhdat@gmail.com" }
  s.source           = { :git => "https://github.com/anhdat/ADTiledMapSlicer.git", :tag => 0.1 }

  s.platform     = :ios, '5.0'
  s.requires_arc = true

  s.source_files = 'Classes'
  s.resources = 'Assets/*.png'

  s.ios.exclude_files = 'Classes/osx'
end