//
//  RightViewController.m
//  FootBallLottery
//
//  Created by jaye on 15/1/2.
//  Copyright (c) 2015年 jaye. All rights reserved.
//

#import "RightViewController.h"

@interface RightViewController ()

@end

@implementation RightViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.dataArray = [[NSMutableArray alloc] init];
    indexPage = 1;
    [self createTableView];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(requestNetWork) name:@"rightSideMenViewController" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(rightClosed) name:@"viewControllerClosed" object:nil];
}

- (void)rightClosed
{
    indexPage = 1;
    [self.dataArray removeAllObjects];
    [self.tableView reloadData];
}

- (IBAction)backActionClick:(id)sender
{
    self.sideMenu.menuState = MFSideMenuStateClosed;
}

- (void)createTableView
{
    if(!self.tableView)
    {
        self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 95, kWindowWidth, kWindowHeight - 95)];
        self.tableView.backgroundColor = [UIColor clearColor];
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.tableView.delegate   = self;
        self.tableView.dataSource = self;
        //给tableView添加上拉加载
        [self.tableView addFooterWithTarget:self action:@selector(upPullLoading)];
        [self.view addSubview:self.tableView];
    }
}

- (void)upPullLoading
{
    if(count % 10 == 0)
    {
        if(indexPage + 1> count/10)
        {
            [Utils showMessage:@"已显示全部内容"];
            [self.tableView footerEndRefreshing];
            return;
        }
    }
    else
    {
        if(indexPage + 1 > count/10+1)
        {
            [Utils showMessage:@"已显示全部内容"];
            [self.tableView footerEndRefreshing];
            return;
        }
    }
    indexPage += 1;
    [self requestNetWork];
}

- (void)resumeTaleView
{
    [self.tableView headerEndRefreshing];
    [self.tableView footerEndRefreshing];
    [self.tableView reloadData];
}

#pragma mark - tableView delegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identity = @"detailHistoryTableView";
    HistoryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identity];
    if(!cell)
    {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"HistoryTableViewCell" owner:nil options:nil]lastObject];
    }
    
    cell.dataDic = [self.dataArray objectAtIndex:indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    HistoryDetailViewController *hisDetail = [[HistoryDetailViewController alloc] initWithNibName:@"HistoryDetailViewController" bundle:nil];
    NSDictionary *dic = [self.dataArray objectAtIndex:indexPath.row];
    
    hisDetail.data = [dic objectForKey:@"date"];
    hisDetail.hitCount = [dic objectForKey:@"hitcount"];
    hisDetail.count = [dic objectForKey:@"count"];
    [self presentViewController:hisDetail animated:YES completion:^{
    
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([self.dataArray isEqual:[NSNull null]])
        return 0;
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
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
                        "<startdate></startdate>"
                        "<enddate></enddate>"
                        "<pageNum>%d</pageNum>"
                        "<pageSize>10</pageSize>"
                        "</element>"
                        "</elements>"
                        "</body>",indexPage];
    [unmd5str appendString:xmlStr];
    
    NSMutableString *post = [[NSMutableString alloc] init];
    post = [NSMutableString stringWithFormat:
            @"SumaLottery=<?xml version =\"1.0\"encoding=\"UTF-8\"?>"
            "<message version=\"1.0\">"
            "<header>"
            "<transactiontype>12026</transactiontype>"
            "<timestamp>%@</timestamp>"
            "<digest>%@</digest>"
            "<agenterid>10000002</agenterid>"
            "<ipaddress></ipaddress>"
            "<source>WEB</source>"
            "</header>"
            "<body>"
            "<elements>"
            "<element>"
            "<startdate></startdate>"
            "<enddate></enddate>"
            "<pageNum>%d</pageNum>"
            "<pageSize>10</pageSize>"
            "</element>"
            "</elements>"
            "</body>"
            "</message>",
            [Utils getcurrenttime],[Utils md5:unmd5str],indexPage];
    
     NSLog(@"history introdece request %@",post);
    if(!isSuccess)
    {
        [self showProgressHUD:@"加载中"];
    }
    
    
    [self.connection requestConnection:SERVER_URL
                            postParams:post
                            completion:^(NSMutableDictionary *responseDict)
     {
         [self hideProgressHUD];
         NSLog(@"history introduce responseDict %@",responseDict);
         NSDictionary *bodyDic = [responseDict objectForKey:@"body"];
         NSDictionary *oelement = [bodyDic objectForKey:@"oelement"];
         NSDictionary *elements = [bodyDic objectForKey:@"elements"];
         if([[oelement objectForKey:@"errorcode"] isEqualToString:@"0"])
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
             count = [[elements objectForKey:@"count"] intValue];
             isSuccess = YES;
         }
         else
         {
             [Utils showMessage:[oelement objectForKey:@"errormsg"]];
         }
         [self resumeTaleView];
     }
     failed:^(NSString *failedMessage)
     {
         [self hideProgressHUD];
         [self resumeTaleView];
         if(self.tableView.footerRefreshing)
         {
             indexPage -= 1;
         }
         
         NSLog(@"error %@",failedMessage);
         [Utils showMessage:failedMessage];
     }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
