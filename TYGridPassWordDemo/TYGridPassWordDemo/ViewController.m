//
//  ViewController.m
//  TYGridPassWordDemo
//
//  Created by HongPu on 2015/12/21.
//  Copyright © 2015年 tinyxx. All rights reserved.
//

#import "ViewController.h"
#import "TYGridPassWordView.h"

static NSString* defaultPassWord = @"012";

@interface ViewController () <TYGridPassWordViewDelegate>

@property (nonatomic, weak) IBOutlet TYGridPassWordView *passWordView;
@property (nonatomic, copy) NSString *passWord;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma - mark delegate
- (BOOL)gridPassWordViewCapturePassWord:(NSString *)passWord
{
    if ([passWord isEqualToString:defaultPassWord])
    {
        return YES;
    }
    
    return NO;
}

@end
