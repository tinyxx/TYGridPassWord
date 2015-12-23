//
//  TYGridPassWordPoint.h
//  TYGridPassWordDemo
//
//  Created by HongPu on 2015/12/23.
//  Copyright © 2015年 tinyxx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIColor+RGB.h"

typedef NS_ENUM(NSUInteger, TYGridPassWordPointState)
{
    TYGridPassWordPointStateNormol = 1,
    TYGridPassWordPointStateHighLight,
    TYGridPassWordPointStateError,
};


#define TYGridPassWordPointColorNormol      UIColorMake(0.8, 0.8, 0.8, 1)
#define TYGridPassWordPointColorHighLight   UIColorMake(0, 0.478, 1, 1)
#define TYGridPassWordPointColorError       UIColorMake(1, 0, 0, 1)
#define TYGridPassWordPointLength           70

@interface TYGridPassWordPoint : UIView

@property (nonatomic, assign) TYGridPassWordPointState state;

@end
