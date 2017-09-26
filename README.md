<p align="center">

<img src="http://image.tingxins.cn/TXScrollLabelView/master/scroll-label-view.png" width=600/>

</p>

<p align="center">

<a href="https://travis-ci.org/tingxins/TXScrollLabelView"><img src="https://img.shields.io/travis/tingxins/TXScrollLabelView.svg"></a>
<a href="https://github.com/Carthage/Carthage"><img src="https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat"></a>
<a href="http://cocoadocs.org/docsets/TXScrollLabelView"><img src="https://img.shields.io/cocoapods/v/TXScrollLabelView.svg?style=flat"></a>
<a href="https://github.com/tingxins/TXScrollLabelView"><img src="https://img.shields.io/cocoapods/p/TXScrollLabelView.svg?style=flat"></a>
<a href="https://github.com/tingxins/TXScrollLabelView"><img src="https://img.shields.io/badge/support-iOS%207%2B-brightgreen.svg"></a>
<a href="https://www.apache.org/licenses/LICENSE-2.0.html"><img src="http://img.shields.io/cocoapods/l/TXScrollLabelView.svg?style=flat"></a>


</p>

`TXScrollLabelView` is an iOS lightweight library that can displays adverts or boardcast e.g. with an custom view.

> [中文介绍](http://www.jianshu.com/p/8f1f1b1ee814)

![x-scroll-label-view](http://image.tingxins.cn/TXScrollLabelView/master/x-scroll-label-view.gif)

## Support what kinds of scrollType

- **TXScrollLabelViewTypeLeftRight** : scrolling from right to left, and cycle all contents(`scrollTitle`) in a single line.


- **TXScrollLabelViewTypeUpDown**: scrolling from bottom to top, and cycle all contents.


- **TXScrollLabelViewTypeFlipRepeat**: scrolling from bottom to top, and cycle the first line of your contents.


- **TXScrollLabelViewTypeFlipNoRepeat**: scrolling from bottom to top, and cycle all contents with a line once times.

And `scrollVelocity` property now supports all above enum of `TXScrollLabelViewType`, just enjoy it!

## Installation

There are three ways to use TXScrollLabelView in your project:

* Using CocoaPods

* Manual

* Using Carthage

### CocoaPods
    
CocoaPods is a dependency manager for Objective-C, which automates and simplifies the process of using 3rd-party libraries in your projects. 

**Podfile**

    platform :ios, '7.0'
    pod 'TXScrollLabelView'

### Manual

Download repo's zip, and just drag **ALL** files in the TXScrollLabelView folder to your projects. Import header file when you are using:

    #import "TXScrollLabelView.h"
   
### Carthage

[Carthage](https://github.com/Carthage/Carthage) is a decentralized dependency manager that builds your dependencies and provides you with binary frameworks.

You can install Carthage with [Homebrew](http://brew.sh/) using the following command:

    $ brew update
    $ brew install carthage
        
To integrate **TXScrollLableView** into your Xcode project using Carthage, specify it in your Cartfile:

    github "tingxins/TXScrollLableView"

Run carthage to build the frameworks and drag the framework into your Xcode project.
        
## Usage 

Now, TXScrollLabelView supports both **array & string**. just enjoy it. 👀

### Example

**Objective-C :**

    /** Step1: 滚动文字 */
    NSString *scrollTitle = @"xxxxxx";
    
    /** Step2: 创建 ScrollLabelView */
    TXScrollLabelView *scrollLabelView = [TXScrollLabelView scrollWithTitle:scrollTitle type:TXScrollLabelViewTypeFlipNoRepeat velocity:velocity options:UIViewAnimationOptionCurveEaseInOut];
    
    /** Step3: 设置代理进行回调(Optional) */
    scrollLabelView.scrollLabelViewDelegate = self;
    
    /** Step4: 布局(Required) */
    scrollLabelView.frame = CGRectMake(50, 100, 300, 30);
    [self.view addSubview:scrollLabelView];
    
    /** Step5: 开始滚动(Start scrolling!) */
    [scrollLabelView beginScrolling];
        
        
You can running **TXScrollLabelViewDemo** for more details.

**Swift :** Producting.([**Swift-version**](https://github.com/tingxins/ScrollLabelView))

### Delegate Method

Tap Gesture callback.

```

- (void)scrollLabelView:(TXScrollLabelView *)scrollLabelView didClickWithText:(NSString *)text atIndex:(NSInteger)index;

```

## Communication

Absolutely，you can contribute to this project all the time if you want to.

- If you **need help or ask general question**, just [**@tingxins**](http://weibo.com/tingxins) in `Weibo` or `Twitter`, ofcourse, you can access to my [**blog**](https://tingxins.com).

- If you **found a bug**, just open an issue.

- If you **have a feature request**, just open an issue.

- If you **want to contribute**, fork this repository, and then submit a pull request.

## License

`TXScrollLabelView` is available under the MIT license. See the LICENSE file for more info.

## Ad

Welcome to my Official Account of WeChat.

![wechat-qrcode](http://image.tingxins.cn/adv/wechat-qrcode.jpg)


