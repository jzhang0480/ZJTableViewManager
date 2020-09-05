# encoding: utf-8
Pod::Spec.new do |s|
  s.name = "ZJTableViewManager"
  s.version = "1.0.6"
  s.summary = "Powerful data driven content manager for UITableView.强大的数据驱动的TableView"
  s.description = <<-DESC
ZJTableViewManager allows to manage the content of any UITableView with ease, both forms and lists. ZJTableViewManager is built on top of reusable cells technique and provides APIs for mapping any object class to any custom cell subclass.
                   DESC
  s.homepage = "https://github.com/JavenZ/ZJTableViewManager"
  s.license = { :type => "MIT", :file => "FILE_LICENSE" }
  s.author = { "Javen" => "1074472615@qq.com" }
  s.source = { :git => "https://github.com/JavenZ/ZJTableViewManager.git", :tag => "#{s.version}" }
  # s.source_files  = "ZJTableViewManager", "ZJTableViewManager/**/*"
  s.platform = :ios, "8.0"
  s.swift_version = ['4.0', '4.2', '5.1', '5.2']
  # s.source_files = "ZJTableViewManager"
  s.subspec "Core" do |ss|
    ss.source_files = "ZJTableViewManager/Core/*"
  end
  s.subspec "Other" do |ss|
    ss.source_files = "ZJTableViewManager/Other/*"
    ss.dependency 'ZJTableViewManager/Core'
  end
end
