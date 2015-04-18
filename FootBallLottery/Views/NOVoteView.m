//
//  NOVoteView.m
//  FootBallLottery
//
//  Created by jaye on 15/1/25.
//  Copyright (c) 2015年 jaye. All rights reserved.
//

#import "NOVoteView.h"
#import "UIView+CTDialog.h"

@implementation NOVoteView


//去充值
- (IBAction)rechargeMoneyAction:(id)sender
{
    [self.dialogView close];
    [self.delegate rechargeAction];
}

@end
