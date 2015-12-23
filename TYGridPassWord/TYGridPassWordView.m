//
//  TYGridPassWordView.m
//  TYGridPassWordDemo
//
//  Created by HongPu on 2015/12/23.
//  Copyright © 2015年 tinyxx. All rights reserved.
//

#import "TYGridPassWordView.h"
#import "TYGridPassWordLineView.h"
#import "TYGridPassWordPoint.h"

@interface TYGridPassWordView ()

@property (nonatomic, strong) NSArray<TYGridPassWordPoint *> *arrayPoints;
@property (nonatomic, strong) TYGridPassWordLineView *passWordLineView;
@property (nonatomic, strong) NSMutableArray *arraySelect;
@property (nonatomic, assign) BOOL isTouched;
@property (nonatomic, assign) CGPoint movingPoint;

@end

@implementation TYGridPassWordView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self configTYGridPassWordView];
    }
    
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        [self configTYGridPassWordView];
    }
    
    return self;
}

- (id)init
{
    self = [super init];
    if (self)
    {
        [self configTYGridPassWordView];
    }
    return self;
}

- (void)configTYGridPassWordView
{
    // round
    CGFloat startX = 0.0;
    CGFloat startY = 0.0;
    CGFloat marigin = (TYGridPassWordViewLength - TYGridPassWordPointLength * 3) / 2;
    
    NSMutableArray<TYGridPassWordPoint *> *array = [[NSMutableArray alloc] init];
    for (int i=0; i<TYGridPassWordViewMatrixSize; i++)
    {
        CGFloat tempLineHeight = 0.0;
        for (int j=0; j<TYGridPassWordViewMatrixSize; j++)
        {
            TYGridPassWordPoint *circle = [[TYGridPassWordPoint alloc] init];
            [circle setFrame:CGRectMake(startX, startY, circle.frame.size.width, circle.frame.size.height)];
            [circle setState:TYGridPassWordPointStateNormol];
            [self addSubview:circle];
            [array addObject:circle];
            
            startX += circle.frame.size.width;
            startX += marigin;
            tempLineHeight = circle.frame.size.height;
        }
        
        startX = 0;
        startY += tempLineHeight;
        startY += marigin;
    }
    _arrayPoints = array;
    
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
    [self setFrame:CGRectMake(0, 0, TYGridPassWordViewLength, TYGridPassWordViewLength)];
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
    for (TYGridPassWordPoint *circle in self.arrayPoints)
    {
        [circle setState:TYGridPassWordPointStateNormol];
    }
    
    [_passWordLineView setState:TYGridPassWordLineViewStateNormal];
    
    self.movingPoint = CGPointZero;
    self.arraySelect = [[NSMutableArray alloc] init];
    
    [self refrushView];
}

- (void)refrushView
{
    // current point
    NSMutableArray *arrayPoint = [[NSMutableArray alloc] init];
    for (TYGridPassWordPoint *circle in self.arraySelect)
    {
        [arrayPoint addObject:[NSValue valueWithCGPoint:[circle center]]];
    }
    
    // touched point
    if (_isTouched)
    {
        [arrayPoint addObject:[NSValue valueWithCGPoint:_movingPoint]];
    }
    
    [_passWordLineView setArrayPoints:arrayPoint];
    [_passWordLineView setNeedsDisplay];
    
    for (TYGridPassWordPoint *circle in self.arrayPoints)
    {
        [circle setNeedsDisplay];
    }
}

- (void)checkCircelIsSelect:(CGPoint)point
{
    for (TYGridPassWordPoint *circle in self.arrayPoints)
    {
        if (circle.state == TYGridPassWordPointStateNormol && CGRectContainsPoint(circle.frame, point) && [self isSmallThanRadius:circle andPoint:point])
        {
            [circle setState:TYGridPassWordPointStateHighLight];
            [self.arraySelect addObject:circle];
            break;
        }
    }
}

- (BOOL)isSmallThanRadius:(TYGridPassWordPoint *)circle andPoint:(CGPoint)point
{
    if (CGRectContainsPoint(CGRectMake(circle.frame.origin.x + circle.frame.size.width * 0.1,
                                       circle.frame.origin.y + circle.frame.size.height * 0.1, circle.frame.size.width * 0.8, circle.frame.size.height * 0.8), point))
    {
        return YES;
    }
    
    return NO;
}

- (NSString *)passWord
{
    NSMutableString *passWord = [[NSMutableString alloc] init];
    
    for (TYGridPassWordPoint *circle in self.arraySelect)
    {
        NSInteger index = [self.arrayPoints indexOfObject:circle];
        [passWord appendString:[NSString stringWithFormat:@"%i", (int)index]];
    }
    
    return passWord;
}

- (void)showError
{
    for (TYGridPassWordPoint *circle in self.arraySelect)
    {
        [circle setState:TYGridPassWordPointStateError];
    }
    
    [_passWordLineView setState:TYGridPassWordLineViewStateError];
    [self refrushView];
}


@end
