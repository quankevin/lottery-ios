//
//  MoreTollgateView.m
//  FootBallLottery
//
//  Created by jaye on 15/1/25.
//  Copyright (c) 2015年 jaye. All rights reserved.
//

#import "MoreTollgateView.h"
#import "UIView+CTDialog.h"

@implementation MoreTollgateView

- (void)awakeFromNib
{
    self.tollgateArray = [[NSMutableArray alloc] initWithArray:[[AppDelegate getAppDelegate] tollgateArray]];
    for(int i = 0;i < self.tollgateArray.count;i++)
    {
        NSString *tollgateStr = [self.tollgateArray objectAtIndex:i];
        NSArray *array = [tollgateStr componentsSeparatedByString:@"*"];
        tollgateStr = [NSString stringWithFormat:@"%@串%@",[array objectAtIndex:0],[array objectAtIndex:1]];
        for(int j = 1;j < 27;j++)
        {
            UIButton *btn = (UIButton *)[self viewWithTag:j];
            
            if([btn.titleLabel.text isEqualToString:tollgateStr])
            {
                [btn setBackgroundImage:[UIImage imageNamed:@"chuanguan-active_01.png"] forState:UIControlStateNormal];
            }
        }
    }
}

//选择串关
- (IBAction)selectTollgateAction:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    
    NSArray *array = [btn.titleLabel.text componentsSeparatedByString:@"串"];
    NSString *tollgateStr = [NSString stringWithFormat:@"%@*%@",[array objectAtIndex:0],[array objectAtIndex:1]];
    
    if([self.tollgateArray containsObject:tollgateStr])
    {
        [btn setBackgroundImage:[UIImage imageNamed:@"chuanguan-normal_01.png"] forState:UIControlStateNormal];
        [self.tollgateArray removeObject:tollgateStr];
    }
    else
    {
        [btn setBackgroundImage:[UIImage imageNamed:@"chuanguan-active_01.png"] forState:UIControlStateNormal];
        [self.tollgateArray addObject:tollgateStr];
    }
}

//取消
- (IBAction)cancleActionClick:(id)sender
{
    [self.dialogView close];
}

//确定
- (IBAction)doneActionClick:(id)sender
{
    if([[AppDelegate getAppDelegate] tollgateArray].count == 0)
    {
        [Utils showMessage:@"请选择串关"];
        return;
    }
    
    [[AppDelegate getAppDelegate] setTollgateArray:self.tollgateArray];
    [self.delegate selectTollgate];
    [self.dialogView close];
}


@end
