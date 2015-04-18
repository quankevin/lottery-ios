//
//  VoteDetailTableViewCell.m
//  FootBallLottery
//
//  Created by jaye on 15/2/11.
//  Copyright (c) 2015年 jaye. All rights reserved.
//

#import "VoteDetailTableViewCell.h"

@implementation VoteDetailTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setDataDic:(NSDictionary *)dataDic
{
    self.timeLabel.text = [dataDic objectForKey:@"name"];
    self.numLabel.text = [dataDic objectForKey:@"number"];
    self.hostTeam.text = [dataDic objectForKey:@"matchteam"];
    self.visterTeam.text = [dataDic objectForKey:@"hostteam"];
//    self.voteType.text = [[[dataDic objectForKey:@"odd"] objectAtIndex:0] objectForKey:@"playname"];
//    self.voteLabel.text = [[[dataDic objectForKey:@"odd"] objectAtIndex:0] objectForKey:@"betinfo"];
//    self.result.text = [[[dataDic objectForKey:@"odd"] objectAtIndex:0] objectForKey:@"gameresult"];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
