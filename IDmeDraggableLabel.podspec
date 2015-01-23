 Pod::Spec.new do |s|
  s.name         = "IDmeDraggableLabel"
  s.version      = "0.1.0"
  s.summary      = "A proof-of-concept on how to drag a UILabel object into a UIWebView input/text field."
  s.homepage     = "https://github.com/idme/IDmeDraggableLabel"
  s.platform     = :ios, '5.0'  
  s.source       = { :git => "https://github.com/idme/IDmeDraggableLabel.git", :tag => "0.1.0" }
  s.source_files = 'IDmeDraggableLabel/*.{h,m}'
  s.requires_arc = true
  s.author       = { "Arthur Ariel Sabintsev" => "arthur@sabintsev.com" }
  s.license      = 'MIT'
 end
