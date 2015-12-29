//
//  TYGridPassWordLine.h
//  TYGridPassWordDemo
//
//  Created by HongPu on 2015/12/23.
//  Copyright © 2015年 tinyxx. All rights reserved.
//

#import <UIKit/UIKit.h>

#define TYGridPassWordLineViewColorError        UIColorMake(1, 0, 0, 1)
#define TYGridPassWordLineViewColorNormal       UIColorMake(0, 0.478, 1, 1)
#define TYGridPassWordLineViewSingleLineWidth   8.0

typedef NS_ENUM(NSUInteger, TYGridPassWordLineViewState)
{
    TYGridPassWordLineViewStateNormal = 1,
    TYGridPassWordLineViewStateError,
};

@interface TYGridPassWordLineView : UIView

@property (nonatomic, strong) NSArray<NSValue *> *arrayPoints;
@property (nonatomic, assign) TYGridPassWordLineViewState state;

@end
