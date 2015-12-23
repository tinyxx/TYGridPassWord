//
//  ViewController.m
//  TYGridPassWordDemo
//
//  Created by HongPu on 2015/12/21.
//  Copyright © 2015年 tinyxx. All rights reserved.
//

#import "ViewController.h"
#import "TYGridPassWordView.h"

static NSString* defaultPassWord = @"1235789";

@interface ViewController () <TYGridPassWordViewDelegate>

@property (nonatomic, weak) IBOutlet TYGridPassWordView *passWordView;
@property (nonatomic, weak) IBOutlet UILabel *passWordLabel;
@property (nonatomic, weak) IBOutlet UILabel *hintLabel;
@property (nonatomic, copy) NSString *passWord;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self.passWordLabel setText:[NSString stringWithFormat:@"PassWord:%@", defaultPassWord]];
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
        [self.hintLabel setText:@"Correct!!!"];
        [self.hintLabel setTextColor:[[UIColor alloc] initWithRed:0 green:0.478 blue:1 alpha:1]];
        [self.hintLabel setAlpha:1];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [UIView animateWithDuration:0.5 animations:^{
                [self.hintLabel setAlpha:0];
            }];
        });
        return YES;
    }
    
    [self.hintLabel setText:@"ERROR!!!"];
    [self.hintLabel setTextColor:[UIColor redColor]];
    [self.hintLabel setAlpha:1];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:0.5 animations:^{
            [self.hintLabel setAlpha:0];
        }];
    });
    
    return NO;
}

@end
