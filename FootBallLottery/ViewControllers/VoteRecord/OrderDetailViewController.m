//
//  OrderDetailViewController.m
//  FootBallLottery
//
//  Created by jaye on 15/1/3.
//  Copyright (c) 2015年 jaye. All rights reserved.
//

#import "OrderDetailViewController.h"
#import "VoteDetailTableViewCell.h"

@interface OrderDetailViewController ()

@end

@implementation OrderDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.dataDic = [[NSDictionary alloc] init];
    [self requestVoteDetail];
}

- (IBAction)backActionClick:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)showData
{
    NSString *voteType = [self.dataDic objectForKey:@"playtype"];
    if([voteType isEqualToString:@"1"])
    {
        self.voteType.text = @"让球胜平负";
    }
    else if([voteType isEqualToString:@"2"])
    {
        self.voteType.text = @"比分";
    }
    else if([voteType isEqualToString:@"3"])
    {
        self.voteType.text = @"总进球";
    }
    else if([voteType isEqualToString:@"4"])
    {
        self.voteType.text = @"半全场";
    }
    else if([voteType isEqualToString:@"5"])
    {
        self.voteType.text = @"胜平负";
    }
    else if([voteType isEqualToString:@"6"])
    {
        self.voteType.text = @"混投";
    }
    
    self.voteNum.text = [NSString stringWithFormat:@"第%@期",[self.dataDic objectForKey:@"projectno"]];
    self.voteMoney.text = [NSString stringWithFormat:@"%@元",[self.dataDic objectForKey:@"projectprize"]];
    self.voteDetailType.text = [self.dataDic objectForKey:@"state"];
    self.winMoney.text = [NSString stringWithFormat:@"%@元",bonus];
    self.openTime.text = [self.dataDic objectForKey:@"projecttime"];
    NSString *guoguanStr = [self.dataDic objectForKey:@"guoguantype"];
    NSString *zhushuStr = [NSString stringWithFormat:@"%@注",[self.dataDic objectForKey:@"userballot"]];
    NSString *beishuStr = [NSString stringWithFormat:@"%@倍",[self.dataDic objectForKey:@"multiple"]];
    
    NSString *chuanguanStr = [NSString stringWithFormat:@"%@  %@  %@",guoguanStr,zhushuStr,beishuStr];
    UILabel *chuanguanLabel = [[UILabel alloc] initWithFrame:CGRectMake(83, 177, 227, 30)];
    chuanguanLabel.font = [UIFont systemFontOfSize:14.0f];
    chuanguanLabel.numberOfLines = 0;
    chuanguanLabel.lineBreakMode = NSLineBreakByWordWrapping;
    chuanguanLabel.textColor = [Utils colorWithHexString:@"#747AA3"];
    chuanguanLabel.text = chuanguanStr;
    CGSize size = CGSizeMake(227, MAXFLOAT);
    NSDictionary * tdic = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:14.0f], NSFontAttributeName,nil];
    size = [chuanguanStr boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:tdic context:nil].size;
    chuanguanLabel.frame = CGRectMake(83, 177, size.width, size.height);
    [self.view addSubview:chuanguanLabel];
    if(size.height > 30)
    {
        self.headView.frame = CGRectMake(0, 177 + size.height, CGRectGetWidth(self.headView.frame), CGRectGetHeight(self.headView.frame));
    }
    else
    {
        self.headView.frame = CGRectMake(0, 177 + 30, CGRectGetWidth(self.headView.frame), CGRectGetHeight(self.headView.frame));
    }
    [self.view addSubview:self.headView];
    
    if(!self.tableView)
    {
        self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, self.headView.frame.origin.y + CGRectGetHeight(self.headView.frame), kWindowWidth, kWindowHeight - (self.headView.frame.origin.y + CGRectGetHeight(self.headView.frame)))];
        self.tableView.backgroundColor = [UIColor clearColor];
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.tableView.bounces = NO;
        [self.view addSubview:self.tableView];
    }
    
    self.voteTime.text = [self.dataDic objectForKey:@"projecttime"];
    self.projectNum.text = [self.dataDic objectForKey:@"projectno"];
}

#pragma mark - tableView delegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identity = @"voteDetailTableView";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identity];
    if(!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identity];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [Utils colorWithHexString:@"#32353f"];
    UIFont *font = [UIFont systemFontOfSize:12.0f];
    UIColor *backColor = [Utils colorWithHexString:@"#2d2f37"];
    UIColor *textCol = [Utils colorWithHexString:@"#e6e9e7"];
    
    NSDictionary *dic = nil;
    cellSize.height = 0;
    float height = 0;
    if([[self.dataDic objectForKey:@"element"] isKindOfClass:[NSDictionary class]])
    {
        dic = [self.dataDic objectForKey:@"element"];
    }
    else
    {
        dic = [[self.dataDic objectForKey:@"element"] objectAtIndex:indexPath.row];
    }
    
    for(UIView *labelView in [cell.contentView subviews])
    {
        [labelView removeFromSuperview];
    }
    
    if([[dic objectForKey:@"odd"] isKindOfClass:[NSDictionary class]])             //一个odd
    {
        NSDictionary *cellDic = [dic objectForKey:@"odd"];
        
        //投注
        UILabel *vote = [[UILabel alloc] init];
        vote.font = font;
        vote.numberOfLines = 0;
        vote.lineBreakMode = NSLineBreakByCharWrapping;
        vote.textAlignment = NSTextAlignmentCenter;
        if([[cellDic allKeys] containsObject:@"betinfo"])
        {
            vote.text = [cellDic objectForKey:@"betinfo"];
        }
        else
        {
            vote.text = @"";
        }
        
        CGSize size = CGSizeMake(75, MAXFLOAT);
        NSDictionary * tdic = [NSDictionary dictionaryWithObjectsAndKeys:font, NSFontAttributeName,nil];
        size = [vote.text boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:tdic context:nil].size;
        if(size.height < 66)
        {
            size.height = 66;
        }
        else
        {
            size.height += 10;
        }
        vote.frame = CGRectMake(189, 0, 75, size.height - 1);
        vote.backgroundColor = backColor;
        vote.textColor = textCol;
        [cell.contentView addSubview:vote];
        
        height = size.height;
        
        //玩法
        UILabel *play = [[UILabel alloc] initWithFrame:CGRectMake(133, 0, 55, height - 1)];
        play.font = font;
        play.textAlignment = NSTextAlignmentCenter;
        if([[cellDic allKeys] containsObject:@"playname"])
        {
            play.text = [cellDic objectForKey:@"playname"];
        }
        else
        {
            play.text = @"";
        }
        play.backgroundColor = backColor;
        play.textColor = textCol;
        [cell.contentView addSubview:play];
        
        //赛果
        UILabel *result = [[UILabel alloc] initWithFrame:CGRectMake(265, 0, 54, height - 1)];
        result.font = font;
        result.numberOfLines = 0;
        result.lineBreakMode = NSLineBreakByCharWrapping;
        result.textAlignment = NSTextAlignmentCenter;
        if([[cellDic allKeys] containsObject:@"gameresult"])
        {
            result.text = [cellDic objectForKey:@"gameresult"];
        }
        else
        {
            result.text = @"";
        }
        result.backgroundColor = backColor;
        result.textColor = textCol;
        [cell.contentView addSubview:result];
        
        cellSize.height = size.height;
    }
    else if([[dic objectForKey:@"odd"] isKindOfClass:[NSArray class]])
        //多个odd
    {
        NSArray *dataArray = [NSArray arrayWithArray:[dic objectForKey:@"odd"]];
        
        for(int i = 0;i < dataArray.count;i++)
        {
            NSDictionary *cellDic = [dataArray objectAtIndex:i];
            
            //投注
            UILabel *vote = [[UILabel alloc] init];
            vote.font = font;
            vote.numberOfLines = 0;
            vote.lineBreakMode = NSLineBreakByCharWrapping;
            vote.textAlignment = NSTextAlignmentCenter;
            if([[cellDic allKeys] containsObject:@"betinfo"])
            {
                vote.text = [cellDic objectForKey:@"betinfo"];
            }
            else
            {
                vote.text = @"";
            }
            
            CGSize size = CGSizeMake(75, MAXFLOAT);
            NSDictionary * tdic = [NSDictionary dictionaryWithObjectsAndKeys:font, NSFontAttributeName,nil];
            size = [vote.text boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:tdic context:nil].size;
//            if(size.height < 30)
//            {
//                size.height = 30;
//            }
//            else
//            {
//                size.height += 10;
//            }
            size.height += 33;
            vote.frame = CGRectMake(189, height, 75, size.height - 1);
            vote.backgroundColor = backColor;
            vote.textColor = textCol;
            [cell.contentView addSubview:vote];
            
            //玩法
            UILabel *play = [[UILabel alloc] initWithFrame:CGRectMake(133, height, 55, size.height - 1)];
            play.font = font;
            play.textAlignment = NSTextAlignmentCenter;
            if([[cellDic allKeys] containsObject:@"playname"])
            {
                play.text = [cellDic objectForKey:@"playname"];
            }
            else
            {
                play.text = @"";
            }
            play.backgroundColor = backColor;
            play.textColor = textCol;
            [cell.contentView addSubview:play];
            
            //赛果
            UILabel *result = [[UILabel alloc] initWithFrame:CGRectMake(265, height, 54, size.height - 1)];
            result.font = font;
            result.numberOfLines = 0;
            result.lineBreakMode = NSLineBreakByCharWrapping;
            result.textAlignment = NSTextAlignmentCenter;
            if([[cellDic allKeys] containsObject:@"gameresult"])
            {
                result.text = [cellDic objectForKey:@"gameresult"];
            }
            else
            {
                result.text = @"";
            }
            result.backgroundColor = backColor;
            result.textColor = textCol;
            [cell.contentView addSubview:result];
            
            height += size.height;
            cellSize.height += size.height;
        }
    }
    
    //场次
    UIView *matchView = [[UIView alloc] initWithFrame:CGRectMake(1, 0, 40, cellSize.height - 1)];
    matchView.backgroundColor = backColor;
    [cell.contentView addSubview:matchView];
    
    UILabel *match = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 40, 20)];
    match.font = font;
    match.textAlignment = NSTextAlignmentCenter;
    match.text = [dic objectForKey:@"name"];
    match.backgroundColor = backColor;
    match.textColor = textCol;
    [matchView addSubview:match];
    
    UILabel *numLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, 40,20)];
    numLabel.font = font;
    numLabel.textAlignment = NSTextAlignmentCenter;
    numLabel.text = [dic objectForKey:@"number"];
    numLabel.backgroundColor = backColor;
    numLabel.textColor = textCol;
    [matchView addSubview:numLabel];
    
    //主队对客队
    UIView *teamView = [[UIView alloc] initWithFrame:CGRectMake(42, 0, 90, cellSize.height - 1)];
    teamView.backgroundColor = backColor;
    [cell.contentView addSubview:teamView];
    
    UILabel *matchTeam = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 90, 20)];
    matchTeam.font = font;
    matchTeam.textAlignment = NSTextAlignmentCenter;
    matchTeam.text = [dic objectForKey:@"matchteam"];
    matchTeam.backgroundColor = backColor;
    matchTeam.textColor = textCol;
    [teamView addSubview:matchTeam];
    
    UILabel *VS = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, 90,20)];
    VS.font = font;
    VS.textAlignment = NSTextAlignmentCenter;
    VS.text = @"VS";
    VS.backgroundColor = backColor;
    VS.textColor = textCol;
    [teamView addSubview:VS];
    
    UILabel *hostTeam = [[UILabel alloc] initWithFrame:CGRectMake(0, 40, 90,20)];
    hostTeam.font = font;
    hostTeam.textAlignment = NSTextAlignmentCenter;
    hostTeam.text = [dic objectForKey:@"hostteam"];
    hostTeam.backgroundColor = backColor;
    hostTeam.textColor = textCol;
    [teamView addSubview:hostTeam];
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if([[self.dataDic objectForKey:@"element"] isKindOfClass:[NSDictionary class]])
    {
        return 1;
    }
    return [[self.dataDic objectForKey:@"element"] count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
    return cellSize.height;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return self.footView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return CGRectGetHeight(self.footView.frame);
}

#pragma  mark - request server
- (void)requestVoteDetail
{
    NSMutableString *unmd5str = [[NSMutableString alloc] init];
    [unmd5str appendString:TestKey];
    
    NSString *xmlStr = [NSString stringWithFormat:
                        @"<body>"
                        "<elements>"
                        "<element>"
                        "<serialid>%@</serialid>"
                        "</element>"
                        "</elements>"
                        "</body>",self.serialid];
    [unmd5str appendString:xmlStr];
    
    NSMutableString *post = [[NSMutableString alloc] init];
    post = [NSMutableString stringWithFormat:
            @"SumaLottery=<?xml version =\"1.0\"encoding=\"UTF-8\"?>"
            "<message version=\"1.0\">"
            "<header>"
            "<transactiontype>12022_1.1</transactiontype>"
            "<timestamp>%@</timestamp>"
            "<digest>%@</digest>"
            "<agenterid>10000002</agenterid>"
            "<ipaddress></ipaddress>"
            "<source>WEB</source>"
            "</header>"
            "<body>"
            "<elements>"
            "<element>"
            "<serialid>%@</serialid>"
            "</element>"
            "</elements>"
            "</body>"
            "</message>",
            [Utils getcurrenttime],[Utils md5:unmd5str],self.serialid];
    
    NSLog(@"vote record detail request %@",post);
    [self showProgressHUD:@"加载中"];
    
    [self.connection requestConnection:SERVER_URL
                            postParams:post
                            completion:^(NSMutableDictionary *responseDict)
     {
         [self hideProgressHUD];
         NSLog(@"vote record detail responese %@",responseDict);
         NSDictionary *bodyDic = [responseDict objectForKey:@"body"];
         NSDictionary *elements = [bodyDic objectForKey:@"elements"];
         NSDictionary *oelement = [bodyDic objectForKey:@"oelement"];
         
         if([[oelement objectForKey:@"errorcode"] intValue] == 0)
         {
             bonus = [elements objectForKey:@"bonus"];
             self.dataDic = elements;
             [self showData];
         }
         else
         {
             [Utils showMessage:[oelement objectForKey:@"errormsg"]];
         }
     }
                                failed:^(NSString *failedMessage)
     {
         [self hideProgressHUD];
         NSLog(@"error %@",failedMessage);
         [Utils showMessage:failedMessage];
     }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
