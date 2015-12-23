# TYGridPassWord

A iOS7 Style Grid PassWord View by Objective-C

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
