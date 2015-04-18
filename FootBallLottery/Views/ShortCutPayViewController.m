//
//  ShortCutPayViewController.m
//  FootBallLottery
//
//  Created by jaye on 15/2/2.
//  Copyright (c) 2015年 jaye. All rights reserved.
//

#import "ShortCutPayViewController.h"

@interface ShortCutPayViewController ()

@end

@implementation ShortCutPayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.payView.frame = CGRectMake(0, 70, CGRectGetWidth(self.payView.frame), CGRectGetWidth(self.payView.frame));
    self.payView.hidden = NO;
    [self.view addSubview:self.payView];
    
    self.successView.frame = CGRectMake(0, 70, CGRectGetWidth(self.successView.frame), CGRectGetHeight(self.successView.frame));
    self.successView.hidden = YES;
    [self.view addSubview:self.successView];
    
    if([self.bankType isEqualToString:@"0"])
    {
        self.bankType = @"储蓄卡";
    }
    else if([self.bankType isEqualToString:@"1"])
    {
        self.bankType = @"信用卡";
    }
    self.bankInfro.text = [NSString stringWithFormat:@"使用尾号为 %@ 的%@",[self.bankCardNum substringWithRange:NSMakeRange(6,4)],self.bankType];
    self.money.text = [NSString stringWithFormat:@"充值 %@元",self.rechargeMoney];
}


- (IBAction)backAction:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

#pragma mark - textField delegate
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self.checkCodeBg setImage:[UIImage imageNamed:@"textfield_normal.png"]];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.checkCodeBg setImage:[UIImage imageNamed:@"textfield_normal.png"]];
    return [textField resignFirstResponder];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.checkCodeBg setImage:[UIImage imageNamed:@"textfield_normal.png"]];
    [self.payView endEditing:YES];
}

//发送验证码
- (IBAction)senderCheckCode:(id)sender
{
    [self requestServer];
}

//提交
- (IBAction)handAction:(id)sender
{
    if(self.checkCodeTextField.text.length != 6)
    {
        [Utils showMessage:@"请输入验证码"];
        return;
    }
    
    [self.checkCodeBg setImage:[UIImage imageNamed:@"textfield_normal.png"]];
    [self.payView endEditing:YES];
    [self requestRecharge];
}


//完成
- (IBAction)okAction:(id)sender
{
    self.payView.hidden = NO;
    self.successView.hidden = YES;
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
                        "<totalPrice>%@</totalPrice>"
                        "</element>"
                        "</elements>"
                        "</body>",[[AppDelegate getAppDelegate] uid],self.rechargeMoney];
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
            "<totalPrice>%@</totalPrice>"
            "</element>"
            "</elements>"
            "</body>"
            "</message>",[Utils getcurrenttime],[Utils md5:unmd5str],[[AppDelegate getAppDelegate] uid],self.rechargeMoney];
    
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
         if([[oelement objectForKey:@"errorcode"] isEqualToString:@"0"])
         {
             self.requestOrderId = [oelement objectForKey:@"requestId"];
             [self requestCheckCode];
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

- (void)requestCheckCode
{
    NSMutableString *unmd5str = [[NSMutableString alloc] init];
    [unmd5str appendString:TestKey];
    
    NSString *xmlStr = [NSString stringWithFormat:
                        @"<body>"
                        "<elements>"
                        "<element>"
                        "<requestOrderId>%@</requestOrderId>"
                        "<bankCode>%@</bankCode>"
                        "<bindId>%@</bindId>"
                        "<userIdIdentity>%@</userIdIdentity>"
                        "</element>"
                        "</elements>"
                        "</body>",self.requestOrderId,self.bankCode,self.bandId,[[AppDelegate getAppDelegate] uid]];
    [unmd5str appendString:xmlStr];
    
    NSMutableString *post = [[NSMutableString alloc] init];
    post = [NSMutableString stringWithFormat:
            @"SumaLottery=<?xml version =\"1.0\"encoding=\"UTF-8\"?>"
            "<message version=\"1.0\">"
            "<header>"
            "<transactiontype>15010</transactiontype>"
            "<timestamp>%@</timestamp>"
            "<digest>%@</digest>"
            "<agenterid>10000002</agenterid>"
            "<ipaddress></ipaddress>"
            "<source>WEB</source>"
            "</header>"
            "<body>"
            "<elements>"
            "<element>"
            "<requestOrderId>%@</requestOrderId>"
            "<bankCode>%@</bankCode>"
            "<bindId>%@</bindId>"
            "<userIdIdentity>%@</userIdIdentity>"
            "</element>"
            "</elements>"
            "</body>"
            "</message>",[Utils getcurrenttime],[Utils md5:unmd5str],self.requestOrderId,self.bankCode,self.bandId,[[AppDelegate getAppDelegate] uid]];
    
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
         if([[oelement objectForKey:@"errorcode"] isEqualToString:@"0"])
         {
             [Utils showMessage:@"短信已发送您手机，请注意查收"];
             self.randomValidateId = [oelement objectForKey:@"randomValidateId"];
             self.tradeId = [oelement objectForKey:@"tradeId"];
             [self.checkCodeBtn setTitle:@"60" forState:UIControlStateNormal];
             [self.checkCodeBtn setBackgroundImage:[UIImage imageNamed:@"yanzhengma_active.png"] forState:UIControlStateNormal];
             timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(countTime) userInfo:nil repeats:YES];
             self.checkCodeBtn.userInteractionEnabled = NO;
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

- (void)countTime
{
    int count = [self.checkCodeBtn.titleLabel.text intValue];
    count -= 1;
    [self.checkCodeBtn setTitle:[NSString stringWithFormat:@"%d",count] forState:UIControlStateNormal];
    if(count < 0)
    {
        [timer invalidate];
        timer = nil;
        self.checkCodeBtn.userInteractionEnabled = YES;
        [self.checkCodeBtn setTitle:@"" forState:UIControlStateNormal];
        [self.checkCodeBtn setBackgroundImage:[UIImage imageNamed:@"check_code.png"] forState:UIControlStateNormal];
    }
}

- (void)requestRecharge
{
    NSMutableString *unmd5str = [[NSMutableString alloc] init];
    [unmd5str appendString:TestKey];
    
    NSString *xmlStr = [NSString stringWithFormat:
                        @"<body>"
                        "<elements>"
                        "<element>"
                        "<requestOrderId>%@</requestOrderId>"
                        "<bankCode>%@</bankCode>"
                        "<bindId>%@</bindId>"
                        "<userIdIdentity>%@</userIdIdentity>"
                        "<randomValidateId>%@</randomValidateId>"
                        "<randomCode>%@</randomCode>"
                        "<tradeId>%@</tradeId>"
                        "</element>"
                        "</elements>"
                        "</body>",self.requestOrderId,self.bankCode,self.bandId,[[AppDelegate getAppDelegate] uid],self.randomValidateId,self.checkCodeTextField.text,self.tradeId];
    [unmd5str appendString:xmlStr];
    
    NSMutableString *post = [[NSMutableString alloc] init];
    post = [NSMutableString stringWithFormat:
            @"SumaLottery=<?xml version =\"1.0\"encoding=\"UTF-8\"?>"
            "<message version=\"1.0\">"
            "<header>"
            "<transactiontype>15008</transactiontype>"
            "<timestamp>%@</timestamp>"
            "<digest>%@</digest>"
            "<agenterid>10000002</agenterid>"
            "<ipaddress></ipaddress>"
            "<source>WEB</source>"
            "</header>"
            "<body>"
            "<elements>"
            "<element>"
            "<requestOrderId>%@</requestOrderId>"
            "<bankCode>%@</bankCode>"
            "<bindId>%@</bindId>"
            "<userIdIdentity>%@</userIdIdentity>"
            "<randomValidateId>%@</randomValidateId>"
            "<randomCode>%@</randomCode>"
            "<tradeId>%@</tradeId>"
            "</element>"
            "</elements>"
            "</body>"
            "</message>",[Utils getcurrenttime],[Utils md5:unmd5str],self.requestOrderId,self.bankCode,self.bandId,[[AppDelegate getAppDelegate] uid],self.randomValidateId,self.checkCodeTextField.text,self.tradeId];
    
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
         if([[oelement objectForKey:@"errorcode"] isEqualToString:@"0"])
         {
             self.checkCodeTextField.text = @"";
             self.payView.hidden = YES;
             self.successView.hidden = NO;
             self.remainMoney.text = [NSString stringWithFormat:@"%@元",[oelement objectForKey:@"money"]];
             [[NSNotificationCenter defaultCenter] postNotificationName:@"recharegeSuccess" object:nil];
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
