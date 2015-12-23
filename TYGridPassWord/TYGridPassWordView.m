//
//  TYGridPassWordView.m
//  TYGridPassWordDemo
//
//  Created by HongPu on 2015/12/23.
//  Copyright © 2015年 tinyxx. All rights reserved.
//

#import "TYGridPassWordView.h"
#import "TYGridPassWordLineView.h"
#import "TYGridPassWordNode.h"

#define TYGridPassWordViewMatrixSize        3

@interface TYGridPassWordView ()

@property (nonatomic, strong) NSArray<TYGridPassWordNode *> *arrayNodes;
@property (nonatomic, strong) TYGridPassWordLineView *passWordLineView;
@property (nonatomic, strong) NSMutableArray *arraySelect;
@property (nonatomic, assign) BOOL isTouched;
@property (nonatomic, assign) CGPoint movingPoint;
@property (nonatomic, assign) dispatch_once_t once;

@end

@implementation TYGridPassWordView

- (void)layoutSubviews
{
    dispatch_once(&_once, ^{
        [self configTYGridPassWordView];
    });
}

- (void)configTYGridPassWordView
{
    // round
    CGFloat startX = 0.0;
    CGFloat startY = 0.0;
    CGFloat marigin = (TYGridPassWordViewSize - TYGridPassWordNodeSize * 3) / 2;
    
    NSMutableArray<TYGridPassWordNode *> *array = [[NSMutableArray alloc] init];
    for (int i=0; i<TYGridPassWordViewMatrixSize; i++)
    {
        CGFloat tempLineHeight = 0.0;
        for (int j=0; j<TYGridPassWordViewMatrixSize; j++)
        {
            TYGridPassWordNode *node = [[TYGridPassWordNode alloc] init];
            [node setFrame:CGRectMake(startX, startY, node.frame.size.width, node.frame.size.height)];
            [node setState:TYGridPassWordNodeStateNormol];
            [self addSubview:node];
            [array addObject:node];
            
            startX += node.frame.size.width;
            startX += marigin;
            tempLineHeight = node.frame.size.height;
        }
        
        startX = 0;
        startY += tempLineHeight;
        startY += marigin;
    }
    _arrayNodes = array;
    
    // Line
    _passWordLineView = [[TYGridPassWordLineView alloc] init];
    [self addSubview:_passWordLineView];
    
    //
    _arraySelect = [[NSMutableArray alloc] init];
    _isTouched = NO;
    _movingPoint = CGPointZero;
    
    // self
    [self setClipsToBounds:NO];
    [self setBackgroundColor:TYGridPassWordViewBackGroundColor];
    [self setFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y, TYGridPassWordViewSize, TYGridPassWordViewSize)];
}

#pragma - mark touchs

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch* touch = [touches anyObject];
    CGPoint p = [touch locationInView:self];
    
    _isTouched = YES;
    _movingPoint = p;
    
    [self checkCircelIsSelect:p];
    [self refrushView];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch* touch = [touches anyObject];
    CGPoint p = [touch locationInView:self];
    
    _movingPoint = p;
    
    [self checkCircelIsSelect:p];
    [self refrushView];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    _isTouched = NO;
    _movingPoint = CGPointZero;
    
    [self refrushView];
    
    if (_delegate && [_delegate respondsToSelector:@selector(gridPassWordViewCapturePassWord:)])
    {
        if (![_delegate gridPassWordViewCapturePassWord:[self passWord]])
        {
            [self showError];
        }
    }
    
    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
    [self performSelector:@selector(clearSelect) withObject:nil afterDelay:TYGridPassWordViewTimeInterval];
    [[UIApplication sharedApplication] performSelector:@selector(endIgnoringInteractionEvents) withObject:nil afterDelay:TYGridPassWordViewTimeInterval];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    _isTouched = NO;
    _movingPoint = CGPointZero;
    
    [self refrushView];
    
    if (_delegate && [_delegate respondsToSelector:@selector(gridPassWordViewCapturePassWord:)])
    {
        if (![_delegate gridPassWordViewCapturePassWord:[self passWord]])
        {
            [self showError];
        }
    }
    
    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
    [self performSelector:@selector(clearSelect) withObject:nil afterDelay:TYGridPassWordViewTimeInterval];
    [[UIApplication sharedApplication] performSelector:@selector(endIgnoringInteractionEvents) withObject:nil afterDelay:TYGridPassWordViewTimeInterval];
}

#pragma - mark private func

- (void)clearSelect
{
    for (TYGridPassWordNode *node in self.arrayNodes)
    {
        [node setState:TYGridPassWordNodeStateNormol];
    }
    
    [_passWordLineView setState:TYGridPassWordLineViewStateNormal];
    
    self.movingPoint = CGPointZero;
    self.arraySelect = [[NSMutableArray alloc] init];
    
    [self refrushView];
}

- (void)refrushView
{
    // current point
    NSMutableArray *arrayNodes = [[NSMutableArray alloc] init];
    for (TYGridPassWordNode *node in self.arraySelect)
    {
        [arrayNodes addObject:[NSValue valueWithCGPoint:[node center]]];
    }
    
    // touched point
    if (_isTouched)
    {
        [arrayNodes addObject:[NSValue valueWithCGPoint:_movingPoint]];
    }
    
    [_passWordLineView setArrayPoints:arrayNodes];
    [_passWordLineView setNeedsDisplay];
    
    for (TYGridPassWordNode *node in self.arrayNodes)
    {
        [node setNeedsDisplay];
    }
}

- (void)checkCircelIsSelect:(CGPoint)point
{
    for (TYGridPassWordNode *node in self.arrayNodes)
    {
        if (node.state == TYGridPassWordNodeStateNormol && CGRectContainsPoint(node.frame, point) && [self isSmallThanRadius:node andPoint:point])
        {
            [node setState:TYGridPassWordNodeStateHighLight];
            [self.arraySelect addObject:node];
            break;
        }
    }
}

- (BOOL)isSmallThanRadius:(TYGridPassWordNode *)node andPoint:(CGPoint)point
{
    if (CGRectContainsPoint(CGRectMake(node.frame.origin.x + node.frame.size.width * 0.1,
                                       node.frame.origin.y + node.frame.size.height * 0.1, node.frame.size.width * 0.8, node.frame.size.height * 0.8), point))
    {
        return YES;
    }
    
    return NO;
}

- (NSString *)passWord
{
    NSMutableString *passWord = [[NSMutableString alloc] init];
    
    for (TYGridPassWordNode *node in self.arraySelect)
    {
        NSInteger index = [self.arrayNodes indexOfObject:node] + 1;
        [passWord appendString:[NSString stringWithFormat:@"%i", (int)index]];
    }
    
    return passWord;
}

- (void)showError
{
    for (TYGridPassWordNode *node in self.arraySelect)
    {
        [node setState:TYGridPassWordNodeStateError];
    }
    
    [_passWordLineView setState:TYGridPassWordLineViewStateError];
    [self refrushView];
}


@end
