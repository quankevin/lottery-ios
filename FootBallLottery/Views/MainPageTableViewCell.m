//
//  MainPageTableViewCell.m
//  FootBallLottery
//
//  Created by jaye on 15/1/2.
//  Copyright (c) 2015年 jaye. All rights reserved.
//

#import "MainPageTableViewCell.h"

@implementation MainPageTableViewCell

//选择投注
- (IBAction)btnActionClick:(UIButton *)sender
{
    if([sender.backgroundColor isEqual:[Utils colorWithHexString:@"#1B1D24"]])
    {
        [sender setBackgroundColor:[Utils colorWithHexString:@"#2B303C"]];
        [sender setTitleColor:[Utils colorWithHexString:@"#D7DEFF"] forState:UIControlStateNormal];
        isSelect = NO;
    }
    else
    {
        [sender setBackgroundColor:[Utils colorWithHexString:@"#1B1D24"]];
        [sender setTitleColor:[Utils colorWithHexString:@"#DEA20C"] forState:UIControlStateNormal];
        isSelect = YES;
    }
    
    UIView *view = sender.superview;
    while (1)
    {
        if([view isKindOfClass:[MainPageTableViewCell class]])
        {
            [self.delegate selectWinTieFail:view index:sender.tag - 10 isSelect:isSelect];
            break;
        }
        else
        {
            view = view.superview;
        }
    }
}

//配置数据
- (void)setDataDic:(NSMutableDictionary *)dataDic
{
    self.gameType.numberOfLines = 0;
    self.gameType.lineBreakMode = NSLineBreakByCharWrapping;
    
    //比赛时间
    NSString *gameTime = [[dataDic objectForKey:@"gameTime"] substringWithRange:NSMakeRange(11,5)];
    self.gameTime.text = gameTime;
    //主队
    self.HostTeam.text = [dataDic objectForKey:@"hostTeam"];
    //比赛类型
    self.gameType.text = [dataDic objectForKey:@"league"];
    
    //客队
    self.visitingTeam.text = [dataDic objectForKey:@"matchTeam"];
    //显示赔率
    if([dataDic.allKeys containsObject:@"spOdds"])
    {
        NSString *spOdds = [dataDic objectForKey:@"spOdds"];
        
        //分隔字符串
        NSArray *array = [spOdds componentsSeparatedByString:@"$"];
        
        NSString *win = [array objectAtIndex:0];
        NSArray *winArray = [win componentsSeparatedByString:@"@"];
        NSString *win0 = [winArray objectAtIndex:0];
        NSString *win1 = [winArray objectAtIndex:1];
        
        NSString *tie = [array objectAtIndex:1];
        NSArray *tieArray = [tie componentsSeparatedByString:@"@"];
        NSString *tie0 = [tieArray objectAtIndex:0];
        NSString *tie1 = [tieArray objectAtIndex:1];
        
        NSString *fail = [array objectAtIndex:2];
        NSArray *failArray = [fail componentsSeparatedByString:@"@"];
        NSString *fail0 = [failArray objectAtIndex:0];
        NSString *fail1 = [failArray objectAtIndex:1];
        
        //胜
        [self.winBtn setTitle:[NSString stringWithFormat:@"%@  %@",win0,win1] forState:UIControlStateNormal];
        //平
        [self.tieBtn setTitle:[NSString stringWithFormat:@"%@  %@",tie0,tie1] forState:UIControlStateNormal];
        //负
        [self.failBtn setTitle:[NSString stringWithFormat:@"%@  %@",fail0,fail1] forState:UIControlStateNormal];
    }
    else
    {
        self.mixBtn.hidden = YES;
        self.disagreeBtn.hidden = YES;
        self.winBtn.userInteractionEnabled = NO;
        self.tieBtn.userInteractionEnabled = NO;
        self.failBtn.userInteractionEnabled = NO;
    }
    
    if([dataDic.allKeys containsObject:@"rqContent"] || [dataDic.allKeys containsObject:@"spContent"] || [dataDic.allKeys containsObject:@"bfContent"] || [dataDic.allKeys containsObject:@"bqContent"] || [dataDic.allKeys containsObject:@"jqContent"])
    {
        self.disagreeBtn.hidden = NO;
    }
    else
    {
        self.disagreeBtn.hidden = YES;
    }
    
    if(![dataDic.allKeys containsObject:@"content"])
    {
        self.analyseBtn.hidden = YES;
    }
    else
    {
        self.analyseBtn.hidden = NO;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
