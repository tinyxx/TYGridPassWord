//
//  UIColor+RGB.m
//  TYGridPassWordDemo
//
//  Created by HongPu on 2015/12/23.
//  Copyright © 2015年 tinyxx. All rights reserved.
//

#import "UIColor+RGB.h"
#import <objc/runtime.h>

@implementation UIColor (RGB)

static void *kRGBDictKey = &kRGBDictKey;
static const NSString *kRGBDictRedColorKey      = @"kRGBDictRedColorKey";
static const NSString *kRGBDictGreenColorKey    = @"kRGBDictGreenColorKey";
static const NSString *kRGBDictBlueColorKey     = @"kRGBDictBlueColorKey";
static const NSString *kRGBDictAlphaKey         = @"kRGBDictAlphaKey";

- (CGFloat)redColor
{
    return [[[self RGBValue] objectForKey:kRGBDictRedColorKey] floatValue];
}

- (CGFloat)greenColor
{
    return [[[self RGBValue] objectForKey:kRGBDictGreenColorKey] floatValue];
}

- (CGFloat)blueColor
{
    return [[[self RGBValue] objectForKey:kRGBDictBlueColorKey] floatValue];
}

- (CGFloat)alpha
{
    return [[[self RGBValue] objectForKey:kRGBDictAlphaKey] floatValue];
}

- (NSDictionary *)RGBValue
{
    id obj = objc_getAssociatedObject(self, &kRGBDictKey);
    if (obj && [obj isKindOfClass:[NSDictionary class]])
    {
        return [(NSDictionary *)obj copy];
    }
    
    CGFloat red = 0.0;
    CGFloat green = 0.0;
    CGFloat blue = 0.0;
    CGFloat alpha = 0.0;
    
    [self getRed:&red green:&green blue:&blue alpha:&alpha];
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:@(red), kRGBDictRedColorKey, @(green), kRGBDictGreenColorKey, @(blue), kRGBDictBlueColorKey, @(alpha), kRGBDictAlphaKey, nil];
    
    objc_setAssociatedObject(self, &kRGBDictKey, dict, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    return [dict copy];
}

@end
