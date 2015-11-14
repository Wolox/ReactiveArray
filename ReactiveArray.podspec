Pod::Spec.new do |spec|
  spec.name         = 'ReactiveArray'
  spec.version      = '0.5.0'
  spec.license = { :type => 'MIT', :text => <<-LICENSE
Copyright (c) 2015 Guido Marucci Blas <guidomb@wolox.com.ar>

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
                 LICENSE
               	    }
  spec.homepage     = 'https://github.com/Wolox/ReactiveArray'
  spec.authors      =  {'Guido Marucci Blas' => 'guidomb@gmail.com','Wolox' => 'http://www.wolox.com.ar' }
  spec.summary      = 'An array class implemented in Swift that can be observed using ReactiveCocoa's Signals.'
  spec.source       =  {:git => 'https://github.com/Wolox/ReactiveArray.git', :tag => 'v0.5.0' }
  spec.source_files = 'ReactiveArray/*.{swift,h}'
  spec.requires_arc = true
  spec.dependency 'ReactiveCocoa', '4.0.0-alpha-3'
end
