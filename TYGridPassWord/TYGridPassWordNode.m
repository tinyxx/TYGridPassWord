//
//  TYGridPassWordNode.m
//  TYGridPassWordDemo
//
//  Created by HongPu on 2015/12/23.
//  Copyright © 2015年 tinyxx. All rights reserved.
//

#import "TYGridPassWordNode.h"


@implementation TYGridPassWordNode


- (id)init
{
    self = [super init];
    if (self)
    {
        // Initialization code
        [self setBackgroundColor:[UIColor whiteColor]];
        [self setFrame:CGRectMake(0, 0, TYGridPassWordNodeSize, TYGridPassWordNodeSize)];
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    // made by three concentric circle
    NSInteger mult = @([[UIScreen mainScreen] scale]).integerValue;
    NSInteger r2 = self.frame.size.width / 2 * mult;
    
    // prepare
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetShouldAntialias(context, YES);
    CGContextSaveGState(context);
    CGAffineTransform t0 = CGContextGetCTM(context);
    t0 = CGAffineTransformInvert(t0);
    CGContextConcatCTM(context, t0);
    CGContextBeginPath(context);
    
    UIColor *currentColor;
    // color
    switch (self.state)
    {
        case TYGridPassWordNodeStateHighLight:
        {
            currentColor = TYGridPassWordNodeColorHighLight;
        }
            break;
            
        case TYGridPassWordNodeStateError:
        {
            currentColor = TYGridPassWordNodeColorError;
        }
            break;
            
        default:
        {
            currentColor = TYGridPassWordNodeColorNormol;
        }
            break;
    }
    
    // bottom
    CGContextSetRGBFillColor(context, currentColor.redColor, currentColor.greenColor, currentColor.blueColor, currentColor.alpha);
    CGContextAddArc(context, r2, r2, r2 - 10, 0, 2*M_PI, 1);
    CGContextClosePath(context);
    CGContextDrawPath(context, kCGPathFill);
    
    // change color
    UIColor *whiteColor = [UIColor whiteColor];
    // inner
    CGContextSetRGBFillColor(context, whiteColor.redColor, whiteColor.greenColor, whiteColor.blueColor, whiteColor.alpha);
    CGContextAddArc(context, r2, r2, r2 - 12, 0, 2*M_PI, 1);
    CGContextClosePath(context);
    CGContextDrawPath(context, kCGPathFill);

    // center
    CGContextSetRGBFillColor(context, currentColor.redColor, currentColor.greenColor, currentColor.blueColor, currentColor.alpha);
    CGContextAddArc(context, r2, r2, (r2 - 12) / 2, 0, 2*M_PI, 1);
    CGContextClosePath(context);
    CGContextDrawPath(context, kCGPathFill);
    CGContextRestoreGState(context);
}

@end
