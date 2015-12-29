[![Cocoapods Compatible](https://img.shields.io/cocoapods/v/TYGridPassWord.svg)](https://img.shields.io/cocoapods/v/TYGridPassWord.svg)
[![Carthage Compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
[![Platform](https://img.shields.io/cocoapods/p/TYGridPassWord.svg?style=flat)](http://cocoadocs.org/docsets/TYGridPassWord)
[![License](https://img.shields.io/cocoapods/l/TYGridPassWord.svg?style=flat)](http://cocoadocs.org/docsets/TYGridPassWord)

# TYGridPassWord

A iOS7 Style Grid PassWord View by Objective-C

![TYGridPassWord](http://7xplk8.com1.z0.glb.clouddn.com/TYGridPassWord.gif)

## Requirements
iOS8 or higher

## Installations

CocoaPods:
```
pod 'TYGridPassWord'
```
Carthage:
```
github "tinyxx/TYGridPassWord"
```

## Usage

It is quite easy to use:

``` objc
TYGridPassWordView *gridPassWordView = [[TYGridPassWordView alloc] init];
gridPassWordView.delegate = delegateObj;
[superView addSubView:gridPassWordView];
```
TYGridPassWordViewDelegate:
``` objc
- (BOOL)gridPassWordViewCapturePassWord:(NSString *)passWord
{
    if ([passWord isEqualToString:PassWordUserSetBefore])
    {
        return YES;
    }
    return NO;
}
```

For more infomation, please check the demo project, Thanks!



## License

MIT LICENSE
