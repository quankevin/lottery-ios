//
//  SelectNum.m
//  FootBallLottery
//
//  Created by jaye on 15/2/1.
//  Copyright (c) 2015年 jaye. All rights reserved.
//

#import "SelectNum.h"
#import "UIView+CTDialog.h"

@implementation SelectNum


#pragma mark - textfield delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    return [textField resignFirstResponder];
}

- (IBAction)doneAction:(id)sender
{
    if(self.numTextField.text.length == 0)
    {
        [Utils showMessage:@"请输入倍数"];
        return;
    }
    
    if([self.numTextField.text isEqualToString:@"0"])
    {
        [Utils showMessage:@"倍数不能为0"];
        return;
    }
    
    if([self.numTextField.text intValue] > 100)
    {
        [Utils showMessage:@"倍数不能超过100"];
        return;
    }
    
    [self.delegate selectCount:self.numTextField.text];
    
    [self.dialogView close];
}


@end
