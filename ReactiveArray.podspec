Pod::Spec.new do |spec|
  spec.name = 'ReactiveArray'
  spec.version = '0.1.0'
  spec.summary = "An array class implemented in Swift that can be observed using ReactiveCocoa's Signals."
  spec.homepage = 'https://github.com/Wolox/ReactiveArray'
  spec.license = { :type => 'MIT', :file => 'LICENSE' }
  spec.author = {
    'Guido Marucci Blas' => 'guidomb@wolox.com.ar',
    'Wolox' => nil,
  }
  spec.social_media_url = 'http://twitter.com/wolox'
  spec.source = { :git => 'https://github.com/Wolox/ReactiveArray.git', :tag => "v#{spec.version}" }
  spec.source_files = 'ReactiveArray/**/*.{h,swift}'
  spec.requires_arc = true
  spec.ios.deployment_target = '8.0'
  spec.osx.deployment_target = '10.9'

  spec.dependency 'ReactiveCocoa', '3.0-beta.6'
  spec.framework = "Foundation"
end
