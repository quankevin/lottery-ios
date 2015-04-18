//
//  VoteRecordTableViewCell.m
//  FootBallLottery
//
//  Created by jaye on 15/1/3.
//  Copyright (c) 2015年 jaye. All rights reserved.
//

#import "VoteRecordTableViewCell.h"

@implementation VoteRecordTableViewCell

- (void)awakeFromNib {
    self.dataDic = [[NSDictionary alloc] init];
}

- (void)setDataDic:(NSDictionary *)dataDic
{
    NSString *data = [dataDic objectForKey:@"addtime"];
    self.dataLabel.text = [data substringWithRange:NSMakeRange(5, 5)];
    self.timeLabel.text = [data substringWithRange:NSMakeRange(11, 5)];
    NSString *voteType = [dataDic objectForKey:@"playtype"];
    if([voteType isEqualToString:@"1"])
    {
        self.voteTypeLabel.text = @"让球胜平负";
    }
    else if([voteType isEqualToString:@"2"])
    {
        self.voteTypeLabel.text = @"比分";
    }
    else if([voteType isEqualToString:@"3"])
    {
        self.voteTypeLabel.text = @"总进球";
    }
    else if([voteType isEqualToString:@"4"])
    {
        self.voteTypeLabel.text = @"半全场";
    }
    else if([voteType isEqualToString:@"5"])
    {
        self.voteTypeLabel.text = @"胜平负";
    }
    else if([voteType isEqualToString:@"6"])
    {
        self.voteTypeLabel.text = @"混投";
    }
    
    self.moneyLabel.text = [NSString stringWithFormat:@"%@元",[dataDic objectForKey:@"project_prize"]];
    if([[dataDic objectForKey:@"bonus_after_fax"] isEqualToString:@"0.0"])
    {
        self.selectTypeLabel.text = [dataDic objectForKey:@"state"];
    }
    else
    {
        self.selectTypeLabel.text = [NSString stringWithFormat:@"已中奖%@元",[dataDic objectForKey:@"bonus_after_fax"]];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
