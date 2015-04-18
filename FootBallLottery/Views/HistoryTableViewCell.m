//
//  HistoryTableViewCell.m
//  FootBallLottery
//
//  Created by jaye on 15/1/11.
//  Copyright (c) 2015年 jaye. All rights reserved.
//

#import "HistoryTableViewCell.h"

@implementation HistoryTableViewCell

- (void)awakeFromNib {
    self.dataDic = [[NSDictionary alloc] init];
}

- (void)setDataDic:(NSDictionary *)dataDic
{
    self.dateLabel.text = [dataDic objectForKey:@"date"];
    if([[dataDic objectForKey:@"hitcount"] isEqualToString:[dataDic objectForKey:@"count"]])
    {
        self.resuleLabel.textColor = [Utils colorWithHexString:@"#1EAA7E"];
    }
    self.resuleLabel.text = [NSString stringWithFormat:@"%@/%@",[dataDic objectForKey:@"hitcount"],[dataDic objectForKey:@"count"]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
