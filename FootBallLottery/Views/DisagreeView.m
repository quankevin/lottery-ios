//
//  DisagreeView.m
//  FootBallLottery
//
//  Created by jaye on 15/1/10.
//  Copyright (c) 2015年 jaye. All rights reserved.
//

#import "DisagreeView.h"
#import "UIView+CTDialog.h"

@implementation DisagreeView

- (void)awakeFromNib
{
    self.disAgreeTextField.delegate = self;
}

#pragma mark - textField delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    return [self.disAgreeTextField resignFirstResponder];
}

- (IBAction)doneActionClick:(id)sender
{
    if(self.disAgreeTextField.text.length == 0)
    {
        [Utils showMessage:@"不赞同原因不能为空"];
        return;
    }
    
    if(![[AppDelegate getAppDelegate] isLogin])
    {
        [self.dialogView close];
        [Utils showMessage:@"您还未登陆，请先登陆"];
        return;
    }
    
    [self.dialogView close];
    [self.delegate handDisagree:self.disAgreeTextField.text];
}

@end
