# ReactiveArray

[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
[![Build Status](https://travis-ci.org/Wolox/ReactiveArray.svg?branch=master)](https://travis-ci.org/Wolox/ReactiveArray)
[![Coverage Status](https://coveralls.io/repos/Wolox/ReactiveArray/badge.svg?branch=master&service=github)](https://coveralls.io/github/Wolox/ReactiveArray?branch=master)

An array class implemented in Swift that can be observed using [ReactiveCocoa](https://github.com/ReactiveCocoa/ReactiveCocoa)'s Signals.

## Installation

### [Carthage]

[Carthage]: https://github.com/Carthage/Carthage

Add the following to your Cartfile:

```
github "Wolox/ReactiveArray"
```

Then run `carthage update`.

Follow the current instructions in [Carthage's README][carthage-installation]
for up to date installation instructions.

[carthage-installation]: https://github.com/Carthage/Carthage#adding-frameworks-to-an-application

You'll also need to add `Result.framework`, `Box.framework` and `ReactiveCocoa.framework` to your Xcode
project.

[Box]: https://github.com/robrix/box
[Result]: https://github.com/antitypical/Result
[ReactiveCocoa]: https://github.com/ReactiveCocoa/ReactiveCocoa

## Usage

TODO

## Contributing

### Setup project

If you want to contribute you need to setup your
development environment first.

    git clone https://github.com/Wolox/ReactiveArray.git
    cd ReactiveArray
    script/bootstrap
    open ReactiveArray.xcodeproj

#### Environment dependencies

The following dependencies must be installed in your development machine.

 * XCode & XCode command line tools
 * Homebrew
 * Ruby
 * Bundler (sudoless)
 * Carthage
 * Gcovr
 * SwiftCov

## About

This project is maintained by [Guido Marucci Blas](https://github.com/guidomb) and it was written by [Wolox](http://www.wolox.com.ar).

![Wolox](https://raw.githubusercontent.com/Wolox/press-kit/master/logos/logo_banner.png)

## License

**ReactiveArray** is available under the MIT [license](https://raw.githubusercontent.com/Wolox/ReactiveArray/master/LICENSE).

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
