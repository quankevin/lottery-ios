//
//  HistoryDetailViewController.m
//  FootBallLottery
//
//  Created by jaye on 15/1/11.
//  Copyright (c) 2015年 jaye. All rights reserved.
//

#import "HistoryDetailViewController.h"

@interface HistoryDetailViewController ()

@end

@implementation HistoryDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //日期
    self.dataLabel.text = self.data;
    //星期
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *date = [dateFormatter dateFromString:self.data];
    self.weekLabel.text = [Utils dateDataWithDate:date];
    //结果
    if(![self.hitCount isEqualToString:@"0"])
    {
        self.resultLabel.textColor = [Utils colorWithHexString:@"#DEA20C"];
    }
    
    self.resultLabel.text = [NSString stringWithFormat:@"%@/%@",self.hitCount,self.count];
    
    [self createTableView];
    self.dataArray = [[NSMutableArray alloc] init];
    [self requestNetWork];
}

- (void)createTableView
{
    if(!self.tableView)
    {
        self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 100, kWindowWidth, kWindowHeight - 100) style:UITableViewStylePlain];
        self.tableView.backgroundColor = [UIColor clearColor];
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        //给tableView添加下拉刷新
//        [self.tableView addHeaderWithTarget:self action:@selector(requestNetWork) dateKey:nil];
        [self.view addSubview:self.tableView];
    }
}

- (IBAction)backActionClick:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

#pragma mark - tableView delegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identity = @"historyDetailTableView";
    HistoryDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identity];
    if(!cell)
    {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"HistoryDetailTableViewCell" owner:nil options:nil]lastObject];
    }

    cell.dataDic = [self.dataArray objectAtIndex:indexPath.row];
    
    return cell;
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
//详情赛果
- (void)requestNetWork
{
    NSMutableString *unmd5str = [[NSMutableString alloc] init];
    [unmd5str appendString:TestKey];
    
    NSString *xmlStr = [NSString stringWithFormat:
                        @"<body>"
                        "<elements>"
                        "<element>"
                        "<date>%@</date>"
                        "</element>"
                        "</elements>"
                        "</body>",self.data];
    [unmd5str appendString:xmlStr];
    
    NSMutableString *post = [[NSMutableString alloc] init];
    post = [NSMutableString stringWithFormat:
            @"SumaLottery=<?xml version =\"1.0\"encoding=\"UTF-8\"?>"
            "<message version=\"1.0\">"
            "<header>"
            "<transactiontype>12025</transactiontype>"
            "<timestamp>%@</timestamp>"
            "<digest>%@</digest>"
            "<agenterid>10000002</agenterid>"
            "<ipaddress></ipaddress>"
            "<source>WEB</source>"
            "</header>"
            "<body>"
            "<elements>"
            "<element>"
            "<date>%@</date>"
            "</element>"
            "</elements>"
            "</body>"
            "</message>",
            [Utils getcurrenttime],[Utils md5:unmd5str],self.data];
    
    [self showProgressHUD:@"加载中"];
    [self.connection requestConnection:SERVER_URL
                            postParams:post
                            completion:^(NSMutableDictionary *responseDict)
     {
         [self hideProgressHUD];
         NSLog(@"history detail responsedic %@",responseDict);
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
                 self.dataArray = [elements objectForKey:@"element"];
             }
             [self.tableView reloadData];
         }
         else
         {
             [Utils showMessage:[oelement objectForKey:@"errormsg"]];
         }
         [self.tableView headerEndRefreshing];
         [self.tableView reloadData];
     }
     failed:^(NSString *failedMessage)
     {
         [self hideProgressHUD];
         [self.tableView headerEndRefreshing];
         [self.tableView reloadData];
         NSLog(@"error %@",failedMessage);
         [Utils showMessage:failedMessage];
     }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
