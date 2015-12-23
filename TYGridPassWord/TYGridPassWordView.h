//
//  TYGridPassWordView.h
//  TYGridPassWordDemo
//
//  Created by HongPu on 2015/12/23.
//  Copyright © 2015年 tinyxx. All rights reserved.
//

#import <UIKit/UIKit.h>

#define TYGridPassWordViewLength            280
#define TYGridPassWordViewBackGroundColor   [UIColor whiteColor]
#define TYGridPassWordViewMatrixSize        3
#define TYGridPassWordViewTimeInterval      0.5

@protocol TYGridPassWordViewDelegate <NSObject>

@required
- (BOOL)gridPassWordViewCapturePassWord:(NSString *)passWord;

@end


@interface TYGridPassWordView : UIView

@property (nonatomic, weak) IBOutlet id<TYGridPassWordViewDelegate> delegate;

@end
