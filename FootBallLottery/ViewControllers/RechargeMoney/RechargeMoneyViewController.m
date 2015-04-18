//
//  RechargeMoneyViewController.m
//  FootBallLottery
//
//  Created by jaye on 15/1/2.
//  Copyright (c) 2015年 jaye. All rights reserved.
//

#import "RechargeMoneyViewController.h"

@interface RechargeMoneyViewController ()

@end

@implementation RechargeMoneyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupMenuBarButtonItems];
    
    self.btnArray = [[NSArray alloc] initWithObjects:self.firshBtn,self.secondBtn,self.thirdBtn,self.fouthBtn, nil];
    self.bankListArray = [[NSMutableArray alloc] init];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(recharegeSuccess) name:@"recharegeSuccess" object:nil];
    
    self.indexNum = 0;
    
    [self requestServer];
}

- (void)recharegeSuccess
{
    [self requestServer];
}

- (void)createTableView
{
    if(!self.tableView)
    {
        self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 150, kWindowWidth, kWindowHeight - 150)];
        self.tableView.bounces = NO;
        self.tableView.backgroundColor = [UIColor clearColor];
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        [self.view addSubview:self.tableView];
    }
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
    label.text = @"充值";
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

//选择充值金额
- (IBAction)selectRechargeMoney:(UIButton *)sender
{
    [sender setBackgroundImage:[UIImage imageNamed:@"money_active.png"] forState:UIControlStateNormal];
    [sender setTitleColor:[Utils colorWithHexString:@"#E6E9E7"] forState:UIControlStateNormal];
    
    for(int i = 0 ;i < self.btnArray.count;i++)
    {
        if(i != sender.tag - 10)
        {
            UIButton *btn = (UIButton *)[self.btnArray objectAtIndex:i];
            [btn setBackgroundImage:[UIImage imageNamed:@"money_normal.png"] forState:UIControlStateNormal];
            [btn setTitleColor:[Utils colorWithHexString:@"#138C65"] forState:UIControlStateNormal];
        }
    }
    
    if(sender.tag == 10)
    {
        self.rechargeMoney.text = @"10";
    }
    else if (sender.tag == 11)
    {
        self.rechargeMoney.text = @"50";
    }
    else if (sender.tag == 12)
    {
        self.rechargeMoney.text = @"100";
    }
    else if (sender.tag == 13)
    {
        self.rechargeMoney.text = @"500";
    }
}

//选择支付银行
- (IBAction)selectBankActionClick:(id)sender
{
    if(self.rechargeMoney.text.length == 0)
    {
        [Utils showMessage:@"请先输入充值金额"];
        return;
    }
    
    BankViewController *bankViewController = [[BankViewController alloc] initWithNibName:@"BankViewController" bundle:nil];
    bankViewController.rechargeMoney = self.rechargeMoney.text;
    [self presentViewController:bankViewController animated:YES completion:^{
        
    }];
}

//快捷支付
- (IBAction)quaijieAction:(id)sender
{
    if(self.rechargeMoney.text.length == 0)
    {
        [Utils showMessage:@"请先输入充值金额"];
        return;
    }
    
    ShortCutPayViewController *shortCut = [[ShortCutPayViewController alloc] init];
    shortCut.bandId = [[self.bankListArray objectAtIndex:self.indexNum] objectForKey:@"bindId"];
    shortCut.bankCode = [[self.bankListArray objectAtIndex:self.indexNum] objectForKey:@"bankCodeUsed"];
    shortCut.bankCardNum = [[self.bankListArray objectAtIndex:self.indexNum] objectForKey:@"bankAccount"];
    shortCut.rechargeMoney = self.rechargeMoney.text;
    shortCut.bankType = [[self.bankListArray objectAtIndex:self.indexNum] objectForKey:@"bankCardTypeUsed"];
    [self presentViewController:shortCut animated:YES completion:^{
        
    }];
}

#pragma mark - textField delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    return  [textField resignFirstResponder];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

#pragma mark - tableView delegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(self.bankListArray.count == 0)
    {
        static NSString *identity = @"bankListTableCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identity];
        
        if(!cell)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identity];
        }
        cell.backgroundColor = [UIColor clearColor];
        [cell addSubview:self.addBankView];
        return cell;
    }
    else
    {
        if(indexPath.row == rowCount - 1 || indexPath.row == rowCount - 2)
        {
            static NSString *identity = @"tableViewCell";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identity];
            
            if(!cell)
            {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identity];
            }
            cell.backgroundColor = [UIColor clearColor];
            
            if(indexPath.row == rowCount - 1)
            {
                [cell addSubview:self.kuaijieView];
            }
            if(indexPath.row == rowCount - 2)
            {
                [cell addSubview:self.addBankView];
            }
            return cell;
        }
        else
        {
            static NSString *identity = @"bankListTableCell";
            BankListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identity];
            if(!cell)
            {
                cell = [[[NSBundle mainBundle] loadNibNamed:@"BankListTableViewCell" owner:nil options:nil] lastObject];
            }
            
            if(indexPath.row == self.indexNum)
            {
                [cell.bgImageView setImage:[UIImage imageNamed:@"yinhangka_active.png"]];
            }
            else
            {
                [cell.bgImageView setImage:[UIImage imageNamed:@"yinhangka_normal.png"]];
            }
            cell.dataDic = [self.bankListArray objectAtIndex:0];
            
            return cell;
        }
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.indexNum = indexPath.row;
    [self.tableView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(self.bankListArray.count == 0)
    {
        rowCount = 1;
        return 1;
    }
    else
    {
        rowCount = self.bankListArray.count + 2;
    }
    return self.bankListArray.count + 2;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UILabel *headLabel = [[UILabel alloc] init];
    headLabel.text = @"  请选择银行卡进行充值：";
    headLabel.textColor = [Utils colorWithHexString:@"#E6E9E7"];
    headLabel.backgroundColor = [UIColor clearColor];
    headLabel.font = [UIFont systemFontOfSize:13.0f];
    return headLabel;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(self.bankListArray.count != 0)
        return 20;
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

#pragma mark - request server
- (void)requestServer
{
    NSMutableString *unmd5str = [[NSMutableString alloc] init];
    [unmd5str appendString:TestKey];
    
    NSString *xmlStr = [NSString stringWithFormat:
                        @"<body>"
                        "<elements>"
                        "<element>"
                        "<userIdIdentity>%@</userIdIdentity>"
                        "<totalPrice>500</totalPrice>"
                        "</element>"
                        "</elements>"
                        "</body>",[[AppDelegate getAppDelegate] uid]];
    [unmd5str appendString:xmlStr];
    
    NSMutableString *post = [[NSMutableString alloc] init];
    post = [NSMutableString stringWithFormat:
            @"SumaLottery=<?xml version =\"1.0\"encoding=\"UTF-8\"?>"
            "<message version=\"1.0\">"
            "<header>"
            "<transactiontype>15006</transactiontype>"
            "<timestamp>%@</timestamp>"
            "<digest>%@</digest>"
            "<agenterid>10000002</agenterid>"
            "<ipaddress></ipaddress>"
            "<source>WEB</source>"
            "</header>"
            "<body>"
            "<elements>"
            "<element>"
            "<userIdIdentity>%@</userIdIdentity>"
            "<totalPrice>500</totalPrice>"
            "</element>"
            "</elements>"
            "</body>"
            "</message>",[Utils getcurrenttime],[Utils md5:unmd5str],[[AppDelegate getAppDelegate] uid]];
    
    NSLog(@"recharge request %@",post);
    [self showProgressHUD:@"加载中"];
    
    [self.connection requestConnection:SERVER_URL
                            postParams:post
                            completion:^(NSMutableDictionary *responseDict)
     {
         [self hideProgressHUD];
         NSLog(@"recharge response %@",responseDict);
         NSDictionary *bodyDic = [responseDict objectForKey:@"body"];
         NSDictionary *oelement = [bodyDic objectForKey:@"oelement"];
         NSDictionary *elements = [bodyDic objectForKey:@"elements"];
         
         if([[oelement objectForKey:@"errorcode"] isEqualToString:@"0"])
         {
             [[AppDelegate getAppDelegate] setBankList:[[elements objectForKey:@"bankList"] objectForKey:@"bank"]];
             [[AppDelegate getAppDelegate] setBankList_c:[[elements objectForKey:@"bankList_c"] objectForKey:@"bank"]];
             
             [self createTableView];
             
             if([[elements allKeys] containsObject:@"usedList"])
             {
                 if([[elements objectForKey:@"usedList"] isKindOfClass:[NSDictionary class]])
                 {
                     NSDictionary *dic = [[elements objectForKey:@"usedList"] objectForKey:@"usedbank"];
                     [self.bankListArray addObject: dic];
                 }
                 else
                 {
                     self.bankListArray = [[elements objectForKey:@"usedList"] objectForKey:@"usedbank"];
                 }
                 [self.tableView reloadData];
             }
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
