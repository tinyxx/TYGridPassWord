//
//  UIColor+RGB.h
//  TYGridPassWordDemo
//
//  Created by HongPu on 2015/12/23.
//  Copyright © 2015年 tinyxx. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (RGB)

#define UIColorMake(r, g, b, a) [[UIColor alloc] initWithRed:(r) green:(g) blue:(b) alpha: (a)];

- (CGFloat)redColor;
- (CGFloat)greenColor;
- (CGFloat)blueColor;
- (CGFloat)alpha;

@end
