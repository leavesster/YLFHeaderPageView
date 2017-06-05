Pod::Spec.new do |s|
  s.name             		= 'YLFHeaderPageView'
  s.version          		= '0.2.0'
  s.summary          		= 'A simple way to share one tableHeaderView/sectionHeaderView for mutiple scrollView.'
  s.description      		= <<-DESC
                                      YLFHeaderPageView supports vertical scroll for each single scrollView and or so support horizon scroll to change scrollView. It provides mutiple build in vertical scroll style and is compatible
                                            with pull refresh.
                       			DESC

  s.homepage         		= 'https://github.com/leavesster/YLFHeaderPageView'
  s.license          		= { :type => 'MIT', :file => 'LICENSE' }
  s.author 	          		= 'leavesster'
  s.source           		= { :git => 'https://github.com/leavesster/YLFHeaderPageView.git', :tag => s.version.to_s }
  s.ios.deployment_target 	= '8.0'
  s.source_files 		= 'YLFHeaderPageView/Classes/**/*'
  s.dependency 'KVOController'
end
