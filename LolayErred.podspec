Pod::Spec.new do |s|
    s.name              = 'LolayErred'
    s.version           = '1'
    s.summary           = 'Error Manager and NSError Category and XCTests for each'
    s.homepage          = 'https://github.com/Lolay/Erred'
    s.license           = {
        :type => 'Apache',
        :file => 'LICENSE'
    }
    s.author            = {
        'Lolay' => 'support@lolay.com'
    }
    s.source            = {
        :git => 'https://github.com/lolay/erred.git',
        :tag => "1"
    }
    s.source_files      = 'LolayErred/*.{h,m}'
    s.requires_arc      = true
	s.ios.deployment_target = '7.0'
end
