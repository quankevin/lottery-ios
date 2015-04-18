//
//  DisagreeView.h
//  FootBallLottery
//
//  Created by jaye on 15/1/10.
//  Copyright (c) 2015年 jaye. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@protocol DisagreeViewDelegate <NSObject>

- (void)handDisagree:(NSString *)disagreeStr;

@end

@interface DisagreeView : UIView<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *disAgreeTextField;
@property (nonatomic, retain) id<DisagreeViewDelegate> delegate;

@end
