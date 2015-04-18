//
//  MixBuyView.m
//  FootBallLottery
//
//  Created by jaye on 15/1/2.
//  Copyright (c) 2015年 jaye. All rights reserved.
//

#import "MixBuyView.h"
#import "UIView+CTDialog.h"
#import "Utils.h"

@implementation MixBuyView

- (void)awakeFromNib
{
    self.rqArray = [[NSMutableArray alloc] init];
    self.bfArray = [[NSMutableArray alloc] init];
    self.jqArray = [[NSMutableArray alloc] init];
    self.bqArray = [[NSMutableArray alloc] init];
}

//胜负平
- (void)setSpArray:(NSMutableArray *)spArray
{
    for(int i = 0;i < spArray.count;i++)
    {
        for(int j = 0;j < 3;j++)
        {
            UIButton *btn = (UIButton *)[self viewWithTag:10 + j];
            if([[spArray objectAtIndex:i] isEqualToString:[NSString stringWithFormat:@"%ld",btn.tag - 10]])
            {
                [btn setBackgroundColor:[Utils colorWithHexString:@"#1B1D24"]];
                [btn setTitleColor:[Utils colorWithHexString:@"#DEA20C"] forState:UIControlStateNormal];
            }
        }
    }
    
    self.sfpArray = [[NSMutableArray alloc] initWithArray:spArray];
}

//让球
- (void)setRqArray:(NSMutableArray *)rqArray
{
    for(int i = 0;i < rqArray.count;i++)
    {
        NSDictionary *dic = [rqArray objectAtIndex:i];
        for(int j = 0;j < 3;j++)
        {
            UIButton *btn = (UIButton *)[self viewWithTag:20 + j];
            if([[dic objectForKey:@"selectIndex"] isEqualToString:[NSString stringWithFormat:@"%ld",btn.tag - 20]])
            {
                [btn setBackgroundColor:[Utils colorWithHexString:@"#1B1D24"]];
                [btn setTitleColor:[Utils colorWithHexString:@"#DEA20C"] forState:UIControlStateNormal];
            }
        }
    }
    
    self.selectRqArray = [[NSMutableArray alloc] initWithArray:rqArray];
}

//比分
- (void)setBfArray:(NSMutableArray *)bfArray
{
    for(int i = 0;i < bfArray.count;i++)
    {
        NSDictionary *dic = [bfArray objectAtIndex:i];
        for(int j = 0;j < 60;j++)
        {
            UIButton *btn = (UIButton *)[self viewWithTag:300 + j];
            if([[dic objectForKey:@"selectIndex"] isEqualToString:[NSString stringWithFormat:@"%ld",btn.tag - 300]])
            {
                [btn setBackgroundColor:[Utils colorWithHexString:@"#1B1D24"]];
                [btn setTitleColor:[Utils colorWithHexString:@"#DEA20C"] forState:UIControlStateNormal];
            }
        }
    }
    
    self.selectBfArray = [[NSMutableArray alloc] initWithArray:bfArray];
}

//进球
- (void)setJqArray:(NSMutableArray *)jqArray
{
    for(int i = 0;i < jqArray.count;i++)
    {
        NSDictionary *dic = [jqArray objectAtIndex:i];
        for(int j = 0;j < 30;j++)
        {
            UIButton *btn = (UIButton *)[self viewWithTag:400 + j];
            if([[dic objectForKey:@"selectIndex"] isEqualToString:[NSString stringWithFormat:@"%ld",btn.tag - 400]])
            {
                [btn setBackgroundColor:[Utils colorWithHexString:@"#1B1D24"]];
                [btn setTitleColor:[Utils colorWithHexString:@"#DEA20C"] forState:UIControlStateNormal];
            }
        }
    }
    
    self.selectJqArray = [[NSMutableArray alloc] initWithArray:jqArray];
}

//半全场
- (void)setBqArray:(NSMutableArray *)bqArray
{
    for(int i = 0;i < bqArray.count;i++)
    {
        NSDictionary *dic = [bqArray objectAtIndex:i];
        for(int j = 0;j < 30;j++)
        {
            UIButton *btn = (UIButton *)[self viewWithTag:500 + j];
            if([[dic objectForKey:@"selectIndex"] isEqualToString:[NSString stringWithFormat:@"%ld",btn.tag - 500]])
            {
                [btn setBackgroundColor:[Utils colorWithHexString:@"#1B1D24"]];
                [btn setTitleColor:[Utils colorWithHexString:@"#DEA20C"] forState:UIControlStateNormal];
            }
        }
    }
    
    self.selectBqArray = [[NSMutableArray alloc] initWithArray:bqArray];
}

//配置数据
- (void)setDataDic:(NSDictionary *)dataDic
{
    self.hostLabel.text = [NSString stringWithFormat:@"%@(客)",[dataDic objectForKey:@"hostTeam"]];
    self.visiteLabel.text = [NSString stringWithFormat:@"%@(主)",[dataDic objectForKey:@"matchTeam"]];
    
    //显示胜负平赔率
    NSString *spOdds = [dataDic objectForKey:@"spOdds"];
    NSArray *spArray = [spOdds componentsSeparatedByString:@"$"];
    NSString *spWin = [spArray objectAtIndex:0];
    NSArray *spWinArray = [spWin componentsSeparatedByString:@"@"];
    NSString *spWin0 = [spWinArray objectAtIndex:0];
    NSString *spWin1 = [spWinArray objectAtIndex:1];
    
    NSString *spTie = [spArray objectAtIndex:1];
    NSArray *spTieArray = [spTie componentsSeparatedByString:@"@"];
    NSString *spTie0 = [spTieArray objectAtIndex:0];
    NSString *spTie1 = [spTieArray objectAtIndex:1];
    
    NSString *spFail = [spArray objectAtIndex:2];
    NSArray *spFailArray = [spFail componentsSeparatedByString:@"@"];
    NSString *spFail0 = [spFailArray objectAtIndex:0];
    NSString *spFail1 = [spFailArray objectAtIndex:1];
    
    if(spOdds.length == 0)
    {
        spWin0 = spWin1 = spTie0 = spTie1 = spFail0 = spFail1 = @"";
    }
    
    //胜
    [self.winBtn setTitle:[NSString stringWithFormat:@"%@  %@",spWin0,spWin1] forState:UIControlStateNormal];
    //平
    [self.tieBtn setTitle:[NSString stringWithFormat:@"%@  %@",spTie0,spTie1] forState:UIControlStateNormal];
    //负
    [self.failBtn setTitle:[NSString stringWithFormat:@"%@  %@",spFail0,spFail1] forState:UIControlStateNormal];
    
    //显示让球赔率
    NSString *rqOdds = [dataDic objectForKey:@"rqOdds"];
    NSArray *rqArray = [rqOdds componentsSeparatedByString:@"$"];
    
    NSString *rqWin = [rqArray objectAtIndex:0];
    NSArray *rqWinArray = [rqWin componentsSeparatedByString:@"@"];
    NSString *rqWin0 = [rqWinArray objectAtIndex:0];
    NSString *rqWin1 = [rqWinArray objectAtIndex:1];
    
    NSString *rqTie = [rqArray objectAtIndex:1];
    NSArray *rqTieArray = [rqTie componentsSeparatedByString:@"@"];
    NSString *rqTie0 = [rqTieArray objectAtIndex:0];
    NSString *rqTie1 = [rqTieArray objectAtIndex:1];
    
    NSString *rqFail = [rqArray objectAtIndex:2];
    NSArray *rqFailArray = [rqFail componentsSeparatedByString:@"@"];
    NSString *rqFail0 = [rqFailArray objectAtIndex:0];
    NSString *rqFail1 = [rqFailArray objectAtIndex:1];
    
    if(rqOdds.length == 0)
    {
        rqWin0 = rqWin1 = rqTie0 = rqTie1 = rqFail0 = rqFail1 = @"";
    }

    //胜
    [self.rqWinBtn setTitle:[NSString stringWithFormat:@"%@  %@",rqWin0,rqWin1] forState:UIControlStateNormal];
    //平
    [self.rqTieBtn setTitle:[NSString stringWithFormat:@"%@  %@",rqTie0,rqTie1] forState:UIControlStateNormal];
    //负
    [self.rqFailBtn setTitle:[NSString stringWithFormat:@"%@  %@",rqFail0,rqFail1] forState:UIControlStateNormal];
    
    //比分
    NSString *bfOdds = [dataDic objectForKey:@"bfOdds"];
    CGRect frame;
    if(rqOdds.length != 0)
    {
        NSArray *bfArray = [bfOdds componentsSeparatedByString:@"$"];
       
        for (int i = 0; i < bfArray.count; i++)
        {
            NSString *str = [bfArray objectAtIndex:i];
            NSArray *strArray = [str componentsSeparatedByString:@"@"];
            NSString *str0 = [strArray objectAtIndex:0];
            NSString *str1 = [strArray objectAtIndex:1];
            
            int hang = i / 5;
            int lie = i % 5;
            UIView *btnBg = [[UIView alloc] initWithFrame:CGRectMake(60+47*lie, 110+40*hang, 47, 40)];
            [btnBg setBackgroundColor:[Utils colorWithHexString:@"#34394A"]];
            [self.scrollView addSubview:btnBg];
            
            UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(1,1,45,38)];
            [btn setBackgroundColor:[Utils colorWithHexString:@"#2B303C"]];
            [btn setTitle:[NSString stringWithFormat:@"%@\n%@",str0,str1] forState:UIControlStateNormal];
            btn.titleLabel.font = [UIFont systemFontOfSize:12.0f];
            btn.titleLabel.numberOfLines = 2;
            btn.titleLabel.textAlignment = NSTextAlignmentCenter;
            [btn setTitleColor:[Utils colorWithHexString:@"#D7DEFF"] forState:UIControlStateNormal];
            btn.tag = 300 + i;
            [btn addTarget:self action:@selector(bfSelectAction:) forControlEvents:UIControlEventTouchUpInside];
            [btnBg addSubview:btn];
            
            if(i == bfArray.count - 1)
                frame = btnBg.frame;
        }
    }
    
    //总进球
    NSString *jqOdds = [dataDic objectForKey:@"jqOdds"];
    if(jqOdds.length != 0)
    {
        self.jqLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, frame.origin.y + frame.size.height + 10, 45, 20)];
        self.jqLabel.text = @"总进球";
        self.jqLabel.textColor = [Utils colorWithHexString:@"#707497"];
        self.jqLabel.font = [UIFont systemFontOfSize:15.0f];
        [self.scrollView addSubview:self.jqLabel];
        
        NSArray *jqOddsArray = [jqOdds componentsSeparatedByString:@"$"];
        for (int i = 0; i < jqOddsArray.count; i++)
        {
            NSString *str = [jqOddsArray objectAtIndex:i];
            NSArray *strArray = [str componentsSeparatedByString:@"@"];
            NSString *str0 = [NSString stringWithFormat:@"%@球",[strArray objectAtIndex:0]];
            NSString *str1 = [strArray objectAtIndex:1];
            
            int hang = i / 5;
            int lie = i % 5;
            UIView *btnBg = [[UIView alloc] initWithFrame:CGRectMake(60+47*lie, self.jqLabel.frame.origin.y+40*hang, 47, 40)];
            [btnBg setBackgroundColor:[Utils colorWithHexString:@"#34394A"]];
            [self.scrollView addSubview:btnBg];
            
            UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(1,1,45,38)];
            [btn setBackgroundColor:[Utils colorWithHexString:@"#2B303C"]];
            [btn setTitle:[NSString stringWithFormat:@"%@\n%@",str0,str1] forState:UIControlStateNormal];
            btn.titleLabel.font = [UIFont systemFontOfSize:12.0f];
            btn.titleLabel.numberOfLines = 2;
            btn.titleLabel.textAlignment = NSTextAlignmentCenter;
            [btn setTitleColor:[Utils colorWithHexString:@"#D7DEFF"] forState:UIControlStateNormal];
            btn.tag = 400 + i;
            [btn addTarget:self action:@selector(jqSelectAction:) forControlEvents:UIControlEventTouchUpInside];
            [btnBg addSubview:btn];
            
            if(i == jqOddsArray.count - 1)
                frame = btnBg.frame;
        }
    }
    
    //半全场
    NSString *bqOdds = [dataDic objectForKey:@"bqOdds"];
    if(bqOdds.length != 0)
    {
        self.bqLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, frame.origin.y + frame.size.height + 10, 45, 20)];
        self.bqLabel.text = @"半全场";
        self.bqLabel.textColor = [Utils colorWithHexString:@"#707497"];
        self.bqLabel.font = [UIFont systemFontOfSize:15.0f];
        [self.scrollView addSubview:self.bqLabel];
        
        NSArray *bqOddsArray = [bqOdds componentsSeparatedByString:@"$"];
        for (int i = 0; i < bqOddsArray.count; i++)
        {
            NSString *str = [bqOddsArray objectAtIndex:i];
            NSArray *strArray = [str componentsSeparatedByString:@"@"];
            NSString *str0 = [strArray objectAtIndex:0];
            NSString *str1 = [strArray objectAtIndex:1];
            
            int hang = i / 5;
            int lie = i % 5;
            UIView *btnBg = [[UIView alloc] initWithFrame:CGRectMake(60+47*lie, self.bqLabel.frame.origin.y+40*hang, 47, 40)];
            [btnBg setBackgroundColor:[Utils colorWithHexString:@"#34394A"]];
            [self.scrollView addSubview:btnBg];
            
            UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(1,1,45,38)];
            [btn setBackgroundColor:[Utils colorWithHexString:@"#2B303C"]];
            [btn setTitle:[NSString stringWithFormat:@"%@\n%@",str0,str1] forState:UIControlStateNormal];
            btn.titleLabel.font = [UIFont systemFontOfSize:12.0f];
            btn.titleLabel.numberOfLines = 2;
            btn.titleLabel.textAlignment = NSTextAlignmentCenter;
            [btn setTitleColor:[Utils colorWithHexString:@"#D7DEFF"] forState:UIControlStateNormal];
            btn.tag = 500 + i;
            [btn addTarget:self action:@selector(bqSelectAction:) forControlEvents:UIControlEventTouchUpInside];
            [btnBg addSubview:btn];
            
            if(i == bqOddsArray.count - 1)
                frame = btnBg.frame;
        }
    }
    
    self.scrollView.contentSize = CGSizeMake(300, frame.origin.y + frame.size.height + 30);
}

//选择胜平负
- (IBAction)winTieFailActionClcik:(UIButton *)sender
{
    if([sender.backgroundColor isEqual:[Utils colorWithHexString:@"#1B1D24"]])
    {
        [sender setBackgroundColor:[Utils colorWithHexString:@"#2B303C"]];
        [sender setTitleColor:[Utils colorWithHexString:@"#D7DEFF"] forState:UIControlStateNormal];
        
        [self.sfpArray removeObject:[NSString stringWithFormat:@"%ld",sender.tag - 10]];
    }
    else
    {
        [sender setBackgroundColor:[Utils colorWithHexString:@"#1B1D24"]];
        [sender setTitleColor:[Utils colorWithHexString:@"#DEA20C"] forState:UIControlStateNormal];
        
        [self.sfpArray addObject:[NSString stringWithFormat:@"%ld",sender.tag - 10]];
    }
}

//选择让球
- (IBAction)abandonActionClick:(UIButton *)sender
{
    NSString *content = nil;
    if(sender.tag - 20 == 0)
    {
        content = @"3";
    }
    else if(sender.tag - 20 == 1)
    {
        content = @"1";
    }
    else if(sender.tag - 20 == 2)
    {
        content = @"0";
    }
    
    NSDictionary *dic = @{@"selectIndex":[NSString stringWithFormat:@"%ld",sender.tag - 20],@"selectContent":content};
    
    if([sender.backgroundColor isEqual:[Utils colorWithHexString:@"#1B1D24"]])
    {
        [sender setBackgroundColor:[Utils colorWithHexString:@"#2B303C"]];
        [sender setTitleColor:[Utils colorWithHexString:@"#D7DEFF"] forState:UIControlStateNormal];
        
        [self.selectRqArray removeObject:dic];
    }
    else
    {
        [sender setBackgroundColor:[Utils colorWithHexString:@"#1B1D24"]];
        [sender setTitleColor:[Utils colorWithHexString:@"#DEA20C"] forState:UIControlStateNormal];
        
        [self.selectRqArray addObject:dic];
    }
}

//选择比分
- (void)bfSelectAction:(UIButton *)sender
{
    NSArray *array = [sender.titleLabel.text componentsSeparatedByString:@"\n"];
    NSString *selectContent = nil;
    NSString *str = [[array objectAtIndex:0] substringToIndex:2];
    if([str isEqualToString:@"负其"])
    {
        selectContent = @"0:9";
    }
    else if([str isEqualToString:@"胜其"])
    {
        selectContent = @"9:0";
    }
    else if ([str isEqualToString:@"平其"])
    {
        selectContent = @"9:9";
    }
    else
    {
        selectContent = [array objectAtIndex:0];
    }
    
    NSDictionary *dic = @{@"selectIndex":[NSString stringWithFormat:@"%ld",sender.tag - 300],@"selectContent":selectContent};
    if([sender.backgroundColor isEqual:[Utils colorWithHexString:@"#1B1D24"]])
    {
        [sender setBackgroundColor:[Utils colorWithHexString:@"#2B303C"]];
        [sender setTitleColor:[Utils colorWithHexString:@"#D7DEFF"] forState:UIControlStateNormal];
        
        [self.selectBfArray removeObject:dic];
    }
    else
    {
        [sender setBackgroundColor:[Utils colorWithHexString:@"#1B1D24"]];
        [sender setTitleColor:[Utils colorWithHexString:@"#DEA20C"] forState:UIControlStateNormal];
        
        [self.selectBfArray addObject:dic];
    }
}

//选择总进球
- (void)jqSelectAction:(UIButton *)sender
{
    NSArray *array = [sender.titleLabel.text componentsSeparatedByString:@"\n"];
    NSString *selectContent = nil;
    NSString *str = [array objectAtIndex:0];
    if([[str substringToIndex:str.length - 1] isEqualToString:@"7+"])
    {
        selectContent = @"7";
    }
    else
    {
        selectContent = [str substringToIndex:str.length - 1];
    }
    
    NSDictionary *dic = @{@"selectIndex":[NSString stringWithFormat:@"%ld",sender.tag - 400],@"selectContent":selectContent};
    if([sender.backgroundColor isEqual:[Utils colorWithHexString:@"#1B1D24"]])
    {
        [sender setBackgroundColor:[Utils colorWithHexString:@"#2B303C"]];
        [sender setTitleColor:[Utils colorWithHexString:@"#D7DEFF"] forState:UIControlStateNormal];
        
        [self.selectJqArray removeObject:dic];
    }
    else
    {
        [sender setBackgroundColor:[Utils colorWithHexString:@"#1B1D24"]];
        [sender setTitleColor:[Utils colorWithHexString:@"#DEA20C"] forState:UIControlStateNormal];
        
        [self.selectJqArray addObject:dic];
    }
}

//选择半全场
- (void)bqSelectAction:(UIButton *)sender
{
    NSArray *array = [sender.titleLabel.text componentsSeparatedByString:@"\n"];
    NSString *selectContent = nil;
    if([[array objectAtIndex:0] isEqualToString:@"胜胜"])
    {
        selectContent = @"3:3";
    }
    else if ([[array objectAtIndex:0] isEqualToString:@"胜平"])
    {
        selectContent = @"3:1";
    }
    else if ([[array objectAtIndex:0] isEqualToString:@"胜负"])
    {
        selectContent = @"3:0";
    }
    else if([[array objectAtIndex:0] isEqualToString:@"平胜"])
    {
        selectContent = @"1:3";
    }
    else if ([[array objectAtIndex:0] isEqualToString:@"平平"])
    {
        selectContent = @"1:1";
    }
    else if ([[array objectAtIndex:0] isEqualToString:@"平负"])
    {
        selectContent = @"1:0";
    }
    else if([[array objectAtIndex:0] isEqualToString:@"负胜"])
    {
        selectContent = @"0:3";
    }
    else if ([[array objectAtIndex:0] isEqualToString:@"负平"])
    {
        selectContent = @"0:1";
    }
    else if ([[array objectAtIndex:0] isEqualToString:@"负负"])
    {
        selectContent = @"0:0";
    }
    
    NSDictionary *dic = @{@"selectIndex":[NSString stringWithFormat:@"%ld",sender.tag - 500],@"selectContent":[selectContent stringByReplacingOccurrencesOfString:@":" withString:@"-"]};
    if([sender.backgroundColor isEqual:[Utils colorWithHexString:@"#1B1D24"]])
    {
        [sender setBackgroundColor:[Utils colorWithHexString:@"#2B303C"]];
        [sender setTitleColor:[Utils colorWithHexString:@"#D7DEFF"] forState:UIControlStateNormal];
        
        [self.selectBqArray removeObject:dic];
    }
    else
    {
        [sender setBackgroundColor:[Utils colorWithHexString:@"#1B1D24"]];
        [sender setTitleColor:[Utils colorWithHexString:@"#DEA20C"] forState:UIControlStateNormal];
        
        [self.selectBqArray addObject:dic];
    }
}

//取消
- (IBAction)cancelActionClick:(id)sender
{
    [self.dialogView close];
}

//确定
- (IBAction)doneActionClick:(id)sender
{
    //胜负平
    NSMutableArray *selectSpArray = [[NSMutableArray alloc] init];
    for(int i = 0;i < self.sfpArray.count;i++)
    {
        NSDictionary *selectDic = @{@"seletRow":[NSString stringWithFormat:@"%ld",(long)self.indexRow],@"selectIndex":[self.sfpArray objectAtIndex:i]};
        [selectSpArray addObject:selectDic];
    }
    
    //让球
    NSDictionary *selectRqDic = @{@"seletRow":[NSString stringWithFormat:@"%ld",(long)self.indexRow],@"selectIndex":self.selectRqArray};
    
    //比分
    NSDictionary *selectBfDic = @{@"seletRow":[NSString stringWithFormat:@"%ld",(long)self.indexRow],@"selectIndex":self.selectBfArray};
    
    //进球
    NSDictionary *selectJqDic = @{@"seletRow":[NSString stringWithFormat:@"%ld",(long)self.indexRow],@"selectIndex":self.selectJqArray};
    
    //半全场
    NSDictionary *selectBqDic = @{@"seletRow":[NSString stringWithFormat:@"%ld",(long)self.indexRow],@"selectIndex":self.selectBqArray};
    
    [self.delegate MixDoneAction:selectSpArray rqDic:selectRqDic bfDic:selectBfDic jqDic:selectJqDic bqDic:selectBqDic indexRow:self.indexRow];
    
    [self.dialogView close];
}

@end
