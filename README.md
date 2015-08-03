# ReactiveArray

[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
[![Circle CI](https://circleci.com/gh/Wolox/ReactiveArray.svg?style=svg)](https://circleci.com/gh/Wolox/ReactiveArray)
[![Build Status](https://travis-ci.org/Wolox/ReactiveArray.svg?branch=master)](https://travis-ci.org/Wolox/ReactiveArray)
[![Coverage Status](https://coveralls.io/repos/Wolox/ReactiveArray/badge.svg?branch=master&service=github)](https://coveralls.io/github/Wolox/ReactiveArray?branch=master)
[![Release](https://img.shields.io/github/release/Wolox/ReactiveArray.svg)](https://github.com/Wolox/ReactiveArray/releases)
[![Join the chat at https://gitter.im/Wolox/ReactiveArray](https://badges.gitter.im/Join%20Chat.svg)](https://gitter.im/Wolox/ReactiveArray?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge)

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

### Array operations

```swift
let array = ReactiveArray(elements: [1,2,3])

array.append(4) // => [1,2,3,4]
array.append(5) // => [1,2,3,4,5]

array[0] = 5 // => [5,2,3,4,5]
array.removeAtIndex(4) // => [5,2,3,4]
```

`ReactiveArray` conforms to `CollectionType` and `MutableCollectionType` which allows you to perform operations like
`map` or `filter`.

### Observing changes

The array can be observed for mutations using the `signal` or `producer` properties. Both `Signal` and `SignalProducer` will emit `Operation` values on observation for any of the mutating
operations performed to the array.

`Operation` is an enumeration with three cases. One for each
mutating operation: `Append`, `Insert` and `RemoveElement`

#### Using `SignalProducer`

Prints an append operation for each element
that has already been stored in the array and then
the corresponding operation for any new operation performed to the array.

```swift
let array = ReactiveArray(elements: [1,2,3])
array.producer |> start(next: { println($0) })
array[0] = 5
array[1] = 4
array.append(2)
array.removeAtIndex(2)
```

will print the following output:

```
.Append(value: 1)
.Append(value: 2)
.Append(value: 3)
.Insert(value: 5, atIndex: 0)
.Insert(value: 4, atIndex: 1)
.RemoveElement(atIndex:2)
```

#### Using `Signal`

The signal property will only emit values for operations performed in the array after observation.

```swift
let array = ReactiveArray(elements: [1,2,3])
array.signal.observe { println($0) }
array[0] = 5
array[1] = 4
array.append(2)
array.removeAtIndex(2)
```

will print the following output:

```
.Insert(value: 5, atIndex: 0)
.Insert(value: 4, atIndex: 1)
.RemoveElement(atIndex:2)
```

#### Using `observableCount`

You can also observe the `observableCount` property that exposes a producer that emits the current amount of elements each time the array is mutated.

```swift
let array = ReactiveArray<String>()
array.observableCount.producer |> start(next: { println($0) })
array.append("Hello")
array.append("World")
```

will print the following output:

```
0
1
2
```

### Mirror

Mirror creates a new `ReactiveArray` by applying a `transform` operation for each element contained in the original array. It is like `map` but the returned array will mutate everytime the original array mutates.

```swift
let array = ReactiveArray(elements: [1,2,3])
let doubles = array.mirror { $0 * 2 }
doubles.producer |> start(next: { println($0) })
array.append(4)
array.append(5)
array[0] = 6
```

will print the following output:

```
.Append(value: 2)
.Append(value: 4)
.Append(value: 6)
.Append(value: 8)
.Append(value: 10)
.Insert(value: 12, atIndex: 0)
```


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
