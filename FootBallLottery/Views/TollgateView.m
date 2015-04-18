//
//  TollgateView.m
//  FootBallLottery
//
//  Created by jaye on 15/1/25.
//  Copyright (c) 2015年 jaye. All rights reserved.
//

#import "TollgateView.h"
#import "UIView+CTDialog.h"

@implementation TollgateView

- (void)awakeFromNib
{
    self.btnArray = [[NSMutableArray alloc] initWithObjects:self.singleBtn,self.twoBtn,self.threeBtn,self.fourBtn,self.fiveBtn, nil];
}

//选择串关
- (IBAction)selectTollgateAction:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    for(int i = 0; i < self.btnArray.count;i++)
    {
        UIButton *button = [self.btnArray objectAtIndex:i];
        if(i == btn.tag - 30)
        {
            [button setBackgroundImage:[UIImage imageNamed:@"chuanguan-active_01.png"] forState:UIControlStateNormal];
        }
        else
        {
            [button setBackgroundImage:[UIImage imageNamed:@"chuanguan_normal_01.png"] forState:UIControlStateNormal];
        }
    }
}

//更多过关方式
- (IBAction)moreTollgateAction:(id)sender
{
    CGRect frame = self.frame;
    frame.size.height = 400;
    self.frame = frame;
    
    [self.dialogView close];
    [self.delegate selectTollgate];
}

@end
