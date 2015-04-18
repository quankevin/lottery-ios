//
//  GetoutMoneyViewController.m
//  FootBallLottery
//
//  Created by jaye on 15/1/2.
//  Copyright (c) 2015年 jaye. All rights reserved.
//

#import "GetoutMoneyViewController.h"

@interface GetoutMoneyViewController ()

@end

@implementation GetoutMoneyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupMenuBarButtonItems];
    
    self.headView.frame = CGRectMake(0, 64, CGRectGetWidth(self.headView.frame), CGRectGetHeight(self.headView.frame));
    self.headView.hidden = NO;
    [self.view addSubview:self.headView];
    self.remainMoney.text = [NSString stringWithFormat:@"%@元",[[AppDelegate getAppDelegate] accountRemaind]];
    
    self.bankInfroView.frame = CGRectMake(0, 130, CGRectGetWidth(self.bankInfroView.frame), CGRectGetHeight(self.bankInfroView.frame));
    [self.view addSubview:self.bankInfroView];
    self.bankInfroView.hidden = NO;
    self.bankName.text = [[AppDelegate getAppDelegate] bankName];
    NSString *bankCard = [[AppDelegate getAppDelegate] bankCard];
    self.bankNumber.text = [NSString stringWithFormat:@"尾号为  %@",[bankCard substringWithRange:NSMakeRange(bankCard.length - 4, 4)]];
}

//发送验证码
- (IBAction)senderCheckCode:(id)sender
{
    [self.checkCodeTextField resignFirstResponder];
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
    label.textColor = [Utils colorWithHexString:@"#E6E9E7"];;
    label.font = [UIFont systemFontOfSize:20.0f];
    label.text = @"提现";
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

//选择银行
- (IBAction)selectBank:(id)sender
{
    SelectBankViewController *selectBank = [[SelectBankViewController alloc] initWithNibName:@"SelectBankViewController" bundle:nil];
    [self.navigationController pushViewController:selectBank animated:YES];
}

//选择开户地
- (IBAction)selectZone:(id)sender
{
    SelectZoneViewController *selectZone = [[SelectZoneViewController alloc] initWithNibName:@"SelectZoneViewController" bundle:nil];
    [self.navigationController pushViewController:selectZone animated:YES];
}

//提交
- (IBAction)doneActionClick:(id)sender
{
    if(self.getOutMoneyTextFild.text.length == 0)
    {
        [Utils showMessage:@"请填写提款金额"];
        return;
    }
    else if([self.getOutMoneyTextFild.text floatValue] > [self.remainMoney.text floatValue])
    {
        [Utils showMessage:@"余额不足"];
        return;
    }
    else if(self.cardOwnerTextField.text.length == 0)
    {
        [Utils showMessage:@"请正确填写持卡人姓名"];
        return;
    }
    else if (self.IdTextField.text.length != 18 || ![Utils checkIdentityCardNo:self.IdTextField.text])
    {
        [Utils showMessage:@"请正确填写身份证号码"];
        return;
    }
    else if (self.bankTextField.text.length == 0)
    {
        [Utils showMessage:@"请选择银行"];
        return;
    }
    else if (self.cardNumberTextField.text.length == 0)
    {
        [Utils showMessage:@"请正确填写卡号"];
        return;
    }
    else if (self.accountZoneTextField.text.length == 0)
    {
        [Utils showMessage:@"请选择开户地"];
        return;
    }
    else if (self.passwordTextField.text.length == 0)
    {
        [Utils showMessage:@"请正确填写密码"];
        return;
    }
    
    [self.firstView setHidden:YES];
    self.cardNumberTextField.text = nil;
    self.cardOwnerTextField.text = nil;
    self.bankTextField.text = nil;
    self.accountZoneTextField.text = nil;
    self.passwordTextField.text = nil;
    self.IdTextField.text = nil;
    [self.cardOwnerBg setImage:[UIImage imageNamed:@"textfield_normal.png"]];
    [self.IdBg setImage:[UIImage imageNamed:@"textfield_normal.png"]];
    [self.bankBg setImage:[UIImage imageNamed:@"textfield_normal.png"]];
    [self.cardNumBg setImage:[UIImage imageNamed:@"textfield_normal.png"]];
    [self.accountZoneBg setImage:[UIImage imageNamed:@"textfield_normal.png"]];
    [self.passwordBg setImage:[UIImage imageNamed:@"textfield_normal.png"]];
    self.bankInfroView.frame = CGRectMake(0, 130, CGRectGetWidth(self.bankInfroView.frame), CGRectGetHeight(self.bankInfroView.frame));
    [self.view addSubview:self.bankInfroView];
    self.bankInfroView.hidden = NO;
}

- (void)backButtonPressed:(id)sender
{
    [[AppDelegate getAppDelegate] setIsSlider:YES];
    [self.navigationController popToRootViewControllerAnimated:YES];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"back" object:nil];
}

//确定提现
- (IBAction)ensureActionClick:(id)sender
{
    [self.getOutMoneyTextFild resignFirstResponder];
    if(self.getOutMoneyTextFild.text.length == 0)
    {
        [Utils showMessage:@"请输入提款金额"];
        return;
    }
    
    if([self.getOutMoneyTextFild.text compare:self.remainMoney.text] == NSOrderedDescending)
    {
        [Utils showMessage:@"余额不足,不能提现"];
        return;
    }
    
    [self requestGetOutMoney];
}

//确认支付
- (IBAction)payActionClick:(id)sender
{
    [self.checkCodeTextField resignFirstResponder];
    
    if(self.checkCodeTextField.text.length != 4)
    {
        [Utils showMessage:@"请正确输入验证码"];
        return;
    }
}

//提现完成
- (IBAction)OKActionClick:(id)sender
{
    [[AppDelegate getAppDelegate] setIsSlider:YES];
    [self.navigationController popToRootViewControllerAnimated:YES];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"back" object:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"recharegeSuccess" object:nil];
}

#pragma mark - textField delegate
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if(textField == self.cardOwnerTextField)
    {
        [self.cardOwnerBg setImage:[UIImage imageNamed:@"textfield_active.png"]];
        [self.IdBg setImage:[UIImage imageNamed:@"textfield_normal.png"]];
        [self.bankBg setImage:[UIImage imageNamed:@"textfield_normal.png"]];
        [self.cardNumBg setImage:[UIImage imageNamed:@"textfield_normal.png"]];
        [self.accountZoneBg setImage:[UIImage imageNamed:@"textfield_normal.png"]];
        [self.passwordBg setImage:[UIImage imageNamed:@"textfield_normal.png"]];
    }
    
    if(textField == self.IdTextField)
    {
        [self.cardOwnerBg setImage:[UIImage imageNamed:@"textfield_normal.png"]];
        [self.IdBg setImage:[UIImage imageNamed:@"textfield_active.png"]];
        [self.bankBg setImage:[UIImage imageNamed:@"textfield_normal.png"]];
        [self.cardNumBg setImage:[UIImage imageNamed:@"textfield_normal.png"]];
        [self.accountZoneBg setImage:[UIImage imageNamed:@"textfield_normal.png"]];
        [self.passwordBg setImage:[UIImage imageNamed:@"textfield_normal.png"]];
    }
    
    if(textField == self.bankTextField)
    {
        [self.cardOwnerBg setImage:[UIImage imageNamed:@"textfield_normal.png"]];
        [self.IdBg setImage:[UIImage imageNamed:@"textfield_normal.png"]];
        [self.bankBg setImage:[UIImage imageNamed:@"textfield_active.png"]];
        [self.cardNumBg setImage:[UIImage imageNamed:@"textfield_normal.png"]];
        [self.accountZoneBg setImage:[UIImage imageNamed:@"textfield_normal.png"]];
        [self.passwordBg setImage:[UIImage imageNamed:@"textfield_normal.png"]];
    }
    
    if(textField == self.cardNumberTextField)
    {
        [self.cardOwnerBg setImage:[UIImage imageNamed:@"textfield_normal.png"]];
        [self.IdBg setImage:[UIImage imageNamed:@"textfield_normal.png"]];
        [self.bankBg setImage:[UIImage imageNamed:@"textfield_normal.png"]];
        [self.cardNumBg setImage:[UIImage imageNamed:@"textfield_active.png"]];
        [self.accountZoneBg setImage:[UIImage imageNamed:@"textfield_normal.png"]];
        [self.passwordBg setImage:[UIImage imageNamed:@"textfield_normal.png"]];
    }
    
    if(textField == self.accountZoneTextField)
    {
        [self.cardOwnerBg setImage:[UIImage imageNamed:@"textfield_normal.png"]];
        [self.IdBg setImage:[UIImage imageNamed:@"textfield_normal.png"]];
        [self.bankBg setImage:[UIImage imageNamed:@"textfield_normal.png"]];
        [self.cardNumBg setImage:[UIImage imageNamed:@"textfield_normal.png"]];
        [self.accountZoneBg setImage:[UIImage imageNamed:@"textfield_active.png"]];
        [self.passwordBg setImage:[UIImage imageNamed:@"textfield_normal.png"]];
    }
    
    if(textField == self.passwordTextField)
    {
        [self.cardOwnerBg setImage:[UIImage imageNamed:@"textfield_normal.png"]];
        [self.IdBg setImage:[UIImage imageNamed:@"textfield_normal.png"]];
        [self.bankBg setImage:[UIImage imageNamed:@"textfield_normal.png"]];
        [self.cardNumBg setImage:[UIImage imageNamed:@"textfield_normal.png"]];
        [self.accountZoneBg setImage:[UIImage imageNamed:@"textfield_normal.png"]];
        [self.passwordBg setImage:[UIImage imageNamed:@"textfield_active.png"]];
    }
    
    if(textField == self.checkCodeTextField)
    {
        [self.checkCodeBg setImage:[UIImage imageNamed:@"textfield_active.png"]];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if(textField == self.cardOwnerTextField)
    {
        return [self.IdTextField becomeFirstResponder];
    }
    else if (textField == self.IdTextField)
    {
        return [self.bankTextField becomeFirstResponder];
    }
    else if (textField == self.bankTextField)
    {
        [self changeViewOriginY];
        return [self.cardNumberTextField becomeFirstResponder];
    }
    else if (textField == self.cardNumberTextField)
    {
        [self changeViewOriginY];
        return [self.accountZoneTextField becomeFirstResponder];
    }
    else if (textField == self.accountZoneTextField)
    {
        [self changeViewOriginY];
        return [self.passwordTextField becomeFirstResponder];
    }
    else if (textField == self.passwordTextField)
    {
        [self.passwordBg setImage:[UIImage imageNamed:@"textfield_normal.png"]];
        [self resumeViewOriginY];
        return [self.passwordTextField resignFirstResponder];
    }
    
    if(textField == self.checkCodeTextField)
    {
        [self.checkCodeBg setImage:[UIImage imageNamed:@"textfield_normal.png"]];
        return [self.checkCodeTextField resignFirstResponder];
    }
    
    return [textField resignFirstResponder];
}


//改变试图y坐标
- (void)changeViewOriginY
{
    [UIView animateWithDuration:0.5f animations:^{
        CGRect frame = self.firstView.frame;
        frame.origin.y -= 50;
        self.firstView.frame = frame;
    }];
}

//恢复试图y坐标
- (void)resumeViewOriginY
{
    [UIView animateWithDuration:0.5f animations:^{
        self.firstView.frame = CGRectMake(0, 130, CGRectGetWidth(self.firstView.frame), CGRectGetHeight(self.firstView.frame));
    }];
}

#pragma mark - view touch
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self resumeViewOriginY];
    [self.firstView endEditing:YES];
    [self.payView endEditing:YES];
    [self.headView endEditing:YES];
    [self.cardOwnerBg setImage:[UIImage imageNamed:@"textfield_normal.png"]];
    [self.IdBg setImage:[UIImage imageNamed:@"textfield_normal.png"]];
    [self.bankBg setImage:[UIImage imageNamed:@"textfield_normal.png"]];
    [self.cardNumBg setImage:[UIImage imageNamed:@"textfield_normal.png"]];
    [self.accountZoneBg setImage:[UIImage imageNamed:@"textfield_normal.png"]];
    [self.passwordBg setImage:[UIImage imageNamed:@"textfield_normal.png"]];
    [self.checkCodeBg setImage:[UIImage imageNamed:@"textfield_normal.png"]];
}

#pragma mark - request server
//请求提现
- (void)requestGetOutMoney
{
    NSMutableString *unmd5str = [[NSMutableString alloc] init];
    [unmd5str appendString:TestKey];
    NSArray *array = [self.getOutMoneyTextFild.text componentsSeparatedByString:@"."];
    NSString *drawalMoney = [NSString stringWithFormat:@"%@00",[array objectAtIndex:0]];
    NSString *xmlStr = [NSString stringWithFormat:
                        @"<body>"
                        "<elements>"
                        "<element drawaltype=\"0\">"
                        "<uid>%@</uid>"
                        "<password>%@</password>"
                        "<drawalmoney>%@</drawalmoney>"
                        "</element>"
                        "</elements>"
                        "</body>",[[AppDelegate getAppDelegate] uid],[Utils MD5Password:[[AppDelegate getAppDelegate] userPassword]],drawalMoney];
    [unmd5str appendString:xmlStr];
    
    NSMutableString *post = [[NSMutableString alloc] init];
    post = [NSMutableString stringWithFormat:
            @"SumaLottery=<?xml version =\"1.0\"encoding=\"UTF-8\"?>"
            "<message version=\"1.0\">"
            "<header>"
            "<transactiontype>20003_1.1</transactiontype>"
            "<timestamp>%@</timestamp>"
            "<digest>%@</digest>"
            "<agenterid>10000002</agenterid>"
            "<ipaddress></ipaddress>"
            "<source>WEB</source>"
            "</header>"
            "<body>"
            "<elements>"
            "<element drawaltype=\"0\">"
            "<uid>%@</uid>"
            "<password>%@</password>"
            "<drawalmoney>%@</drawalmoney>"
            "</element>"
            "</elements>"
            "</body>"
            "</message>",[Utils getcurrenttime],[Utils md5:unmd5str],[[AppDelegate getAppDelegate] uid],[Utils MD5Password:[[AppDelegate getAppDelegate] userPassword]],drawalMoney];
    
    NSLog(@"getout money request %@",post);
    [self showProgressHUD:@"加载中"];
    
    [self.connection requestConnection:SERVER_URL
                            postParams:post
                            completion:^(NSMutableDictionary *responseDict)
     {
         [self hideProgressHUD];
         NSLog(@"getout money response %@",responseDict);
         NSDictionary *bodyDic = [responseDict objectForKey:@"body"];
         NSDictionary *oelement = [bodyDic objectForKey:@"oelement"];
         if([[oelement objectForKey:@"errorcode"] isEqualToString:@"0"])
         {
             self.headView.hidden = YES;
             self.bankInfroView.hidden = YES;
    
             self.paySuccessView.frame = CGRectMake(0, 70, CGRectGetWidth(self.paySuccessView.frame), CGRectGetWidth(self.paySuccessView.frame));
             self.paySuccessView.hidden = NO;
             self.getOutRemainMoney.text = [NSString stringWithFormat:@"%@ 元",self.getOutMoneyTextFild.text];
             [self.view addSubview:self.paySuccessView];
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
