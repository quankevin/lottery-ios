//
//  VoteRecordViewController.m
//  FootBallLottery
//
//  Created by jaye on 15/1/2.
//  Copyright (c) 2015年 jaye. All rights reserved.
//

#import "VoteRecordViewController.h"

@interface VoteRecordViewController ()

@end

@implementation VoteRecordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupMenuBarButtonItems];
    self.dataArray = [[NSMutableArray alloc] init];
    [self createTableView];
    indexPage = 1;
    count = 0;
    self.voteRecordType = allVote;
    [self requestNetWork];
}

#pragma mark - navigationController
- (void)setupMenuBarButtonItems
{
    self.navigationItem.leftBarButtonItem = [self backBarButtonItem];
    self.navigationItem.titleView = [self tittleLabel];
}

//标题
- (UILabel *)tittleLabel
{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 50)];
    label.textColor = [Utils colorWithHexString:@"#E6E9E7"];
    label.font = [UIFont systemFontOfSize:20.0f];
    label.text = @"投注记录";
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

- (void)backButtonPressed:(id)sender
{
    [[AppDelegate getAppDelegate] setIsSlider:YES];
    [self.navigationController popToRootViewControllerAnimated:YES];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"back" object:nil];
}


- (void)createTableView
{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 110, kWindowWidth, kWindowHeight - 110)];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tag = 10;
    //给tableView添加下拉刷新,上拉加载功能
    [self.tableView addHeaderWithTarget:self action:@selector(pullDownLoading) dateKey:@"table"];
    [self.tableView addFooterWithTarget:self action:@selector(pullUpLoading)];
    [self.view addSubview:self.tableView];
}

//下拉刷新
- (void)pullDownLoading
{
    indexPage = 1;
    count = 0;
    [self requestNetWork];
}

//上拉加载
- (void)pullUpLoading
{
    if(self.dataArray.count == 0)
    {
        [self.tableView footerEndRefreshing];
        return;
    }
    
    indexPage += 1;
    if(count % 10 == 0)
    {
        if(indexPage > count/10)
        {
            [Utils showMessage:@"已显示全部内容"];
            [self.tableView footerEndRefreshing];
            return;
        }
    }
    else
    {
        if(indexPage > count/10+1)
        {
            [Utils showMessage:@"已显示全部内容"];
            [self.tableView footerEndRefreshing];
            return;
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

- (IBAction)btnActionClick:(UIButton *)sender
{
    [self.dataArray removeAllObjects];
    [self.tableView reloadData];
    indexPage = 1;
    count = 0;
    if(sender.tag == 10)
    {
        [self.selectGroundImage setImage:[UIImage imageNamed:@"tab_quanbu.png"]];
        self.voteRecordType = allVote;
    }
    else if (sender.tag == 11)
    {
        [self.selectGroundImage setImage:[UIImage imageNamed:@"tab_zhongjiang.png"]];
        self.voteRecordType = winVote;
    }
    else if (sender.tag == 12)
    {
        [self.selectGroundImage setImage:[UIImage imageNamed:@"tab_daikai.png"]];
        self.voteRecordType = noOpenVote;
    }
    [self requestNetWork];
}

#pragma mark - tableView delegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identity = @"voteRecordTableView";
    VoteRecordTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identity];
    if(!cell)
    {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"VoteRecordTableViewCell" owner:nil options:nil]lastObject];
    }
    
    if(indexPath.row > 0)
    {
        NSDictionary *dic = [self.dataArray objectAtIndex:indexPath.row - 1];
        NSString *data = [[dic objectForKey:@"addtime"] substringWithRange:NSMakeRange(5, 5)];
        NSDictionary *nextDic = [self.dataArray objectAtIndex:indexPath.row];
        NSString *nextData = [[nextDic objectForKey:@"addtime"] substringWithRange:NSMakeRange(5, 5)];
        if([data isEqualToString:nextData])
        {
            cell.dataLabel.hidden = YES;
        }
    }
    cell.dataDic = [self.dataArray objectAtIndex:indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    OrderDetailViewController *orderDetail = [[OrderDetailViewController alloc] initWithNibName:@"OrderDetailViewController" bundle:nil];
    orderDetail.voteRecordType = self.voteRecordType;
    orderDetail.serialid = [[self.dataArray objectAtIndex:indexPath.row] objectForKey:@"serialid"];
    [self presentViewController:orderDetail animated:YES completion:^{
        
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}

#pragma mark - request server
//查询历史推荐
- (void)requestNetWork
{
    NSMutableString *unmd5str = [[NSMutableString alloc] init];
    [unmd5str appendString:TestKey];
    
    NSString *xmlStr = [NSString stringWithFormat:
                        @"<body>"
                        "<elements>"
                        "<element>"
                        "<uid>%@</uid>"
                        "<lotteryid>130</lotteryid>"
                        "<startdate></startdate>"
                        "<enddate></enddate>"
                        "<investtype>1</investtype>"
                        "<pageindex>%d</pageindex>"
                        "<pagesize>10</pagesize>"
                        "<statue>%d</statue>"
                        "</element>"
                        "</elements>"
                        "</body>",[[AppDelegate getAppDelegate] uid],indexPage,self.voteRecordType];
    [unmd5str appendString:xmlStr];
    
    NSMutableString *post = [[NSMutableString alloc] init];
    post = [NSMutableString stringWithFormat:
            @"SumaLottery=<?xml version =\"1.0\"encoding=\"UTF-8\"?>"
            "<message version=\"1.0\">"
            "<header>"
            "<transactiontype>12021_1.1</transactiontype>"
            "<timestamp>%@</timestamp>"
            "<digest>%@</digest>"
            "<agenterid>10000002</agenterid>"
            "<ipaddress></ipaddress>"
            "<source>WEB</source>"
            "</header>"
            "<body>"
            "<elements>"
            "<element>"
            "<uid>%@</uid>"
            "<lotteryid>130</lotteryid>"
            "<startdate></startdate>"
            "<enddate></enddate>"
            "<investtype>1</investtype>"
            "<pageindex>%d</pageindex>"
            "<pagesize>10</pagesize>"
            "<statue>%d</statue>"
            "</element>"
            "</elements>"
            "</body>"
            "</message>",
            [Utils getcurrenttime],[Utils md5:unmd5str],[[AppDelegate getAppDelegate] uid],indexPage,self.voteRecordType];
    
    NSLog(@"vote record request %@",post);
    [self showProgressHUD:@"加载中"];
    
    [self.connection requestConnection:SERVER_URL
                            postParams:post
                            completion:^(NSMutableDictionary *responseDict)
     {
         [self hideProgressHUD];
         NSLog(@"datedic %@",responseDict);
         NSDictionary *bodyDic = [responseDict objectForKey:@"body"];
         NSDictionary *oelement = [bodyDic objectForKey:@"oelement"];
         NSDictionary *elements = [bodyDic objectForKey:@"elements"];
         
         if([[oelement objectForKey:@"errorcode"] intValue] == 0)
         {
             if([[elements objectForKey:@"count"] isEqual: @"0"])
             {
                 [Utils showMessage:@"暂无记录"];
             }
             else
             {
                 count = [[elements objectForKey:@"count"] intValue];
                 if (self.tableView.footerRefreshing)
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
                     if(self.dataArray.count != 0)
                     {
                         [self.dataArray removeAllObjects];
                     }
                     
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
