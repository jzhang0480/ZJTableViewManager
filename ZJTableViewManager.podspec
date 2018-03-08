
Pod::Spec.new do |s|
  s.name         = "ZJTableViewManager"
  s.version      = "0.0.1"
  s.summary      = "Powerful data driven content manager for UITableView. RETableViewManager的Swift版 RETableViewManager's Swift Version"
  s.description  = <<-DESC
                   DESC
  s.homepage     = "https://github.com/JavenZ/ZJTableViewManager"
  s.license      = { :type => "MIT", :file => "FILE_LICENSE" }
  s.author             = { "Javen" => "1074472615@qq.com" }
  s.source       = { :git =>"https://github.com/JavenZ/ZJTableViewManager.git", :tag => "#{s.version}" }
  s.source_files  = "ZJTableViewManager", "ZJTableViewManager/**/*.{h,m}" 
  s.platform = :ios, '8.0'
  
end
