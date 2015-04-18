//
//  MyDetailListViewController.m
//  FootBallLottery
//
//  Created by jaye on 15/1/8.
//  Copyright (c) 2015年 jaye. All rights reserved.
//

#import "MyDetailListViewController.h"

@interface MyDetailListViewController ()

@end

@implementation MyDetailListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupMenuBarButtonItems];
    
    self.selectView.frame = CGRectMake(0, 70, CGRectGetWidth(self.selectView.frame), CGRectGetHeight(self.selectView.frame));
    self.selectView.hidden = NO;
    [self.view addSubview:self.selectView];
    
    self.weekSelectView.frame = CGRectMake(0, 70, CGRectGetWidth(self.weekSelectView.frame), CGRectGetHeight(self.weekSelectView.frame));
    self.weekSelectView.hidden = YES;
    [self.view addSubview:self.weekSelectView];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 110, kWindowWidth, kWindowHeight - 110)];
    self.tableView.tag = 10;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    //给tableView添加下拉刷新,上拉加载功能
    [self.tableView addHeaderWithTarget:self action:@selector(pullDownLoading) dateKey:@"table"];
    [self.tableView addFooterWithTarget:self action:@selector(pullUpLoading)];
    [self.view addSubview:self.tableView];
    
    self.dataArray = [[NSMutableArray alloc] init];
    self.mflag = @"";
    startDate = @"";
    endDate = @"";
    pageCount = 0;
    pageIndex = 1;
    [self requestNetWork];
}

#pragma mark - navigationController
- (void)setupMenuBarButtonItems
{
    self.navigationItem.leftBarButtonItem = [self backBarButtonItem];
    self.navigationItem.titleView = [self tittleLabel];
    self.navigationItem.rightBarButtonItem = [self rightBarButtonItem];
}

//标题
- (UILabel *)tittleLabel
{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 50)];
    label.textColor = [Utils colorWithHexString:@"#E6E9E7"];
    label.font = [UIFont systemFontOfSize:20.0f];
    label.text = @"账户明细";
    label.textAlignment = NSTextAlignmentCenter;
    return label;
}

//返回
- (UIBarButtonItem *)backBarButtonItem
{
    UIButton *leftBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 20, 40)];
    [leftBtn setImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(backButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    return [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
}

//近一周
- (UIBarButtonItem *)rightBarButtonItem
{
    UIButton *rightBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
    rightBtn.titleLabel.font = [UIFont systemFontOfSize:13.0f];
    rightBtn.titleLabel.textAlignment = NSTextAlignmentRight;
    [rightBtn setTitleColor:[Utils colorWithHexString:@"#E6E9E7"] forState:UIControlStateNormal];
    [rightBtn setTitleColor:[Utils colorWithHexString:@"#ADAEB4"] forState:UIControlStateHighlighted];
    [rightBtn setTitle:@"近一周" forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(rightButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    return [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
}


- (void)backButtonPressed:(id)sender
{
    [[AppDelegate getAppDelegate] setIsSlider:YES];
    [self.navigationController popToRootViewControllerAnimated:YES];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"back" object:nil];
}

- (void)clearData
{
    self.outMoney.text = self.inMoney.text = @"0元";
    [self.dataArray removeAllObjects];
}

- (void)rightButtonClick:(id)sender
{
    [self clearData];
    if(!isWeek)
    {
        isWeek = YES;
        self.selectView.hidden = YES;
        self.weekSelectView.hidden = NO;
        [self.weekSelectBg setImage:[UIImage imageNamed:@"shijian_jinyizhou.png"]];
        self.tableView.tag = 10;
        self.mflag = @"";
        NSDate *yesterday=[NSDate dateWithTimeIntervalSinceNow:-(7*24*60*60)];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd"];
        startDate = [formatter stringFromDate:yesterday];
        endDate = [Utils timeStamp];
        pageCount = 0;
        pageIndex = 1;
    }
    else
    {
        isWeek = NO;
        self.selectView.hidden = NO;
        self.weekSelectView.hidden = YES;
        [self.selectGroundImage setImage:[UIImage imageNamed:@"tab_zhanghu.png"]];
        self.tableView.tag = 20;
        self.mflag = @"";
        startDate = @"";
        endDate = @"";
        pageCount = 0;
        pageIndex = 1;
    }
    [self.tableView reloadData];
    [self requestNetWork];
}

//账户，充值，提现切换
- (IBAction)buttonActionClick:(UIButton *)sender
{
    [self clearData];
    pageCount = 0;
    pageIndex = 1;
    if(!isWeek)
    {
        if(sender.tag == 10)
        {
            [self.selectGroundImage setImage:[UIImage imageNamed:@"tab_zhanghu.png"]];
            self.mflag = @"";
        }
        else if (sender.tag == 11)
        {
            [self.selectGroundImage setImage:[UIImage imageNamed:@"tab_chongzhi.png"]];
            self.mflag = @"0,76,77,93";
        }
        else if (sender.tag == 12)
        {
            [self.selectGroundImage setImage:[UIImage imageNamed:@"tab_tixian.png"]];
            self.mflag = @"6";
        }
    }
    else
    {
        if(sender.tag == 20)
        {
            [self.weekSelectBg setImage:[UIImage imageNamed:@"shijian_jinyizhou.png"]];
            NSDate *yesterday=[NSDate dateWithTimeIntervalSinceNow:-(7*24*60*60)];
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:@"yyyy-MM-dd"];
            startDate = [formatter stringFromDate:yesterday];
        }
        else if (sender.tag == 21)
        {
            [self.weekSelectBg setImage:[UIImage imageNamed:@"shijian_jinyigeyue.png"]];
            startDate = [Utils getPriousDateFromDate:[NSDate date] withMonth:-1];
        }
        else if (sender.tag == 22)
        {
            [self.weekSelectBg setImage:[UIImage imageNamed:@"shijian_jinsangeyue.png"]];
            startDate = [Utils getPriousDateFromDate:[NSDate date] withMonth:-3];
        }
        else if (sender.tag == 23)
        {
            [self.weekSelectBg setImage:[UIImage imageNamed:@"shijian_jinliugeyue.png"]];
            startDate = [Utils getPriousDateFromDate:[NSDate date] withMonth:-6];
        }
    }
    self.tableView.tag = sender.tag;
    [self.tableView reloadData];
    [self requestNetWork];
}

//收入和支出展示
- (IBAction)getAndOutActionClick:(id)sender
{
//    GetAndOutViewController *getAndOut = [[GetAndOutViewController alloc] initWithNibName:@"GetAndOutViewController" bundle:nil];
//    [self presentViewController:getAndOut animated:YES completion:^{
//        
//    }];
}

//下拉刷新
- (void)pullDownLoading
{
    pageCount = 0;
    pageIndex = 1;
    [self requestNetWork];
}

//上拉加载
- (void)pullUpLoading
{
    if(self.dataArray.count == 0)
    {
        pageIndex = 1;
    }
    else
    {
        pageIndex += 1;
        if(pageCount % 10 == 0)
        {
            if(pageIndex > pageCount/10)
            {
                [Utils showMessage:@"已显示全部内容"];
                [self.tableView footerEndRefreshing];
                return;
            }
        }
        else
        {
            if(pageIndex > pageCount/10+1)
            {
                [Utils showMessage:@"已显示全部内容"];
                [self.tableView footerEndRefreshing];
                return;
            }
        }
    }
    
    [self requestNetWork];
}

//恢复TableView
- (void)resumeTableView
{
    if(self.tableView.headerRefreshing)
    {
        [self.tableView headerEndRefreshing];
    }
    else if (self.tableView.footerRefreshing)
    {
        [self.tableView footerEndRefreshing];
    }
    
    [self.tableView reloadData];
}

#pragma mark - tableView delegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identity = @"voteRecordTableView";
    DetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identity];
    if(!cell)
    {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"DetailTableViewCell" owner:nil options:nil]lastObject];
    }
    
    if(indexPath.row > 0)
    {
        NSDictionary *dic = [self.dataArray objectAtIndex:indexPath.row - 1];
        NSString *data = [[dic objectForKey:@"entertime"] substringWithRange:NSMakeRange(5, 5)];
        NSDictionary *nextDic = [self.dataArray objectAtIndex:indexPath.row];
        NSString *nextData = [[nextDic objectForKey:@"entertime"] substringWithRange:NSMakeRange(5, 5)];
        if([data isEqualToString:nextData])
        {
            cell.dataLabel.hidden = YES;
        }
    }
    
    cell.dataDic = [self.dataArray objectAtIndex:indexPath.row];
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return self.headView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(tableView.tag == 11 || tableView.tag == 12)
        return 0;
    return CGRectGetHeight(self.headView.frame);
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

#pragma mark - request server
- (void)requestNetWork
{
    NSMutableString *unmd5str = [[NSMutableString alloc] init];
    [unmd5str appendString:TestKey];
    
    NSString *xmlStr = [NSString stringWithFormat:
                        @"<body>"
                        "<elements>"
                        "<element>"
                        "<startDate>%@</startDate>"
                        "<endDate>%@</endDate>"
                        "<uid>%@</uid>"
                        "<mflag>%@</mflag>"
                        "<pageNum>%d</pageNum>"
                        "<pageSize>10</pageSize>"
                        "</element>"
                        "</elements>"
                        "</body>",startDate,endDate,[[AppDelegate getAppDelegate] uid],self.mflag,pageIndex];
    [unmd5str appendString:xmlStr];
    
    NSMutableString *post = [[NSMutableString alloc] init];
    post = [NSMutableString stringWithFormat:
            @"SumaLottery=<?xml version =\"1.0\"encoding=\"UTF-8\"?>"
            "<message version=\"1.0\">"
            "<header>"
            "<transactiontype>11008_1.1</transactiontype>"
            "<timestamp>%@</timestamp>"
            "<digest>%@</digest>"
            "<agenterid>10000002</agenterid>"
            "<ipaddress></ipaddress>"
            "<source>WEB</source>"
            "</header>"
            "<body>"
            "<elements>"
            "<element>"
            "<startDate>%@</startDate>"
            "<endDate>%@</endDate>"
            "<uid>%@</uid>"
            "<mflag>%@</mflag>"
            "<pageNum>%d</pageNum>"
            "<pageSize>10</pageSize>"
            "</element>"
            "</elements>"
            "</body>"
            "</message>",
            [Utils getcurrenttime],[Utils md5:unmd5str],startDate,endDate,[[AppDelegate getAppDelegate] uid],self.mflag,pageIndex];
    
    NSLog(@"account list request %@",post);
    [self showProgressHUD:@"加载中"];
    [self.connection requestConnection:SERVER_URL
                            postParams:post
                            completion:^(NSMutableDictionary *responseDict)
     {
         [self hideProgressHUD];
         NSLog(@"account list responseDict %@",responseDict);
         NSDictionary *bodyDic = [responseDict objectForKey:@"body"];
         NSDictionary *oelement = [bodyDic objectForKey:@"oelement"];
         NSDictionary *elements = [bodyDic objectForKey:@"elements"];
         if([[oelement objectForKey:@"errorcode"] isEqualToString:@"0"])
         {
             if([[[bodyDic objectForKey:@"elements"] objectForKey:@"count"] isEqual: @"0"])
             {
                 [Utils showMessage:@"暂无记录"];
             }
             else
             {
                 pageCount = [[elements objectForKey:@"count"] intValue];
                 self.outMoney.text = [NSString stringWithFormat:@"%.2f元",[[elements objectForKey:@"pay"] floatValue]];
                 self.inMoney.text = [NSString stringWithFormat:@"%.2f元",[[elements objectForKey:@"income"] floatValue]];
                 if(self.tableView.footerRefreshing)
                 {
                     if([[elements objectForKey:@"element"] isKindOfClass:[NSDictionary class]])
                     {
                         NSDictionary *dic = [elements objectForKey:@"element"];
                         [self.dataArray addObject: dic];
                     }
                     else
                     {
                         [self.dataArray addObjectsFromArray:[elements objectForKey:@"element"]];
                     }
                 }
                 else
                 {
                     if([[elements objectForKey:@"element"] isKindOfClass:[NSDictionary class]])
                     {
                         NSDictionary *dic = [elements objectForKey:@"element"];
                         [self.dataArray addObject: dic];
                     }
                     else
                     {
                         self.dataArray = [elements objectForKey:@"element"];
                     }
                 }
                 [self.tableView reloadData];
             }
         }
         else
         {
             [Utils showMessage:[oelement objectForKey:@"errormsg"]];
         }
         [self resumeTableView];
     }
     failed:^(NSString *failedMessage)
     {
         [self hideProgressHUD];
         [self resumeTableView];
         NSLog(@"error %@",failedMessage);
         [Utils showMessage:failedMessage];
     }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
