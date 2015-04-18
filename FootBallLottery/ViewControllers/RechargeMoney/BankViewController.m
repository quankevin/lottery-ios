//
//  BankViewController.m
//  FootBallLottery
//
//  Created by jaye on 15/1/29.
//  Copyright (c) 2015年 jaye. All rights reserved.
//

#import "BankViewController.h"

@interface BankViewController ()

@end

@implementation BankViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(bankInfro) name:@"bankInfro" object:nil];
    self.bankView.frame = CGRectMake(0, 80, kWindowWidth, 400);
    [self.view addSubview:self.bankView];
    self.creadBankView.frame = CGRectMake(0, 80, kWindowWidth, 480);
    self.creadBankView.hidden = YES;
    [self.view addSubview:self.creadBankView];
    self.headView.frame = CGRectMake(0, 0, kWindowWidth, 70);
    [self.view addSubview:self.headView];
}

- (void)bankInfro
{
    if([[AppDelegate getAppDelegate] bankType] == creaditBank)
    {
        if(self.cardHolderTextField.text.length != 0)
        {
            self.creadHolderTextField.text = self.cardHolderTextField.text;
        }
        
        if(self.cardIdTextField.text.length != 0)
        {
            self.creadIdTextField.text = self.cardIdTextField.text;
        }
        
        self.bankView.hidden = YES;
        self.creadBankView.hidden = NO;
        self.creadBankNameTextField.text = [[AppDelegate getAppDelegate] rechargeBankCard];
    }
    else
    {
        if(self.creadHolderTextField.text.length != 0)
        {
            self.cardHolderTextField.text = self.creadHolderTextField.text;
        }
        
        if(self.creadIdTextField.text.length != 0)
        {
            self.cardIdTextField.text = self.creadIdTextField.text;
        }
        
        self.bankView.hidden = NO;
        self.creadBankView.hidden = YES;
        self.bankTextField.text = [[AppDelegate getAppDelegate] rechargeBankCard];
    }
}

- (IBAction)backAction:(id)sender
{
    [[AppDelegate getAppDelegate] setBankType:saveBank];
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

#pragma mark - textField delegate
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if([[AppDelegate getAppDelegate] bankType] == saveBank)
    {
        if(textField == self.cardHolderTextField)
        {
            [self.cardHolderBg setImage:[UIImage imageNamed:@"textfield_active.png"]];
            [self.cardIdBg setImage:[UIImage imageNamed:@"textfield_normal.png"]];
            [self.cardNumberBg setImage:[UIImage imageNamed:@"textfield_normal.png"]];
            [self.telephoneBg setImage:[UIImage imageNamed:@"textfield_normal.png"]];
            [self.checkCodeBg setImage:[UIImage imageNamed:@"textfield_normal.png"]];
        }
        
        if(textField == self.cardIdTextField)
        {
            [self.cardHolderBg setImage:[UIImage imageNamed:@"textfield_normal.png"]];
            [self.cardIdBg setImage:[UIImage imageNamed:@"textfield_active.png"]];
            [self.cardNumberBg setImage:[UIImage imageNamed:@"textfield_normal.png"]];
            [self.telephoneBg setImage:[UIImage imageNamed:@"textfield_normal.png"]];
            [self.checkCodeBg setImage:[UIImage imageNamed:@"textfield_normal.png"]];
        }
        
        if(textField == self.indateTextField)
        {
            [self.cardHolderBg setImage:[UIImage imageNamed:@"textfield_normal.png"]];
            [self.cardIdBg setImage:[UIImage imageNamed:@"textfield_normal.png"]];
            [self.cardNumberBg setImage:[UIImage imageNamed:@"textfield_normal.png"]];
            [self.telephoneBg setImage:[UIImage imageNamed:@"textfield_normal.png"]];
            [self.checkCodeBg setImage:[UIImage imageNamed:@"textfield_normal.png"]];
        }
        
        if(textField == self.cardNumberTextField)
        {
            [self.cardHolderBg setImage:[UIImage imageNamed:@"textfield_normal.png"]];
            [self.cardIdBg setImage:[UIImage imageNamed:@"textfield_normal.png"]];
            [self.cardNumberBg setImage:[UIImage imageNamed:@"textfield_active.png"]];
            [self.telephoneBg setImage:[UIImage imageNamed:@"textfield_normal.png"]];
            [self.checkCodeBg setImage:[UIImage imageNamed:@"textfield_normal.png"]];
        }
        
        if(textField == self.telephoneTextField)
        {
            [self.cardHolderBg setImage:[UIImage imageNamed:@"textfield_normal.png"]];
            [self.cardIdBg setImage:[UIImage imageNamed:@"textfield_normal.png"]];
            [self.cardNumberBg setImage:[UIImage imageNamed:@"textfield_normal.png"]];
            [self.telephoneBg setImage:[UIImage imageNamed:@"textfield_active.png"]];
            [self.checkCodeBg setImage:[UIImage imageNamed:@"textfield_normal.png"]];
            
            [UIView animateWithDuration:0.5f animations:^{
                CGRect frame = self.bankView.frame;
                frame.origin.y = 30;
                self.bankView.frame = frame;
            }];
        }
        
        if(textField == self.checkCodeTextField)
        {
            [self.cardHolderBg setImage:[UIImage imageNamed:@"textfield_normal.png"]];
            [self.cardIdBg setImage:[UIImage imageNamed:@"textfield_normal.png"]];
            [self.cardNumberBg setImage:[UIImage imageNamed:@"textfield_normal.png"]];
            [self.telephoneBg setImage:[UIImage imageNamed:@"textfield_normal.png"]];
            [self.checkCodeBg setImage:[UIImage imageNamed:@"textfield_active.png"]];
            
            [UIView animateWithDuration:0.5f animations:^{
                CGRect frame = self.bankView.frame;
                frame.origin.y = -20;
                self.bankView.frame = frame;
            }];
        }
    }
    else
    {
        if(textField == self.creadHolderTextField)
        {
            [self.creadHolderBg setImage:[UIImage imageNamed:@"textfield_active.png"]];
            [self.creadCardIdBg setImage:[UIImage imageNamed:@"textfield_normal.png"]];
            [self.creadCardNumBg setImage:[UIImage imageNamed:@"textfield_normal.png"]];
            [self.indateBg setImage:[UIImage imageNamed:@"textfield_normal.png"]];
            [self.cvnCodeBg setImage:[UIImage imageNamed:@"textfield_normal.png"]];
            [self.creadTelephoneBg setImage:[UIImage imageNamed:@"textfield_normal.png"]];
            [self.creadCheckCodeBg setImage:[UIImage imageNamed:@"textfield_normal.png"]];
        }
        else if(textField == self.creadIdTextField)
        {
            [self.creadHolderBg setImage:[UIImage imageNamed:@"textfield_normal.png"]];
            [self.creadCardIdBg setImage:[UIImage imageNamed:@"textfield_active.png"]];
            [self.creadCardNumBg setImage:[UIImage imageNamed:@"textfield_normal.png"]];
            [self.indateBg setImage:[UIImage imageNamed:@"textfield_normal.png"]];
            [self.cvnCodeBg setImage:[UIImage imageNamed:@"textfield_normal.png"]];
            [self.creadTelephoneBg setImage:[UIImage imageNamed:@"textfield_normal.png"]];
            [self.creadCheckCodeBg setImage:[UIImage imageNamed:@"textfield_normal.png"]];
        }
        else if(textField == self.creadCardNumTextField)
        {
            [self.creadHolderBg setImage:[UIImage imageNamed:@"textfield_normal.png"]];
            [self.creadCardIdBg setImage:[UIImage imageNamed:@"textfield_normal.png"]];
            [self.creadCardNumBg setImage:[UIImage imageNamed:@"textfield_active.png"]];
            [self.indateBg setImage:[UIImage imageNamed:@"textfield_normal.png"]];
            [self.cvnCodeBg setImage:[UIImage imageNamed:@"textfield_normal.png"]];
            [self.creadTelephoneBg setImage:[UIImage imageNamed:@"textfield_normal.png"]];
            [self.creadCheckCodeBg setImage:[UIImage imageNamed:@"textfield_normal.png"]];
        }
        else if(textField == self.indateTextField)
        {
            [self.creadHolderBg setImage:[UIImage imageNamed:@"textfield_normal.png"]];
            [self.creadCardIdBg setImage:[UIImage imageNamed:@"textfield_normal.png"]];
            [self.creadCardNumBg setImage:[UIImage imageNamed:@"textfield_normal.png"]];
            [self.indateBg setImage:[UIImage imageNamed:@"textfield_active.png"]];
            [self.cvnCodeBg setImage:[UIImage imageNamed:@"textfield_normal.png"]];
            [self.creadTelephoneBg setImage:[UIImage imageNamed:@"textfield_normal.png"]];
            [self.creadCheckCodeBg setImage:[UIImage imageNamed:@"textfield_normal.png"]];
            
            [UIView animateWithDuration:0.5f animations:^{
                CGRect frame = self.creadBankView.frame;
                frame.origin.y = 30;
                self.creadBankView.frame = frame;
            }];
        }
        else if(textField == self.cvnCodeTextField)
        {
            [self.creadHolderBg setImage:[UIImage imageNamed:@"textfield_normal.png"]];
            [self.creadCardIdBg setImage:[UIImage imageNamed:@"textfield_normal.png"]];
            [self.creadCardNumBg setImage:[UIImage imageNamed:@"textfield_normal.png"]];
            [self.indateBg setImage:[UIImage imageNamed:@"textfield_normal.png"]];
            [self.cvnCodeBg setImage:[UIImage imageNamed:@"textfield_active.png"]];
            [self.creadTelephoneBg setImage:[UIImage imageNamed:@"textfield_normal.png"]];
            [self.creadCheckCodeBg setImage:[UIImage imageNamed:@"textfield_normal.png"]];
            
            [UIView animateWithDuration:0.5f animations:^{
                CGRect frame = self.creadBankView.frame;
                frame.origin.y = -20;
                self.creadBankView.frame = frame;
            }];
        }
        else if(textField == self.creadTelephoneTextField)
        {
            [self.creadHolderBg setImage:[UIImage imageNamed:@"textfield_normal.png"]];
            [self.creadCardIdBg setImage:[UIImage imageNamed:@"textfield_normal.png"]];
            [self.creadCardNumBg setImage:[UIImage imageNamed:@"textfield_normal.png"]];
            [self.indateBg setImage:[UIImage imageNamed:@"textfield_normal.png"]];
            [self.cvnCodeBg setImage:[UIImage imageNamed:@"textfield_normal.png"]];
            [self.creadTelephoneBg setImage:[UIImage imageNamed:@"textfield_active.png"]];
            [self.creadCheckCodeBg setImage:[UIImage imageNamed:@"textfield_normal.png"]];
            
            [UIView animateWithDuration:0.5f animations:^{
                CGRect frame = self.creadBankView.frame;
                frame.origin.y = -70;
                self.creadBankView.frame = frame;
            }];
        }
        else if(textField == self.creadCheckCodeTextField)
        {
            [self.creadHolderBg setImage:[UIImage imageNamed:@"textfield_normal.png"]];
            [self.creadCardIdBg setImage:[UIImage imageNamed:@"textfield_normal.png"]];
            [self.creadCardNumBg setImage:[UIImage imageNamed:@"textfield_normal.png"]];
            [self.indateBg setImage:[UIImage imageNamed:@"textfield_normal.png"]];
            [self.cvnCodeBg setImage:[UIImage imageNamed:@"textfield_normal.png"]];
            [self.creadTelephoneBg setImage:[UIImage imageNamed:@"textfield_normal.png"]];
            [self.creadCheckCodeBg setImage:[UIImage imageNamed:@"textfield_active.png"]];
            
            [UIView animateWithDuration:0.5f animations:^{
                CGRect frame = self.creadBankView.frame;
                frame.origin.y = -120;
                self.creadBankView.frame = frame;
            }];
        }
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if([[AppDelegate getAppDelegate] bankType] == saveBank)
    {
        if(textField == self.cardHolderTextField)
        {
            return [self.cardIdTextField becomeFirstResponder];
        }
        
        if(textField == self.cardIdTextField)
        {
            return [self.cardNumberTextField becomeFirstResponder];
        }
        
        if(textField == self.cardNumberTextField)
        {
            return [self.telephoneTextField becomeFirstResponder];
        }
            
        if(textField == self.telephoneTextField)
        {
            return [self.checkCodeTextField becomeFirstResponder];
        }
        
        if(textField == self.checkCodeTextField)
        {
            [self.checkCodeBg setImage:[UIImage imageNamed:@"textfield_normal.png"]];
            [self resumeViewOriginY];
            return [self.checkCodeTextField resignFirstResponder];
        }
    }
    else
    {
        if(textField == self.creadHolderTextField)
        {
            return [self.creadIdTextField becomeFirstResponder];
        }
        
        if(textField == self.creadIdTextField)
        {
            return [self.creadCardNumTextField becomeFirstResponder];
        }
        
        if(textField == self.creadCardNumTextField)
        {
            return [self.indateTextField becomeFirstResponder];
        }
        
        if(textField == self.indateTextField)
        {
            return [self.cvnCodeTextField becomeFirstResponder];
        }
        
        if(textField == self.cvnCodeTextField)
        {
            return [self.creadTelephoneTextField becomeFirstResponder];
        }
            
        if(textField == self.creadTelephoneTextField)
        {
            return [self.creadCheckCodeTextField becomeFirstResponder];
        }
        
        if(textField == self.creadCheckCodeTextField)
        {
            [self.creadCheckCodeBg setImage:[UIImage imageNamed:@"textfield_normal.png"]];
            [self resumeViewOriginY];
            return [self.creadCheckCodeTextField resignFirstResponder];
        }
    }
    
    return [textField resignFirstResponder];
}

//恢复试图y坐标
- (void)resumeViewOriginY
{
    if([[AppDelegate getAppDelegate] bankType] == saveBank)
    {
        [UIView animateWithDuration:0.5f animations:^{
            self.bankView.frame = CGRectMake(0, 80, CGRectGetWidth(self.bankView.frame), CGRectGetHeight(self.bankView.frame));
        }];
    }
    else
    {
        [UIView animateWithDuration:0.5f animations:^{
            self.creadBankView.frame = CGRectMake(0, 80, CGRectGetWidth(self.creadBankView.frame), CGRectGetHeight(self.creadBankView.frame));
        }];
    }
}

- (void)normalTextFieldBg
{
    [self resumeViewOriginY];
    if([[AppDelegate getAppDelegate] bankType] == saveBank)
    {
        [self.cardHolderBg setImage:[UIImage imageNamed:@"textfield_normal.png"]];
        [self.cardIdBg setImage:[UIImage imageNamed:@"textfield_normal.png"]];
        [self.bankBg setImage:[UIImage imageNamed:@"textfield_normal.png"]];
        [self.cardNumberBg setImage:[UIImage imageNamed:@"textfield_normal.png"]];
        [self.telephoneBg setImage:[UIImage imageNamed:@"textfield_normal.png"]];
        [self.checkCodeBg setImage:[UIImage imageNamed:@"textfield_normal.png"]];
        [self.bankView endEditing:YES];

    }
    else
    {
        [self.creadHolderBg setImage:[UIImage imageNamed:@"textfield_normal.png"]];
        [self.creadCardIdBg setImage:[UIImage imageNamed:@"textfield_normal.png"]];
        [self.creadCardNumBg setImage:[UIImage imageNamed:@"textfield_normal.png"]];
        [self.indateBg setImage:[UIImage imageNamed:@"textfield_normal.png"]];
        [self.cvnCodeBg setImage:[UIImage imageNamed:@"textfield_normal.png"]];
        [self.creadTelephoneBg setImage:[UIImage imageNamed:@"textfield_normal.png"]];
        [self.creadCheckCodeBg setImage:[UIImage imageNamed:@"textfield_normal.png"]];
        [self.creadBankView endEditing:YES];
    }
}

//选择银行
- (IBAction)selectBankAction:(id)sender
{
    [self normalTextFieldBg];
    
    SelectBankViewController *selectZone = [[SelectBankViewController alloc] init];
    [self presentViewController:selectZone animated:YES completion:^{
        
    }];
}

//发送验证码
- (IBAction)senderCheckCode:(id)sender
{
    if([[AppDelegate getAppDelegate] bankType] == saveBank)
    {
        if(self.cardHolderTextField.text.length == 0)
        {
            [Utils showMessage:@"请输入持卡人姓名"];
            return;
        }
        else if (self.cardIdTextField.text.length != 18 || ![Utils checkIdentityCardNo:self.cardIdTextField.text])
        {
            [Utils showMessage:@"请输入正确的身份证号"];
            return;
        }
        
        if (self.bankTextField.text.length == 0)
        {
            [Utils showMessage:@"请输入银行名"];
            return;
        }
        else if (self.cardNumberTextField.text.length == 0)
        {
            [Utils showMessage:@"请输入银行卡号"];
            return;
        }
        else if (self.telephoneTextField.text.length == 0 || ![Utils isValidateMobile:self.telephoneTextField.text])
        {
            [Utils showMessage:@"请正确填写预留手机号"];
            return;
        }
    }
    else
    {
        if(self.creadHolderTextField.text.length == 0)
        {
            [Utils showMessage:@"请输入持卡人姓名"];
            return;
        }
        else if (self.creadIdTextField.text.length != 18 || ![Utils checkIdentityCardNo:self.creadIdTextField.text])
        {
            [Utils showMessage:@"请输入正确的身份证号"];
            return;
        }
        else if (self.creadBankNameTextField.text.length == 0)
        {
            [Utils showMessage:@"请输入银行名"];
            return;
        }
        else if (self.creadCardNumTextField.text.length == 0)
        {
            [Utils showMessage:@"请输入银行卡号"];
            return;
        }
        else if(self.indateTextField.text.length != 4)
        {
            [Utils showMessage:@"请正确输入信用卡有效期"];
            return;
        }
        else if(self.cvnCodeTextField.text.length != 3)
        {
            [Utils showMessage:@"请正确输入信用卡CVN码"];
            return;
        }
        else if (self.creadTelephoneTextField.text.length == 0 || ![Utils isValidateMobile:self.creadTelephoneTextField.text])
        {
            [Utils showMessage:@"请正确填写预留手机号"];
            return;
        }
    }
    
    [self normalTextFieldBg];
    [self requestServer];
}

//提交
- (IBAction)doneAction:(id)sender
{
    if([[AppDelegate getAppDelegate] bankType] == saveBank)
    {
        if(self.cardHolderTextField.text.length == 0)
        {
            [Utils showMessage:@"请输入持卡人姓名"];
            return;
        }
        else if (self.cardIdTextField.text.length != 18 || ![Utils checkIdentityCardNo:self.cardIdTextField.text])
        {
            [Utils showMessage:@"请输入正确的身份证号"];
            return;
        }
        
        if (self.bankTextField.text.length == 0)
        {
            [Utils showMessage:@"请输入银行名"];
            return;
        }
        else if (self.cardNumberTextField.text.length == 0)
        {
            [Utils showMessage:@"请输入银行卡号"];
            return;
        }
        else if (self.telephoneTextField.text.length == 0 || ![Utils isValidateMobile:self.telephoneTextField.text])
        {
            [Utils showMessage:@"请正确填写预留手机号"];
            return;
        }
        else if (self.checkCodeTextField.text.length != 6)
        {
            [Utils showMessage:@"请正确填写验证码"];
            return;
        }
        [self normalTextFieldBg];
        [self requestSaveRecharge];
    }
    else
    {
        if(self.creadHolderTextField.text.length == 0)
        {
            [Utils showMessage:@"请输入持卡人姓名"];
            return;
        }
        else if (self.creadIdTextField.text.length != 18 || ![Utils checkIdentityCardNo:self.creadIdTextField.text])
        {
            [Utils showMessage:@"请输入正确的身份证号"];
            return;
        }
        else if (self.creadBankNameTextField.text.length == 0)
        {
            [Utils showMessage:@"请输入银行名"];
            return;
        }
        else if (self.creadCardNumTextField.text.length == 0)
        {
            [Utils showMessage:@"请输入银行卡号"];
            return;
        }
        else if(self.indateTextField.text.length != 4)
        {
            [Utils showMessage:@"请正确输入信用卡有效期"];
            return;
        }
        else if(self.cvnCodeTextField.text.length != 3)
        {
            [Utils showMessage:@"请正确输入信用卡CVN码"];
            return;
        }
        else if (self.creadTelephoneTextField.text.length == 0 || ![Utils isValidateMobile:self.creadTelephoneTextField.text])
        {
            [Utils showMessage:@"请正确填写预留手机号"];
            return;
        }
        else if (self.creadCheckCodeTextField.text.length != 6)
        {
            [Utils showMessage:@"请正确填写验证码"];
            return;
        }
        [self normalTextFieldBg];
        [self requestCreaditRecharge];
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self normalTextFieldBg];
}

#pragma mark - request server
//请求订单号
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
    
    NSLog(@"handInfro request %@",post);
    [self showProgressHUD:@"加载中"];
    
    [self.connection requestConnection:SERVER_URL
                            postParams:post
                            completion:^(NSMutableDictionary *responseDict)
     {
         [self hideProgressHUD];
         NSLog(@"handInfro response %@",responseDict);
         NSDictionary *bodyDic = [responseDict objectForKey:@"body"];
         NSDictionary *oelement = [bodyDic objectForKey:@"oelement"];
         if([[oelement objectForKey:@"errorcode"] isEqualToString:@"0"])
         {
             self.requestOrderId = [oelement objectForKey:@"requestId"];
             if([[AppDelegate getAppDelegate] bankType] == saveBank)
             {
                 [self requestSaveCardCheckCode];
             }
             else
             {
                 [self requestCreditCardCheckCode];
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

//储蓄卡请求验证码
- (void)requestSaveCardCheckCode
{
    NSMutableString *unmd5str = [[NSMutableString alloc] init];
    [unmd5str appendString:TestKey];
    
    NSString *xmlStr = [NSString stringWithFormat:
                        @"<body>"
                        "<elements>"
                        "<element>"
                        "<requestOrderId>%@</requestOrderId>"
                        "<bankCode>%@</bankCode>"
                        "<bankAccount>%@</bankAccount>"
                        "<bankCardType>0</bankCardType>"
                        "<idType>0</idType>"
                        "<idNumber>%@</idNumber>"
                        "<name>%@</name>"
                        "<mobilePhone>%@</mobilePhone>"
                        "<userIdIdentity>%@</userIdIdentity>"
                        "</element>"
                        "</elements>"
                        "</body>",self.requestOrderId,[[AppDelegate getAppDelegate] bankCode],self.cardNumberTextField.text,self.cardIdTextField.text,self.cardHolderTextField.text,self.telephoneTextField.text,[[AppDelegate getAppDelegate] uid]];
    [unmd5str appendString:xmlStr];
    
    NSMutableString *post = [[NSMutableString alloc] init];
    post = [NSMutableString stringWithFormat:
            @"SumaLottery=<?xml version =\"1.0\"encoding=\"UTF-8\"?>"
            "<message version=\"1.0\">"
            "<header>"
            "<transactiontype>15009</transactiontype>"
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
            "<bankAccount>%@</bankAccount>"
            "<bankCardType>0</bankCardType>"
            "<idType>0</idType>"
            "<idNumber>%@</idNumber>"
            "<name>%@</name>"
            "<mobilePhone>%@</mobilePhone>"
            "<userIdIdentity>%@</userIdIdentity>"
            "</element>"
            "</elements>"
            "</body>"
            "</message>",[Utils getcurrenttime],[Utils md5:unmd5str],self.requestOrderId,[[AppDelegate getAppDelegate] bankCode],self.cardNumberTextField.text,self.cardIdTextField.text,self.cardHolderTextField.text,self.telephoneTextField.text,[[AppDelegate getAppDelegate] uid]];
    
    NSLog(@"saveCard checkCode request %@",post);
    [self showProgressHUD:@"加载中"];
    
    [self.connection requestConnection:SERVER_URL
                            postParams:post
                            completion:^(NSMutableDictionary *responseDict)
     {
         [self hideProgressHUD];
         NSLog(@"saveCard checkCode response %@",responseDict);
         NSDictionary *bodyDic = [responseDict objectForKey:@"body"];
         NSDictionary *oelement = [bodyDic objectForKey:@"oelement"];
         if([[oelement objectForKey:@"errorcode"] isEqualToString:@"0"])
         {
             [Utils showMessage:@"短信已发送您手机，请注意查收"];
             self.randomValidateId = [oelement objectForKey:@"randomValidateId"];
             self.tradeId = [oelement objectForKey:@"tradeId"];
             [self.saveCheckCodeBtn setTitle:@"60" forState:UIControlStateNormal];
             [self.saveCheckCodeBtn setBackgroundImage:[UIImage imageNamed:@"yanzhengma_active.png"] forState:UIControlStateNormal];
             timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(countSaveCardTime) userInfo:nil repeats:YES];
             self.saveCheckCodeBtn.userInteractionEnabled = NO;
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

- (void)countSaveCardTime
{
    int count = [self.saveCheckCodeBtn.titleLabel.text intValue];
    count -= 1;
    [self.saveCheckCodeBtn setTitle:[NSString stringWithFormat:@"%d",count] forState:UIControlStateNormal];
    if(count < 0)
    {
        [timer invalidate];
        timer = nil;
        self.saveCheckCodeBtn.userInteractionEnabled = YES;
        [self.saveCheckCodeBtn setTitle:@"" forState:UIControlStateNormal];
        [self.saveCheckCodeBtn setBackgroundImage:[UIImage imageNamed:@"check_code.png"] forState:UIControlStateNormal];
    }
}

//信用卡请求验证码
- (void)requestCreditCardCheckCode
{
    NSMutableString *unmd5str = [[NSMutableString alloc] init];
    [unmd5str appendString:TestKey];
    
    NSString *xmlStr = [NSString stringWithFormat:
                        @"<body>"
                        "<elements>"
                        "<element>"
                        "<requestOrderId>%@</requestOrderId>"
                        "<bankCode>%@</bankCode>"
                        "<bankAccount>%@</bankAccount>"
                        "<bankCardType>1</bankCardType>"
                        "<validDate>%@</validDate>"
                        "<cvnCode>%@</cvnCode>"
                        "<idType>0</idType>"
                        "<idNumber>%@</idNumber>"
                        "<name>%@</name>"
                        "<mobilePhone>%@</mobilePhone>"
                        "<userIdIdentity>%@</userIdIdentity>"
                        "</element>"
                        "</elements>"
                        "</body>",self.requestOrderId,[[AppDelegate getAppDelegate] bankCode],self.creadCardNumTextField.text,self.indateTextField.text,self.cvnCodeTextField.text,self.creadIdTextField.text,self.creadHolderTextField.text,self.creadTelephoneTextField.text,[[AppDelegate getAppDelegate] uid]];
    [unmd5str appendString:xmlStr];
    
    NSMutableString *post = [[NSMutableString alloc] init];
    post = [NSMutableString stringWithFormat:
            @"SumaLottery=<?xml version =\"1.0\"encoding=\"UTF-8\"?>"
            "<message version=\"1.0\">"
            "<header>"
            "<transactiontype>15009</transactiontype>"
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
            "<bankAccount>%@</bankAccount>"
            "<bankCardType>1</bankCardType>"
            "<validDate>%@</validDate>"
            "<cvnCode>%@</cvnCode>"
            "<idType>0</idType>"
            "<idNumber>%@</idNumber>"
            "<name>%@</name>"
            "<mobilePhone>%@</mobilePhone>"
            "<userIdIdentity>%@</userIdIdentity>"
            "</element>"
            "</elements>"
            "</body>"
            "</message>",[Utils getcurrenttime],[Utils md5:unmd5str],self.requestOrderId,[[AppDelegate getAppDelegate] bankCode],self.creadCardNumTextField.text,self.indateTextField.text,self.cvnCodeTextField.text,self.creadIdTextField.text,self.creadHolderTextField.text,self.creadTelephoneTextField.text,[[AppDelegate getAppDelegate] uid]];
    
    NSLog(@"creditCard checkCode request %@",post);
    [self showProgressHUD:@"加载中"];
    
    [self.connection requestConnection:SERVER_URL
                            postParams:post
                            completion:^(NSMutableDictionary *responseDict)
     {
         [self hideProgressHUD];
         NSLog(@"creditCard checkCode response %@",responseDict);
         NSDictionary *bodyDic = [responseDict objectForKey:@"body"];
         NSDictionary *oelement = [bodyDic objectForKey:@"oelement"];
         if([[oelement objectForKey:@"errorcode"] isEqualToString:@"0"])
         {
             [Utils showMessage:@"短信已发送您手机，请注意查收"];
             self.randomValidateId = [oelement objectForKey:@"randomValidateId"];
             self.tradeId = [oelement objectForKey:@"tradeId"];
             [self.creditCheckCodeBtn setTitle:@"60" forState:UIControlStateNormal];
             [self.creditCheckCodeBtn setBackgroundImage:[UIImage imageNamed:@"yanzhengma_active.png"] forState:UIControlStateNormal];
             timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(countCreditCardTime) userInfo:nil repeats:YES];
             self.creditCheckCodeBtn.userInteractionEnabled = NO;
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

- (void)countCreditCardTime
{
    int count = [self.creditCheckCodeBtn.titleLabel.text intValue];
    count -= 1;
    [self.creditCheckCodeBtn setTitle:[NSString stringWithFormat:@"%d",count] forState:UIControlStateNormal];
    if(count < 0)
    {
        [timer invalidate];
        timer = nil;
        self.creditCheckCodeBtn.userInteractionEnabled = YES;
        [self.creditCheckCodeBtn setTitle:@"" forState:UIControlStateNormal];
        [self.creditCheckCodeBtn setBackgroundImage:[UIImage imageNamed:@"check_code.png"] forState:UIControlStateNormal];
    }
}

//提交储存卡充值
- (void)requestSaveRecharge
{
    NSMutableString *unmd5str = [[NSMutableString alloc] init];
    [unmd5str appendString:TestKey];
    
    NSString *xmlStr = [NSString stringWithFormat:
                        @"<body>"
                        "<elements>"
                        "<element>"
                        "<requestOrderId>%@</requestOrderId>"
                        "<bankCode>%@</bankCode>"
                        "<bankAccount>%@</bankAccount>"
                        "<bankCardType>0</bankCardType>"
                        "<idType>0</idType>"
                        "<idNumber>%@</idNumber>"
                        "<name>%@</name>"
                        "<mobilePhone>%@</mobilePhone>"
                        "<isNeedBind>1</isNeedBind>"
                        "<userIdIdentity>%@</userIdIdentity>"
                        "<randomValidateId>%@</randomValidateId>"
                        "<randomCode>%@</randomCode>"
                        "<tradeId>%@</tradeId>"
                        "</element>"
                        "</elements>"
                        "</body>",self.requestOrderId,[[AppDelegate getAppDelegate] bankCode],self.cardNumberTextField.text,self.cardIdTextField.text,self.cardHolderTextField.text,self.telephoneTextField.text,[[AppDelegate getAppDelegate] uid],self.randomValidateId,self.checkCodeTextField.text,self.tradeId];
    [unmd5str appendString:xmlStr];
    
    NSMutableString *post = [[NSMutableString alloc] init];
    post = [NSMutableString stringWithFormat:
            @"SumaLottery=<?xml version =\"1.0\"encoding=\"UTF-8\"?>"
            "<message version=\"1.0\">"
            "<header>"
            "<transactiontype>15007</transactiontype>"
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
            "<bankAccount>%@</bankAccount>"
            "<bankCardType>0</bankCardType>"
            "<idType>0</idType>"
            "<idNumber>%@</idNumber>"
            "<name>%@</name>"
            "<mobilePhone>%@</mobilePhone>"
            "<isNeedBind>1</isNeedBind>"
            "<userIdIdentity>%@</userIdIdentity>"
            "<randomValidateId>%@</randomValidateId>"
            "<randomCode>%@</randomCode>"
            "<tradeId>%@</tradeId>"
            "</element>"
            "</elements>"
            "</body>"
            "</message>",[Utils getcurrenttime],[Utils md5:unmd5str],self.requestOrderId,[[AppDelegate getAppDelegate] bankCode],self.cardNumberTextField.text,self.cardIdTextField.text,self.cardHolderTextField.text,self.telephoneTextField.text,[[AppDelegate getAppDelegate] uid],self.randomValidateId,self.checkCodeTextField.text,self.tradeId];
    
    NSLog(@"handSaveCard request %@",post);
    [self showProgressHUD:@"加载中"];
    
    [self.connection requestConnection:SERVER_URL
                            postParams:post
                            completion:^(NSMutableDictionary *responseDict)
     {
         [self hideProgressHUD];
         NSLog(@"handSaveCard response %@",responseDict);
         NSDictionary *bodyDic = [responseDict objectForKey:@"body"];
         NSDictionary *oelement = [bodyDic objectForKey:@"oelement"];
         if([[oelement objectForKey:@"errorcode"] isEqualToString:@"0"])
         {
             [Utils showMessage:@"充值成功"];
             [[AppDelegate getAppDelegate] setAccountRemaind:[oelement objectForKey:@"money"]];
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

//提交信用卡充值
- (void)requestCreaditRecharge
{
    NSMutableString *unmd5str = [[NSMutableString alloc] init];
    [unmd5str appendString:TestKey];
    
    NSString *xmlStr = [NSString stringWithFormat:
                        @"<body>"
                        "<elements>"
                        "<element>"
                        "<requestOrderId>%@</requestOrderId>"
                        "<bankCode>%@</bankCode>"
                        "<bankAccount>%@</bankAccount>"
                        "<bankCardType>1</bankCardType>"
                        "<validDate>%@</validDate>"
                        "<cvnCode>%@</cvnCode>"
                        "<idType>0</idType>"
                        "<idNumber>%@</idNumber>"
                        "<name>%@</name>"
                        "<mobilePhone>%@</mobilePhone>"
                        "<isNeedBind>1</isNeedBind>"
                        "<userIdIdentity>%@</userIdIdentity>"
                        "<randomValidateId>%@</randomValidateId>"
                        "<randomCode>%@</randomCode>"
                        "<tradeId>%@</tradeId>"
                        "</element>"
                        "</elements>"
                        "</body>",self.requestOrderId,[[AppDelegate getAppDelegate] bankCode],self.creadCardNumTextField.text,self.indateTextField.text,self.cvnCodeTextField.text,self.creadIdTextField.text,self.creadHolderTextField.text,self.creadTelephoneTextField.text,[[AppDelegate getAppDelegate] uid],self.randomValidateId,self.creadCheckCodeTextField.text,self.tradeId];
    [unmd5str appendString:xmlStr];
    
    NSMutableString *post = [[NSMutableString alloc] init];
    post = [NSMutableString stringWithFormat:
            @"SumaLottery=<?xml version =\"1.0\"encoding=\"UTF-8\"?>"
            "<message version=\"1.0\">"
            "<header>"
            "<transactiontype>15007</transactiontype>"
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
            "<bankAccount>%@</bankAccount>"
            "<bankCardType>1</bankCardType>"
            "<validDate>%@</validDate>"
            "<cvnCode>%@</cvnCode>"
            "<idType>0</idType>"
            "<idNumber>%@</idNumber>"
            "<name>%@</name>"
            "<mobilePhone>%@</mobilePhone>"
            "<isNeedBind>1</isNeedBind>"
            "<userIdIdentity>%@</userIdIdentity>"
            "<randomValidateId>%@</randomValidateId>"
            "<randomCode>%@</randomCode>"
            "<tradeId>%@</tradeId>"
            "</element>"
            "</elements>"
            "</body>"
            "</message>",[Utils getcurrenttime],[Utils md5:unmd5str],self.requestOrderId,[[AppDelegate getAppDelegate] bankCode],self.creadCardNumTextField.text,self.indateTextField.text,self.cvnCodeTextField.text,self.creadIdTextField.text,self.creadHolderTextField.text,self.creadTelephoneTextField.text,[[AppDelegate getAppDelegate] uid],self.randomValidateId,self.creadCheckCodeTextField.text,self.tradeId];
    
    NSLog(@"handCreaditCard request %@",post);
    [self showProgressHUD:@"加载中"];
    
    [self.connection requestConnection:SERVER_URL
                            postParams:post
                            completion:^(NSMutableDictionary *responseDict)
     {
         [self hideProgressHUD];
         NSLog(@"handCreaditCard response %@",responseDict);
         NSDictionary *bodyDic = [responseDict objectForKey:@"body"];
         NSDictionary *oelement = [bodyDic objectForKey:@"oelement"];
         if([[oelement objectForKey:@"errorcode"] isEqualToString:@"0"])
         {
             [Utils showMessage:@"充值成功"];
             [[AppDelegate getAppDelegate] setAccountRemaind:[oelement objectForKey:@"money"]];
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
