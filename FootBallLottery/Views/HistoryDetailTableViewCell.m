//
//  HistoryDetailTableViewCell.m
//  FootBallLottery
//
//  Created by jaye on 15/1/18.
//  Copyright (c) 2015年 jaye. All rights reserved.
//

#import "HistoryDetailTableViewCell.h"
#import "Utils.h"

@implementation HistoryDetailTableViewCell

- (void)awakeFromNib {
    self.dataDic = [[NSDictionary alloc] init];
}

- (void)setDataDic:(NSDictionary *)dataDic
{
    NSLog(@"dataDic %@",dataDic);
    self.gameType.text = [dataDic objectForKey:@"league"];
    self.firstName.text = [dataDic objectForKey:@"matchTeam"];
    self.secondName.text = [dataDic objectForKey:@"hostTeam"];
    self.gameNum.text = [dataDic objectForKey:@"num"];
    NSString *gameTime = [[dataDic objectForKey:@"gameTime"] substringWithRange:NSMakeRange(11,5)];
    self.gameTime.text = gameTime;
    if([dataDic.allKeys containsObject:@"bfkjBc"])
    {
        self.halfNum.text = [NSString stringWithFormat:@" 半  %@",[dataDic objectForKey:@"bfkjBc"]];
    }
    
    if([dataDic.allKeys containsObject:@"bfkj"])
    {
        self.allNum.text = [NSString stringWithFormat:@" 全  %@",[dataDic objectForKey:@"bfkj"]];
    }
    
    
    if([[dataDic objectForKey:@"hit"] isEqualToString:@"0"])
    {
        [self.winAndFailBg setImage:[UIImage imageNamed:@"bifen-wrong_bg.png"]];
        self.halfNum.textColor = self.allNum.textColor = [Utils colorWithHexString:@"#1EAA7E"];
    }
    
    if([[dataDic objectForKey:@"hit"] isEqualToString:@"1"])
    {
        [self.winAndFailBg setImage:[UIImage imageNamed:@"bifen-right_bg.png"]];
        self.halfNum.textColor = self.allNum.textColor = [Utils colorWithHexString:@"#DEA20C"];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
