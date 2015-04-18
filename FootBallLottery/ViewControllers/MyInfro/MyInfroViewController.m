//
//  MyInfroViewController.m
//  FootBallLottery
//
//  Created by jaye on 15/1/2.
//  Copyright (c) 2015年 jaye. All rights reserved.
//

#import "MyInfroViewController.h"

@interface MyInfroViewController ()

@end

@implementation MyInfroViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupMenuBarButtonItems];
    if([[AppDelegate getAppDelegate] isUserInfro])
    {
        [self initData];
    }
    else
    {
        [self requestUserfro];
    }
}

- (void)initData
{
    //身份信息
    self.handInInfo.frame = CGRectMake(0, 110, kWindowWidth, kWindowHeight - 110);
    self.handInInfo.hidden = NO;
    [self.view addSubview:self.handInInfo];
    
    //显示身份信息
    self.showInfroView.frame = CGRectMake(0, 110, kWindowWidth, kWindowHeight - 110);
    self.showInfroView.hidden = YES;
    [self.view addSubview:self.showInfroView];
    
    //提取银行卡信息
    self.bankView.frame = CGRectMake(0, 110, kWindowWidth, kWindowHeight - 110);
    [self.view addSubview:self.bankView];
    self.bankView.hidden = YES;
    
    //显示银行卡信息
    self.showBankView.frame = CGRectMake(10, 130, kWindowWidth - 10, 50);
    self.showBankView.hidden = YES;
    [self.view addSubview:self.showBankView];
    
    self.headView.frame = CGRectMake(0, 60, CGRectGetWidth(self.headView.frame), CGRectGetHeight(self.headView.frame));
    [self.view addSubview:self.headView];
    
    if([[AppDelegate getAppDelegate] isHandInFro])
    {
        self.handInInfo.hidden = YES;
        self.showInfroView.hidden = NO;
        
        self.userNameLabel.text =  [[AppDelegate getAppDelegate] userName];
        NSString *cardId = [[AppDelegate getAppDelegate] cardId];
        NSString *str = [cardId substringWithRange:NSMakeRange(6, cardId.length - 10)];
        self.IDLabel.text = [cardId stringByReplacingOccurrencesOfString:str withString:@"********"];
        NSString *realName = [[AppDelegate getAppDelegate] realName];
        NSString *realNameStr = [realName substringFromIndex:1];
        NSString *xing = [[NSString alloc] init];
        for(int i = 0;i < realNameStr.length;i++)
        {
            xing = [xing stringByAppendingString:@"*"];
        }
        self.realNameLabel.text =  [realName stringByReplacingOccurrencesOfString:realNameStr withString:xing];
        NSString *telephone = [[AppDelegate getAppDelegate] telePhone];
        NSString *telephoneStr = [telephone substringWithRange:NSMakeRange(3, telephone.length - 7)];
        self.telephoneLabel.text = [telephone stringByReplacingOccurrencesOfString:telephoneStr withString:@"*****"];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void) keyboardWillHide:(NSNotification *) notification
{
    [self.handInInfo endEditing:YES];
    [self.bankView endEditing:YES];
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
    label.text = @"个人资料";
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

//返回
- (void)backButtonPressed:(id)sender
{
    [[AppDelegate getAppDelegate] setIsSlider:YES];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [self.navigationController popToRootViewControllerAnimated:YES];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"back" object:nil];
}

//切换个人信息/银行信息试图
- (IBAction)btnActionClick:(UIButton *)sender
{
    if(sender.tag == 10)            //切换到个人信息
    {
        if([[AppDelegate getAppDelegate] isHandInFro])
        {
            self.handInInfo.hidden = YES;
            self.showInfroView.hidden = NO;
            
            self.userNameLabel.text =  [[AppDelegate getAppDelegate] userName];
            NSString *cardId = [[AppDelegate getAppDelegate] cardId];
            NSString *str = [cardId substringWithRange:NSMakeRange(6, cardId.length - 10)];
            self.IDLabel.text = [cardId stringByReplacingOccurrencesOfString:str withString:@"********"];
            NSString *realName = [[AppDelegate getAppDelegate] realName];
            NSString *realNameStr = [realName substringFromIndex:1];
            NSString *xing = [[NSString alloc] init];
            for(int i = 0;i < realNameStr.length;i++)
            {
                xing = [xing stringByAppendingString:@"*"];
            }
            self.realNameLabel.text =  [realName stringByReplacingOccurrencesOfString:realNameStr withString:xing];
            NSString *telephone = [[AppDelegate getAppDelegate] telePhone];
            NSString *telephoneStr = [telephone substringWithRange:NSMakeRange(3, telephone.length - 7)];
            self.telephoneLabel.text = [telephone stringByReplacingOccurrencesOfString:telephoneStr withString:@"*****"];
        }
        else
        {
            self.showInfroView.hidden = YES;
            self.handInInfo.hidden = NO;
        }
        
        self.showBankView.hidden = YES;
        self.bankView.hidden = YES;
        [self.bankView endEditing:YES];
        self.backGroundImage.image = [UIImage imageNamed:@"tab_shenfen.png"];
        [self.cardHolderBg setImage:[UIImage imageNamed:@"textfield_normal.png"]];
        [self.identifyCardBg setImage:[UIImage imageNamed:@"textfield_normal.png"]];
        [self.bankBg setImage:[UIImage imageNamed:@"textfield_normal.png"]];
        [self.cardNumBg setImage:[UIImage imageNamed:@"textfield_normal.png"]];
        [self.accountZoneBg setImage:[UIImage imageNamed:@"textfield_normal.png"]];
        [self.passwordBg setImage:[UIImage imageNamed:@"textfield_normal.png"]];
    }
    else if (sender.tag == 11)      //切换到银行信息
    {
        if([[AppDelegate getAppDelegate] isHandBankFro])
        {
            self.bankView.hidden = YES;
            self.showBankView.hidden = NO;
            self.bankName.text = [[AppDelegate getAppDelegate] bankName];
            NSString *bankCard = [[AppDelegate getAppDelegate] bankCard];
            self.bankCard.text = [NSString stringWithFormat:@"尾号为  %@",[bankCard substringWithRange:NSMakeRange(bankCard.length - 4, 4)]];
        }
        else if([[AppDelegate getAppDelegate] isHandInFro])
        {
            self.bankView.hidden = NO;
            self.showBankView.hidden = YES;
            self.cardholderTextField.text = self.realNameLabel.text;
            self.identityCardTextField.text = self.IDLabel.text;
        }
        else
        {
            self.bankView.hidden = NO;
            self.showBankView.hidden = YES;
        }
        
        self.handInInfo.hidden = YES;
        self.showInfroView.hidden = YES;
        [self.handInInfo endEditing:YES];
        self.backGroundImage.image = [UIImage imageNamed:@"tab_yinhangka.png"];
        [self.IDBg setImage:[UIImage imageNamed:@"textfield_normal.png"]];
        [self.realNameBg setImage:[UIImage imageNamed:@"textfield_normal.png"]];
    }
}

#pragma mark - textField delegate
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if(textField == self.IDTextField)
    {
        [self.IDBg setImage:[UIImage imageNamed:@"textfield_active.png"]];
        [self.realNameBg setImage:[UIImage imageNamed:@"textfield_normal.png"]];
    }
    
    if(textField == self.realName)
    {
        [self.IDBg setImage:[UIImage imageNamed:@"textfield_normal.png"]];
        [self.realNameBg setImage:[UIImage imageNamed:@"textfield_active.png"]];
    }
    
    if(![[AppDelegate getAppDelegate] isHandInFro])
    {
        if(textField == self.cardholderTextField)
        {
            [self.cardHolderBg setImage:[UIImage imageNamed:@"textfield_active.png"]];
            [self.identifyCardBg setImage:[UIImage imageNamed:@"textfield_normal.png"]];
            [self.bankBg setImage:[UIImage imageNamed:@"textfield_normal.png"]];
            [self.cardNumBg setImage:[UIImage imageNamed:@"textfield_normal.png"]];
            [self.accountZoneBg setImage:[UIImage imageNamed:@"textfield_normal.png"]];
            [self.passwordBg setImage:[UIImage imageNamed:@"textfield_normal.png"]];
        }
        
        if(textField == self.identityCardTextField)
        {
            [self.cardHolderBg setImage:[UIImage imageNamed:@"textfield_normal.png"]];
            [self.identifyCardBg setImage:[UIImage imageNamed:@"textfield_active.png"]];
            [self.bankBg setImage:[UIImage imageNamed:@"textfield_normal.png"]];
            [self.cardNumBg setImage:[UIImage imageNamed:@"textfield_normal.png"]];
            [self.accountZoneBg setImage:[UIImage imageNamed:@"textfield_normal.png"]];
            [self.passwordBg setImage:[UIImage imageNamed:@"textfield_normal.png"]];
        }
    }
    
    if(textField == self.bankTextField)
    {
        [self.cardHolderBg setImage:[UIImage imageNamed:@"textfield_normal.png"]];
        [self.identifyCardBg setImage:[UIImage imageNamed:@"textfield_normal.png"]];
        [self.bankBg setImage:[UIImage imageNamed:@"textfield_active.png"]];
        [self.cardNumBg setImage:[UIImage imageNamed:@"textfield_normal.png"]];
        [self.accountZoneBg setImage:[UIImage imageNamed:@"textfield_normal.png"]];
        [self.passwordBg setImage:[UIImage imageNamed:@"textfield_normal.png"]];
    }
    
    if(textField == self.cardNumberTextField)
    {
        [self.cardHolderBg setImage:[UIImage imageNamed:@"textfield_normal.png"]];
        [self.identifyCardBg setImage:[UIImage imageNamed:@"textfield_normal.png"]];
        [self.bankBg setImage:[UIImage imageNamed:@"textfield_normal.png"]];
        [self.cardNumBg setImage:[UIImage imageNamed:@"textfield_active.png"]];
        [self.accountZoneBg setImage:[UIImage imageNamed:@"textfield_normal.png"]];
        [self.passwordBg setImage:[UIImage imageNamed:@"textfield_normal.png"]];
        
        [UIView animateWithDuration:0.5f animations:^{
            CGRect frame = self.bankView.frame;
            frame.origin.y = 60;
            self.bankView.frame = frame;
        }];
    }
    
    if(textField == self.accountZoneTextField)
    {
        [self.cardHolderBg setImage:[UIImage imageNamed:@"textfield_normal.png"]];
        [self.identifyCardBg setImage:[UIImage imageNamed:@"textfield_normal.png"]];
        [self.bankBg setImage:[UIImage imageNamed:@"textfield_normal.png"]];
        [self.cardNumBg setImage:[UIImage imageNamed:@"textfield_normal.png"]];
        [self.accountZoneBg setImage:[UIImage imageNamed:@"textfield_active.png"]];
        [self.passwordBg setImage:[UIImage imageNamed:@"textfield_normal.png"]];
        
        [UIView animateWithDuration:0.5f animations:^{
            CGRect frame = self.bankView.frame;
            frame.origin.y = 10;
            self.bankView.frame = frame;
        }];
    }
    
    if(textField == self.passWordTextField)
    {
        [self.cardHolderBg setImage:[UIImage imageNamed:@"textfield_normal.png"]];
        [self.identifyCardBg setImage:[UIImage imageNamed:@"textfield_normal.png"]];
        [self.bankBg setImage:[UIImage imageNamed:@"textfield_normal.png"]];
        [self.cardNumBg setImage:[UIImage imageNamed:@"textfield_normal.png"]];
        [self.accountZoneBg setImage:[UIImage imageNamed:@"textfield_normal.png"]];
        [self.passwordBg setImage:[UIImage imageNamed:@"textfield_active.png"]];
        
        [UIView animateWithDuration:0.5f animations:^{
            CGRect frame = self.bankView.frame;
            frame.origin.y = -40;
            self.bankView.frame = frame;
        }];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    //身份信息
    if (textField == self.IDTextField)
    {
        return [self.realName becomeFirstResponder];
    }
    if (textField == self.realName)
    {
        [self.realNameBg setImage:[UIImage imageNamed:@"textfield_normal.png"]];
        return [self.realName resignFirstResponder];
    }

    //提款银行卡
    if(textField == self.cardholderTextField)
    {
        return [self.identityCardTextField becomeFirstResponder];
    }
    if (textField == self.identityCardTextField)
    {
        return [self.bankTextField becomeFirstResponder];
    }
    if (textField == self.bankTextField)
    {
        return [self.cardNumberTextField becomeFirstResponder];
    }
    if (textField == self.cardNumberTextField)
    {
        return [self.accountZoneTextField becomeFirstResponder];
    }
    if (textField == self.accountZoneTextField)
    {
        return [self.passWordTextField becomeFirstResponder];
    }
    if(textField == self.passWordTextField)
    {
        [self resumeViewOriginY];
        [self.passwordBg setImage:[UIImage imageNamed:@"textfield_normal.png"]];
        return [self.passWordTextField resignFirstResponder];
    }
    
    return [textField resignFirstResponder];
}

//恢复试图y坐标
- (void)resumeViewOriginY
{
    [UIView animateWithDuration:0.5f animations:^{
        self.bankView.frame = CGRectMake(0, 110, CGRectGetWidth(self.bankView.frame), CGRectGetHeight(self.bankView.frame));
    }];
}

//提交个人信息
- (IBAction)doneInfroActionClick:(id)sender
{
    if (self.IDTextField.text.length != 18 || ![Utils checkIdentityCardNo:self.IDTextField.text])
    {
        [Utils showMessage:@"请输入正确的身份证号"];
        return;
    }
    else if (self.realName.text.length == 0)
    {
        [Utils showMessage:@"请输入真实姓名"];
        return;
    }
    [self.handInInfo endEditing:YES];
    [self handInUserFro];
}


//提交银行卡信息
- (IBAction)doneBankInfroActionClick:(id)sender
{
    if(![[AppDelegate getAppDelegate] isHandInFro])
    {
        if(self.cardholderTextField.text.length == 0)
        {
            [Utils showMessage:@"请输入持卡人姓名"];
            return;
        }
        else if (self.identityCardTextField.text.length != 18 || ![Utils checkIdentityCardNo:self.identityCardTextField.text])
        {
            [Utils showMessage:@"请输入正确的身份证号"];
            return;
        }
    }
    else
    {
        self.cardholderTextField.text = [[AppDelegate getAppDelegate] realName];
        self.cardNumberTextField.text = [[AppDelegate getAppDelegate] cardId];
    }
    
    if (self.bankTextField.text.length == 0)
    {
        [Utils showMessage:@"请输入银行名"];
        return;
    }
    else if (self.accountZoneTextField.text.length == 0)
    {
        [Utils showMessage:@"请输入开户地"];
        return;
    }
    else if (self.passWordTextField.text.length == 0)
    {
        [Utils showMessage:@"请输入正确的密码"];
        return;
    }
    [self.bankView endEditing:YES];
    [self handInBankInfo];
}

//选择银行
- (IBAction)selectBankActionClick:(id)sender
{
    SelectBankViewController *selectBank = [[SelectBankViewController alloc] init];
    [self.navigationController pushViewController:selectBank animated:YES];
}

//选择开户行
- (IBAction)selectAccountZoneActionClick:(id)sender
{
    SelectZoneViewController *selectZone = [[SelectZoneViewController alloc] init];
    [self.navigationController pushViewController:selectZone animated:YES];
}

#pragma mark - view touch
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.handInInfo endEditing:YES];
    [self.IDBg setImage:[UIImage imageNamed:@"textfield_normal.png"]];
    [self.realNameBg setImage:[UIImage imageNamed:@"textfield_normal.png"]];
    [self.bankView endEditing:YES];
    [self.cardHolderBg setImage:[UIImage imageNamed:@"textfield_normal.png"]];
    [self.identifyCardBg setImage:[UIImage imageNamed:@"textfield_normal.png"]];
    [self.bankBg setImage:[UIImage imageNamed:@"textfield_normal.png"]];
    [self.cardNumBg setImage:[UIImage imageNamed:@"textfield_normal.png"]];
    [self.accountZoneBg setImage:[UIImage imageNamed:@"textfield_normal.png"]];
    [self.passwordBg setImage:[UIImage imageNamed:@"textfield_normal.png"]];
    [self resumeViewOriginY];
}

#pragma mark - request server
//请求用户信息
- (void)requestUserfro
{
    NSMutableString *unmd5str = [[NSMutableString alloc] init];
    [unmd5str appendString:TestKey];
    
    NSString *xmlStr = [NSString stringWithFormat:
                        @"<body>"
                        "<elements>"
                        "<element>"
                        "<uid>%@</uid>"
                        "</element>"
                        "</elements>"
                        "</body>",[[AppDelegate getAppDelegate] uid]];
    [unmd5str appendString:xmlStr];
    
    NSMutableString *post = [[NSMutableString alloc] init];
    post = [NSMutableString stringWithFormat:
            @"SumaLottery=<?xml version =\"1.0\"encoding=\"UTF-8\"?>"
            "<message version=\"1.0\">"
            "<header>"
            "<transactiontype>20001_1.1</transactiontype>"
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
            "</element>"
            "</elements>"
            "</body>"
            "</message>",
            [Utils getcurrenttime],[Utils md5:unmd5str],[[AppDelegate getAppDelegate] uid]];
    
    NSLog(@"infro request %@",post);
    [self.connection requestConnection:SERVER_URL
                            postParams:post
                            completion:^(NSMutableDictionary *responseDict)
     {
         [self hideProgressHUD];
         NSLog(@"infro responsedict %@",responseDict);
         NSDictionary *bodyDic = [responseDict objectForKey:@"body"];
         NSDictionary *oelement = [bodyDic objectForKey:@"oelement"];
         NSDictionary *elements = [bodyDic objectForKey:@"elements"];
         
         if([[oelement objectForKey:@"errorcode"] intValue] == 0)
         {
             NSString *realName = [elements objectForKey:@"realname"];
             NSString *cardid = [elements objectForKey:@"cardid"];
             if([elements.allKeys containsObject:@"realname"] && [elements.allKeys containsObject:@"cardid"] && [elements.allKeys containsObject:@"account"])
             {
                 if(realName && ![realName isEqualToString:@"*"] && ![cardid isEqualToString:@"*"])
                 {
                     [[AppDelegate getAppDelegate] setRealName:realName];
                     [[AppDelegate getAppDelegate] setCardId:cardid];
                     [[AppDelegate getAppDelegate] setIsHandInFro:YES];
                 }
                 else
                 {
                     [[AppDelegate getAppDelegate] setRealName:@""];
                     [[AppDelegate getAppDelegate] setCardId:@""];
                     [[AppDelegate getAppDelegate] setIsHandInFro:NO];
                 }
             }
             else
             {
                 [[AppDelegate getAppDelegate] setRealName:@""];
                 [[AppDelegate getAppDelegate] setCardId:@""];
                 [[AppDelegate getAppDelegate] setIsHandInFro:NO];
             }
             
             NSString *bankaccount = [elements objectForKey:@"bankaccount"];
             NSString *bankname =    [elements objectForKey:@"bankname"];
             NSString *bankAddress = [elements objectForKey:@"bankaddress"];
             if([elements.allKeys containsObject:@"bankaccount"] && [elements.allKeys containsObject:@"bankname"])
             {
                 if(![bankaccount isEqualToString:@"*"] && ![bankname isEqualToString:@"*"])
                 {
                     [[AppDelegate getAppDelegate] setBankName:bankname];
                     [[AppDelegate getAppDelegate] setBankCard:bankaccount];
                     [[AppDelegate getAppDelegate] setBankAddress:bankAddress];
                     [[AppDelegate getAppDelegate] setIsHandBankFro:YES];
                 }
                 else
                 {
                     [[AppDelegate getAppDelegate] setBankName:@""];
                     [[AppDelegate getAppDelegate] setBankCard:@""];
                     [[AppDelegate getAppDelegate] setBankAddress:@""];
                     [[AppDelegate getAppDelegate] setIsHandBankFro:NO];
                 }
             }
             else
             {
                 [[AppDelegate getAppDelegate] setBankName:@""];
                 [[AppDelegate getAppDelegate] setBankCard:@""];
                 [[AppDelegate getAppDelegate] setBankAddress:@""];
                 [[AppDelegate getAppDelegate] setIsHandBankFro:NO];
             }
             
             [self initData];
         }
         else
         {
             [Utils showMessage:[oelement objectForKey:@"errormessage"]];
         }
     }
     failed:^(NSString *failedMessage)
     {
         NSLog(@"infro request fail!");
     }];
}

//提交用户信息
- (void)handInUserFro
{
    NSMutableString *unmd5str = [[NSMutableString alloc] init];
    [unmd5str appendString:TestKey];
    
    NSString *xmlStr = [NSString stringWithFormat:
                        @"<body>"
                        "<elements>"
                        "<element drawaltype=\"0\">"
                        "<uid>%@</uid>"
                        "<realname>%@</realname>"
                        "<cardid>%@</cardid>"
                        "</element>"
                        "</elements>"
                        "</body>",[[AppDelegate getAppDelegate] uid],self.realName.text,self.IDTextField.text];
    [unmd5str appendString:xmlStr];
    
    NSMutableString *post = [[NSMutableString alloc] init];
    post = [NSMutableString stringWithFormat:
            @"SumaLottery=<?xml version =\"1.0\"encoding=\"UTF-8\"?>"
            "<message version=\"1.0\">"
            "<header>"
            "<transactiontype>10002_1.1</transactiontype>"
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
            "<realname>%@</realname>"
            "<cardid>%@</cardid>"
            "</element>"
            "</elements>"
            "</body>"
            "</message>",[Utils getcurrenttime],[Utils md5:unmd5str],[[AppDelegate getAppDelegate] uid],self.realName.text,self.IDTextField.text];
    
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
         NSDictionary *element = [bodyDic objectForKey:@"element"];
         if([[oelement objectForKey:@"errorcode"] isEqualToString:@"0"])
         {
             self.handInInfo.hidden = YES;
             self.showInfroView.hidden = NO;
             
             [[AppDelegate getAppDelegate] setIsHandInFro:YES];
             [[AppDelegate getAppDelegate] setRealName:[element objectForKey:@"realname"]];
             [[AppDelegate getAppDelegate] setCardId:[element objectForKey:@"cardid"]];
             
             self.userNameLabel.text =  [[AppDelegate getAppDelegate] userName];
             NSString *cardId = [[AppDelegate getAppDelegate] cardId];
             NSString *str = [cardId substringWithRange:NSMakeRange(6, cardId.length - 10)];
             self.IDLabel.text = [cardId stringByReplacingOccurrencesOfString:str withString:@"********"];
             NSString *realName = [[AppDelegate getAppDelegate] realName];
             NSString *realNameStr = [realName substringFromIndex:1];
             NSString *xing = [[NSString alloc] init];
             for(int i = 0;i < realNameStr.length;i++)
             {
                 xing = [xing stringByAppendingString:@"*"];
             }
             self.realNameLabel.text =  [realName stringByReplacingOccurrencesOfString:realNameStr withString:xing];
             NSString *telephone = [[AppDelegate getAppDelegate] telePhone];
             NSString *telephoneStr = [telephone substringWithRange:NSMakeRange(3, telephone.length - 7)];
             self.telephoneLabel.text = [telephone stringByReplacingOccurrencesOfString:telephoneStr withString:@"*****"];
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

//提交提款银行卡信息
- (void)handInBankInfo
{
    NSMutableString *unmd5str = [[NSMutableString alloc] init];
    [unmd5str appendString:TestKey];
    
    NSString *xmlStr = [NSString stringWithFormat:
                        @"<body>"
                        "<elements>"
                        "<element drawaltype=\"0\">"
                        "<uid>%@</uid>"
                        "<phone></phone>"
                        "<bankname>%@</bankname>"
                        "<bankcardid>%@</bankcardid>"
                        "<bankaddress>%@</bankaddress>"
                        "<actpassword>%@</actpassword>"
                        "</element>"
                        "</elements>"
                        "</body>",[[AppDelegate getAppDelegate] uid],self.bankTextField.text,self.cardNumberTextField.text,self.accountZoneTextField.text,[Utils MD5Password:self.passWordTextField.text]];
    [unmd5str appendString:xmlStr];
    
    NSMutableString *post = [[NSMutableString alloc] init];
    post = [NSMutableString stringWithFormat:
            @"SumaLottery=<?xml version =\"1.0\"encoding=\"UTF-8\"?>"
            "<message version=\"1.0\">"
            "<header>"
            "<transactiontype>10002_1.1</transactiontype>"
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
            "<phone></phone>"
            "<bankname>%@</bankname>"
            "<bankcardid>%@</bankcardid>"
            "<bankaddress>%@</bankaddress>"
            "<actpassword>%@</actpassword>"
            "</element>"
            "</elements>"
            "</body>"
            "</message>",
            [Utils getcurrenttime],[Utils md5:unmd5str],[[AppDelegate getAppDelegate] uid],self.bankTextField.text,self.cardNumberTextField.text,self.accountZoneTextField.text,[Utils MD5Password:self.passWordTextField.text]];
    
    NSLog(@"hand bank request %@",post);
    [self showProgressHUD:@"加载中"];
    
    [self.connection requestConnection:SERVER_URL
                            postParams:post
                            completion:^(NSMutableDictionary *responseDict)
     {
         [self hideProgressHUD];
         NSLog(@"hand bank responseDict %@",responseDict);
         NSDictionary *bodyDic = [responseDict objectForKey:@"body"];
         NSDictionary *oelement = [bodyDic objectForKey:@"oelement"];
         NSDictionary *element = [bodyDic objectForKey:@"element"];
         if([[oelement objectForKey:@"errorcode"] intValue] == 0)
         {
             self.bankView.hidden = YES;
             self.showBankView.hidden = NO;
             
             [[AppDelegate getAppDelegate] setBankAddress:[element objectForKey:@"bankaddress"]];
             [[AppDelegate getAppDelegate] setBankName:[element objectForKey:@"bankname"]];
             [[AppDelegate getAppDelegate] setBankCard:[element objectForKey:@"cardid"]];
    
             self.bankName.text = [[AppDelegate getAppDelegate] bankName];
             NSString *bankCard = [[AppDelegate getAppDelegate] bankCard];
             self.bankCard.text = [NSString stringWithFormat:@"尾号为  %@",[bankCard substringWithRange:NSMakeRange(bankCard.length - 4, 4)]];
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
