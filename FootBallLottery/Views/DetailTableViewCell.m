//
//  DetailTableViewCell.m
//  FootBallLottery
//
//  Created by jaye on 15/1/8.
//  Copyright (c) 2015年 jaye. All rights reserved.
//

#import "DetailTableViewCell.h"
#import "Utils.h"

@implementation DetailTableViewCell

- (void)setDataDic:(NSDictionary *)dataDic
{
    NSString *data = [dataDic objectForKey:@"entertime"];
    self.dataLabel.text = [data substringWithRange:NSMakeRange(5,5)];
    self.timeLabel.text = [data substringWithRange:NSMakeRange(11,5)];
    self.accountTypeLabel.text = [dataDic objectForKey:@"remark"];
    NSString *money = [dataDic objectForKey:@"money"];
    if([[money substringToIndex:1] isEqual:@"+"])
    {
        self.moneyLabel.textColor = [Utils colorWithHexString:@"#138C65"];
    }
    
    self.moneyLabel.text = [NSString stringWithFormat:@"%@元",[dataDic objectForKey:@"money"]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
