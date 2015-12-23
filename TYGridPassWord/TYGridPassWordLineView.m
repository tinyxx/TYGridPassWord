//
//  TYGridPassWordLine.m
//  TYGridPassWordDemo
//
//  Created by HongPu on 2015/12/23.
//  Copyright © 2015年 tinyxx. All rights reserved.
//

#import "TYGridPassWordLineView.h"
#import "TYGridPassWordView.h"
#import "UIColor+RGB.h"

@implementation TYGridPassWordLineView

- (id)init
{
    self = [super init];
    if (self)
    {
        // Initialization code
        [self setState:TYGridPassWordLineViewStateNormal];
        [self setClipsToBounds:NO];
        [self setFrame:CGRectMake(0, 0, TYGridPassWordViewLength, TYGridPassWordViewLength)];
        [self setBackgroundColor:[UIColor clearColor]];
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    if (self.arrayPoints != nil && [self.arrayPoints count] > 1)
    {
        CGPoint p0 = [[self.arrayPoints objectAtIndex:0] CGPointValue];
        
        // translate Coord
        translateCoordSystem(&p0);
        
        // prepare
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSetShouldAntialias(context, YES);
        CGContextSaveGState(context);
        CGAffineTransform t0 = CGContextGetCTM(context);
        t0 = CGAffineTransformInvert(t0);
        CGContextConcatCTM(context, t0);
        CGContextBeginPath(context);
        // color
        UIColor *currentColor;
        switch (self.state)
        {
            case TYGridPassWordLineViewStateError:
            {
                currentColor = TYGridPassWordLineViewColorError;
            }
                break;
                
            default:
            {
                currentColor = TYGridPassWordLineViewColorNormal;
            }
                break;
        }
        
        CGContextSetRGBStrokeColor(context, currentColor.redColor, currentColor.greenColor, currentColor.blueColor, currentColor.alpha);
        CGContextSetLineWidth(context, TYGridPassWordLineViewSingleLineWidth);
        CGContextMoveToPoint(context, p0.x, p0.y);
        
        for (int i=1; i<[self.arrayPoints count]; i++)
        {
            CGPoint p1 = [[self.arrayPoints objectAtIndex:i] CGPointValue];
            // translate Coord
            translateCoordSystem(&p1);
            CGContextAddLineToPoint(context, p1.x, p1.y);
        }
        
        CGContextStrokePath(context);
        CGContextDrawPath(context, kCGPathFill);
        CGContextRestoreGState(context);
    }
}

void translateCoordSystem(CGPoint *point)
{
    NSInteger mult = @([[UIScreen mainScreen] scale]).integerValue;
    // if retina screen
    point->x = point->x * mult;
    point->y = point->y * mult;
    // translate Coord System
    point->y = mult * TYGridPassWordViewLength - point->y;
}

@end
