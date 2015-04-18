//
//  BankListTableViewCell.m
//  FootBallLottery
//
//  Created by jaye on 15/1/29.
//  Copyright (c) 2015年 jaye. All rights reserved.
//

#import "BankListTableViewCell.h"

@implementation BankListTableViewCell

- (void)awakeFromNib {
    
    self.dataDic = [[NSDictionary alloc] init];
}

- (void)setDataDic:(NSDictionary *)dataDic
{
    NSString *num = [dataDic objectForKey:@"bankAccount"];
    self.bankNum.text = [NSString stringWithFormat:@"尾号 %@",[num substringWithRange:NSMakeRange(6,4)]];
    if([[dataDic objectForKey:@"bankCardTypeUsed"] isEqualToString:@"0"])
    {
        self.bankType.text = @"储蓄卡";
        NSArray *array = [[AppDelegate getAppDelegate] bankList];
        for(int i = 0;i < array.count;i++)
        {
            NSDictionary *dic = [array objectAtIndex:i];
            NSString *bankCode = [dic objectForKey:@"bankCode"];
            if([[dataDic objectForKey:@"bankCodeUsed"] isEqualToString:bankCode])
            {
                self.bankName.text = [dic objectForKey:@"bankName"];
            }
        }
    }
    else if([[dataDic objectForKey:@"bankCardTypeUsed"] isEqualToString:@"1"])
    {
        self.bankType.text = @"信用卡";
        NSArray *array = [[AppDelegate getAppDelegate] bankList_c];
        for(int i = 0;i < array.count;i++)
        {
            NSDictionary *dic = [array objectAtIndex:i];
            NSString *bankCode = [dic objectForKey:@"bankCode"];
            if([[dataDic objectForKey:@"bankCodeUsed"] isEqualToString:bankCode])
            {
                self.bankName.text = [dic objectForKey:@"bankName"];
            }
        }
    }
}




- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
