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

@end

@implementation TYGridPassWordView

- (void)layoutSubviews
{
    [self configTYGridPassWordView];
}

- (void)configTYGridPassWordView
{
    [self.subviews enumerateObjectsUsingBlock:^(UIView * obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj removeFromSuperview];
    }];
    
    // round
    CGFloat startX = 0.0;
    CGFloat startY = 0.0;
    CGFloat mariginX = (self.frame.size.width - TYGridPassWordNodeSize * 3) / 2;
    CGFloat mariginY = (self.frame.size.height - TYGridPassWordNodeSize * 3) / 2;
    
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
            startX += mariginX;
            tempLineHeight = node.frame.size.height;
        }
        
        startX = 0;
        startY += tempLineHeight;
        startY += mariginY;
    }
    _arrayNodes = array;
    
    // Line
    _passWordLineView = [[TYGridPassWordLineView alloc] init];
    [_passWordLineView setFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    [self addSubview:_passWordLineView];
    
    //
    _arraySelect = [[NSMutableArray alloc] init];
    _isTouched = NO;
    _movingPoint = CGPointZero;
    
    // self
    [self setClipsToBounds:NO];
    [self setBackgroundColor:TYGridPassWordViewBackGroundColor];
    [self setFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, self.frame.size.height)];
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
    
    if (_delegate && [_delegate respondsToSelector:@selector(gridPassWordViewBeginCapture)])
    {
        [_delegate gridPassWordViewBeginCapture];
    }
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
    [self touchesFinish:touches withEvent:event];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self touchesFinish:touches withEvent:event];
}

- (void)touchesFinish:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    _isTouched = NO;
    _movingPoint = CGPointZero;
    
    [self refrushView];
    
    if (_delegate && [_delegate respondsToSelector:@selector(gridPassWordViewCapturePassWord:)])
    {
        if (_delegate && [_delegate respondsToSelector:@selector(gridPassWordViewFinishCapture)])
        {
            [_delegate gridPassWordViewFinishCapture];
        }
        
        if ([_delegate gridPassWordViewCapturePassWord:[self passWord]])
        {
            if ([_delegate respondsToSelector:@selector(gridPassWordViewInputCorrect)])
            {
                [_delegate gridPassWordViewInputCorrect];
            }
        }
        else
        {
            [self showError];
            if ([_delegate respondsToSelector:@selector(gridPassWordViewInputError)])
            {
                [_delegate gridPassWordViewInputError];
            }
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
