//
//  TYGridPassWordNode.h
//  TYGridPassWordDemo
//
//  Created by HongPu on 2015/12/23.
//  Copyright © 2015年 tinyxx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIColor+RGB.h"

#define TYGridPassWordNodeColorNormol      UIColorMake(0.8, 0.8, 0.8, 1)
#define TYGridPassWordNodeColorHighLight   UIColorMake(0, 0.478, 1, 1)
#define TYGridPassWordNodeColorError       UIColorMake(1, 0, 0, 1)
#define TYGridPassWordNodeSize             70

typedef NS_ENUM(NSUInteger, TYGridPassWordNodeState)
{
    TYGridPassWordNodeStateNormol = 1,
    TYGridPassWordNodeStateHighLight,
    TYGridPassWordNodeStateError,
};

@interface TYGridPassWordNode : UIView

@property (nonatomic, assign) TYGridPassWordNodeState state;

@end
