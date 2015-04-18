//
//  VoteView.m
//  FootBallLottery
//
//  Created by jaye on 15/1/10.
//  Copyright (c) 2015年 jaye. All rights reserved.
//

#import "VoteView.h"
#import "UIView+CTDialog.h"

@implementation VoteView

//投注
- (IBAction)doneVote:(id)sender
{
    [self.dialogView close];
    [self.delegate voteAction];
}

@end
