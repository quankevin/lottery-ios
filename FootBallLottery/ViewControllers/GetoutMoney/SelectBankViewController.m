//
//  SelectBankViewController.m
//  FootBallLottery
//
//  Created by jaye on 15/1/5.
//  Copyright (c) 2015年 jaye. All rights reserved.
//

#import "SelectBankViewController.h"

@interface SelectBankViewController ()

@end

@implementation SelectBankViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    [self setupMenuBarButtonItems];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 110, kWindowWidth, kWindowHeight - 110)];
    self.tableView.tag = 10;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    
    self.saveBankImageArray = [[NSMutableArray alloc] initWithObjects:@"3.png",@"1.png",@"5.png",@"9.png",@"13.png",@"12.png",@"11.png",@"10.png",@"8.png", nil];
    
    self.creaditCardImageArray = [[NSMutableArray alloc] initWithObjects:@"6.png",@"14.png",@"3.png",@"5.png",@"15.png",@"8.png",@"7.png",@"9.png",@"13.png",@"9.png",@"11.png",@"10.png",@"1.png",@"4.png",@"2.png", nil];
}

- (IBAction)backAction:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
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
    label.text = @"选择银行";
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
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)btnActionClick:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    if(btn.tag == 10)
    {
        [self.selectGroundImage setImage:[UIImage imageNamed:@"tab_chuxuka.png"]];
    }
    else if (btn.tag == 11)
    {
        [self.selectGroundImage setImage:[UIImage imageNamed:@"tab_xinyongka.png"]];
    }
    self.tableView.tag = btn.tag;
    [self.tableView reloadData];
}

#pragma mark - tableView delegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identify = @"bankTabelView";
    BankTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    if(!cell)
    {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"BankTableViewCell" owner:nil options:nil]lastObject];
    }
    if(tableView.tag == 10)
    {
        [cell.bankImage setImage:[UIImage imageNamed:[self.saveBankImageArray objectAtIndex:indexPath.row]]];
        [cell.bankLabel setText:[[[[AppDelegate getAppDelegate] bankList] objectAtIndex:indexPath.row] objectForKey:@"bankName"]];
    }
    else if (tableView.tag == 11)
    {
        [cell.bankImage setImage:[UIImage imageNamed:[self.creaditCardImageArray objectAtIndex:indexPath.row]]];
        [cell.bankLabel setText:[[[[AppDelegate getAppDelegate] bankList_c] objectAtIndex:indexPath.row] objectForKey:@"bankName"]];
    }

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if(tableView.tag == 10)
    {
        [[AppDelegate getAppDelegate] setRechargeBankCard:[[[[AppDelegate getAppDelegate] bankList] objectAtIndex:indexPath.row] objectForKey:@"bankName"]];
        [[AppDelegate getAppDelegate] setBankType:saveBank];
        [[AppDelegate getAppDelegate] setBankCode:[[[[AppDelegate getAppDelegate] bankList] objectAtIndex:indexPath.row] objectForKey:@"bankCode"]];
    }
    else
    {
        [[AppDelegate getAppDelegate] setRechargeBankCard:[[[[AppDelegate getAppDelegate] bankList_c] objectAtIndex:indexPath.row] objectForKey:@"bankName"]];
        [[AppDelegate getAppDelegate] setBankType:creaditBank];
        [[AppDelegate getAppDelegate] setBankCode:[[[[AppDelegate getAppDelegate] bankList_c] objectAtIndex:indexPath.row] objectForKey:@"bankCode"]];
    }
    
    NSLog(@"bankcode %@",[[AppDelegate getAppDelegate] bankCode]);
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"bankInfro" object:nil];
    
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(self.tableView.tag == 10)
    {
        return self.saveBankImageArray.count;
    }
    return self.creaditCardImageArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
