//
//  LeftViewController.m
//  FootBallLottery
//
//  Created by jaye on 15/1/2.
//  Copyright (c) 2015年 jaye. All rights reserved.
//

#import "LeftViewController.h"

@interface LeftViewController ()

@end

@implementation LeftViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
     self.loginView.frame = CGRectMake(0, 50, CGRectGetWidth(self.loginView.frame), CGRectGetHeight(self.loginView.frame));
    [self.view addSubview:self.loginView];
    self.loginView.hidden = NO;
    
    self.showInfroView.frame = CGRectMake(0, 0, CGRectGetWidth(self.showInfroView.frame),CGRectGetHeight(self.showInfroView.frame));
    self.showInfroView.hidden = YES;
    [self.view addSubview:self.showInfroView];
    self.exitBtn.frame = CGRectMake(20, kWindowHeight - CGRectGetHeight(self.exitBtn.frame) - 30, CGRectGetWidth(self.exitBtn.frame),CGRectGetHeight(self.exitBtn.frame));
    self.exitBtn.hidden = YES;
    [self.view addSubview:self.exitBtn];
    
    [self initView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reLogin) name:@"changePassword" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reAccountMoney) name:@"recharegeSuccess" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(voteSuccessRefresh) name:@"voteSuccessRefresh" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(leftClosed) name:@"viewControllerClosed" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(autoLogin) name:@"autoLogin" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(recharge) name:@"recharge" object:nil];
}

//充值
- (void)recharge
{
    [[AppDelegate getAppDelegate] setIsSlider:NO];
    RechargeMoneyViewController *rechargeMoney = [[RechargeMoneyViewController alloc] initWithNibName:@"RechargeMoneyViewController" bundle:nil];
    [self.sideMenu.navigationController pushViewController:rechargeMoney animated:NO];
    self.sideMenu.menuState = MFSideMenuStateClosed;
}

//自动登录
- (void)autoLogin
{
    if(![[AppDelegate getAppDelegate] isResigter])
    {
        if([[[NSUserDefaults standardUserDefaults] objectForKey:@"IsExit"] isEqualToString:@"0"])
        {
            return;
        }
        
        [[NSUserDefaults standardUserDefaults] setValue:self.userNameTextField.text forKey:@"userName"];
        [[NSUserDefaults standardUserDefaults] setValue:self.passWordTextField.text forKey:@"password"];
        [[AppDelegate getAppDelegate] setUserName:[[NSUserDefaults standardUserDefaults] objectForKey:@"userName"]];
        [[AppDelegate getAppDelegate] setUserPassword:[[NSUserDefaults standardUserDefaults] objectForKey:@"password"]];
    }
    
    [[AppDelegate getAppDelegate] setIsResigter:NO];
    
    if([[AppDelegate getAppDelegate] userName].length == 0 && [[AppDelegate getAppDelegate] userPassword].length == 0)
    {
        return;
    }
    
    NSMutableString *unmd5str = [[NSMutableString alloc] init];
    [unmd5str appendString:TestKey];
    
    NSString *xmlStr = [NSString stringWithFormat:
                        @"<body>"
                        "<elements>"
                        "<element>"
                        "<username>%@</username>"
                        "<actpassword>%@</actpassword>"
                        "</element>"
                        "</elements>"
                        "</body>",[[AppDelegate getAppDelegate] userName],[[AppDelegate getAppDelegate] userPassword]];
    [unmd5str appendString:xmlStr];
    
    NSMutableString *post = [[NSMutableString alloc] init];
    post = [NSMutableString stringWithFormat:
            @"SumaLottery=<?xml version =\"1.0\"encoding=\"UTF-8\"?>"
            "<message version=\"1.0\">"
            "<header>"
            "<transactiontype>10008_1.1</transactiontype>"
            "<timestamp>%@</timestamp>"
            "<digest>%@</digest>"
            "<agenterid>10000002</agenterid>"
            "<ipaddress></ipaddress>"
            "<source>WEB</source>"
            "</header>"
            "<body>"
            "<elements>"
            "<element>"
            "<username>%@</username>"
            "<actpassword>%@</actpassword>"
            "</element>"
            "</elements>"
            "</body>"
            "</message>",
            [Utils getcurrenttime],[Utils md5:unmd5str],[[AppDelegate getAppDelegate] userName],[[AppDelegate getAppDelegate] userPassword]];
    
    NSLog(@"login request %@",post);
    [self showProgressHUD:@"加载中"];
    
    [self.connection requestConnection:SERVER_URL
                            postParams:post
                            completion:^(NSMutableDictionary *responseDict)
     {
         [self hideProgressHUD];
         NSLog(@"login responestdict %@",responseDict);
         NSDictionary *bodyDic = [responseDict objectForKey:@"body"];
         NSDictionary *element = [bodyDic objectForKey:@"element"];
         NSDictionary *oelement = [bodyDic objectForKey:@"oelement"];
         if([[oelement objectForKey:@"errorcode"] intValue] == 0)
         {
             if(isSavePassword)
             {
                 [[NSUserDefaults standardUserDefaults] setValue:self.userNameTextField.text forKey:@"userName"];
                 [[NSUserDefaults standardUserDefaults] setValue:self.passWordTextField.text forKey:@"password"];
             }
             
//             [Utils showMessage:@"登陆成功"];
             
             self.userName.text = [element objectForKey:@"username"];
             self.money.text = [element objectForKey:@"money"];
             
             [[AppDelegate getAppDelegate] setUid:[element objectForKey:@"uid"]];
             [[AppDelegate getAppDelegate] setUserName:self.userName.text];
             //             [[AppDelegate getAppDelegate] setTelePhone:self.userNameTextField.text];
             [[AppDelegate getAppDelegate] setIsLogin:YES];
             [[AppDelegate getAppDelegate] setAccountRemaind:self.money.text];
             [[AppDelegate getAppDelegate] setUserPassword:self.passWordTextField.text];
             
             [self.loginView setHidden:YES];
             [self.showInfroView setHidden:NO];
             [self.exitBtn setHidden:NO];
             [self requestUserfro];
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

- (void)leftClosed
{
    [self.userNameTextBg setImage:[UIImage imageNamed:@"field_normal.png"]];
    [self.userNameTextField resignFirstResponder];
    [self.passwordBg setImage:[UIImage imageNamed:@"field_normal.png"]];
    [self.passWordTextField resignFirstResponder];
}

- (void)voteSuccessRefresh
{
    [self requestUserfro];
}

- (void)reAccountMoney
{
    [self requestLogin];
}

- (void)initView
{
    NSString *userName = [[NSUserDefaults standardUserDefaults] objectForKey:@"userName"];
    NSString *userPassword = [[NSUserDefaults standardUserDefaults] objectForKey:@"password"];
    
    if(userName.length != 0 && userPassword.length != 0)
    {
        [self.savePasswordBtn setImage:[UIImage imageNamed:@"savePassword_select.png"] forState:UIControlStateNormal];
        self.userNameTextField.text = userName;
        self.passWordTextField.text = userPassword;
        isSavePassword = YES;
    }
    else
    {
        [self.savePasswordBtn setImage:[UIImage imageNamed:@"savePassword_normal.png"] forState:UIControlStateNormal];
        self.userNameTextField.text = nil;
        self.passWordTextField.text = nil;
        isSavePassword = NO;
    }
}


#pragma mark - login view
//注册
- (IBAction)registerActionClick:(id)sender
{
    [[AppDelegate getAppDelegate] setIsSlider:NO];
    RegisterViewController *registerView = [[RegisterViewController alloc] initWithNibName:@"RegisterViewController" bundle:nil];
    [self.sideMenu.navigationController pushViewController:registerView animated:NO];
    self.sideMenu.menuState = MFSideMenuStateClosed;
    
    [self.view endEditing:YES];
    [self.userNameTextBg setImage:[UIImage imageNamed:@"field_normal.png"]];
    [self.passwordBg setImage:[UIImage imageNamed:@"field_normal.png"]];
}

//记住密码
- (IBAction)savePasswordAction:(id)sender
{
    NSString *userName = [[NSUserDefaults standardUserDefaults] objectForKey:@"userName"];
    NSString *userPassword = [[NSUserDefaults standardUserDefaults] objectForKey:@"password"];
    
    if(userName.length != 0 && userPassword.length != 0)
    {
        [self.savePasswordBtn setImage:[UIImage imageNamed:@"savePassword_normal.png"] forState:UIControlStateNormal];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"userName"];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"password"];
        isSavePassword = NO;
    }
    else
    {
        [self.savePasswordBtn setImage:[UIImage imageNamed:@"savePassword_select.png"] forState:UIControlStateNormal];
        [[NSUserDefaults standardUserDefaults] setValue:self.userNameTextField.text forKey:@"userName"];
        [[NSUserDefaults standardUserDefaults] setValue:self.passWordTextField.text forKey:@"password"];
        isSavePassword = YES;
    }
}

//找回密码
- (IBAction)findPasswordActionClick:(id)sender
{
    FindPasswordViewController *findPassword = [[FindPasswordViewController alloc] initWithNibName:@"FindPasswordViewController" bundle:nil];
    
    [self.sideMenu.navigationController pushViewController:findPassword animated:NO];
    self.sideMenu.menuState = MFSideMenuStateClosed;
}

//登录
- (IBAction)loginActionClick:(id)sender
{
    if(self.userNameTextField.text.length == 0 || ![Utils validateUserName:self.userNameTextField.text])
    {
        [Utils showMessage:@"请正确输入用户名"];
    }
    
    if(self.passWordTextField.text.length < 6 || self.passWordTextField.text.length > 15)
    {
        [Utils showMessage:@"请正确输入密码"];
        return;
    }
    
    [self.view endEditing:YES];
    [self.userNameTextBg setImage:[UIImage imageNamed:@"field_normal.png"]];
    [self.passwordBg setImage:[UIImage imageNamed:@"field_normal.png"]];
    [self requestLogin];
}

#pragma mark -
//充值
- (IBAction)rechargeMoney:(UIButton *)sender
{
    [[AppDelegate getAppDelegate] setIsSlider:NO];
    RechargeMoneyViewController *rechargeMoney = [[RechargeMoneyViewController alloc] initWithNibName:@"RechargeMoneyViewController" bundle:nil];
    [self.sideMenu.navigationController pushViewController:rechargeMoney animated:NO];
    self.sideMenu.menuState = MFSideMenuStateClosed;
}

//提现
- (IBAction)geoutMoney:(UIButton *)sender
{
    if(![[AppDelegate getAppDelegate] isHandBankFro])
    {
        [Utils showMessage:@"请先完善个人资料"];
        return;
    }
    
    [[AppDelegate getAppDelegate] setIsSlider:NO];
    GetoutMoneyViewController *getoutMoney = [[GetoutMoneyViewController alloc] initWithNibName:@"GetoutMoneyViewController" bundle:nil];
    
    [self.sideMenu.navigationController pushViewController:getoutMoney animated:NO];
    self.sideMenu.menuState = MFSideMenuStateClosed;
}

//投注记录
- (IBAction)voteRecord:(id)sender
{
    [[AppDelegate getAppDelegate] setIsSlider:NO];
    VoteRecordViewController *voteRecord = [[VoteRecordViewController alloc] initWithNibName:@"VoteRecordViewController" bundle:nil];
    [self.sideMenu.navigationController pushViewController:voteRecord animated:NO];
    self.sideMenu.menuState = MFSideMenuStateClosed;
}

//个人明细
- (IBAction)myDetailList:(id)sender
{
    [[AppDelegate getAppDelegate] setIsSlider:NO];
    MyDetailListViewController *myDetailList = [[MyDetailListViewController alloc] initWithNibName:@"MyDetailListViewController" bundle:nil];
    [self.sideMenu.navigationController pushViewController:myDetailList animated:NO];
    self.sideMenu.menuState = MFSideMenuStateClosed;
}


//个人资料
- (IBAction)myInfo:(id)sender
{
    [[AppDelegate getAppDelegate] setIsSlider:NO];
    MyInfroViewController *myInfro = [[MyInfroViewController alloc] initWithNibName:@"MyInfroViewController" bundle:nil];
    [self.sideMenu.navigationController pushViewController:myInfro animated:NO];
    self.sideMenu.menuState = MFSideMenuStateClosed;
}

//修改密码
- (IBAction)changePassword:(id)sender
{
    [[AppDelegate getAppDelegate] setIsSlider:NO];
    ChangePasswordViewController *changePassword = [[ChangePasswordViewController alloc] initWithNibName:@"ChangePasswordViewController" bundle:nil];
    [self.sideMenu.navigationController pushViewController:changePassword animated:NO];
    self.sideMenu.menuState = MFSideMenuStateClosed;
}

//反馈意见
- (IBAction)feedBackSuggestion:(id)sender
{
    [[AppDelegate getAppDelegate] setIsSlider:NO];
    FeedBackSuggestViewController *feedBackSuggest = [[FeedBackSuggestViewController alloc] initWithNibName:@"FeedBackSuggestViewController" bundle:nil];
    [self.sideMenu.navigationController pushViewController:feedBackSuggest animated:NO];
    self.sideMenu.menuState = MFSideMenuStateClosed;
}

//检查更新
- (IBAction)checkUpdate:(id)sender
{
    [self checkUpdate];
}

//登出
- (IBAction)logout:(id)sender
{
    [[NSUserDefaults standardUserDefaults] setValue:@"0" forKey:@"IsExit"];
    self.showInfroView.hidden = YES;
    self.exitBtn.hidden = YES;
    self.loginView.hidden = NO;
    [[AppDelegate getAppDelegate] setIsLogin:NO];
    [[AppDelegate getAppDelegate] setAccountRemaind:nil];
    [[AppDelegate getAppDelegate] setUid:nil];
    [self initView];
}

//修改密码后重新登陆
- (void)reLogin
{
    self.showInfroView.hidden = YES;
    self.exitBtn.hidden = YES;
    self.loginView.hidden = NO;
    [[AppDelegate getAppDelegate] setIsLogin:NO];
    [[AppDelegate getAppDelegate] setAccountRemaind:nil];
    [[AppDelegate getAppDelegate] setUid:nil];
    
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"userName"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"password"];
    
    [self initView];
}

#pragma mark - textField delegate
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if(textField == self.userNameTextField)
    {
        [self.userNameTextBg setImage:[UIImage imageNamed:@"field_active.png"]];
        [self.passwordBg setImage:[UIImage imageNamed:@"field_normal.png"]];
    }
    
    if(textField == self.passWordTextField)
    {
        [self.userNameTextBg setImage:[UIImage imageNamed:@"field_normal.png"]];
        [self.passwordBg setImage:[UIImage imageNamed:@"field_active.png"]];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if(textField == self.userNameTextField)
    {
        return [self.passWordTextField becomeFirstResponder];
    }
    
    if(textField == self.passWordTextField)
    {
        [self.passwordBg setImage:[UIImage imageNamed:@"field_normal.png"]];
    }
    return [textField resignFirstResponder];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
    [self.userNameTextBg setImage:[UIImage imageNamed:@"field_normal.png"]];
    [self.passwordBg setImage:[UIImage imageNamed:@"field_normal.png"]];
}

#pragma mark - request server
//登陆请求
- (void)requestLogin
{
    NSMutableString *unmd5str = [[NSMutableString alloc] init];
    [unmd5str appendString:TestKey];
    
    NSString *xmlStr = [NSString stringWithFormat:
                        @"<body>"
                        "<elements>"
                        "<element>"
                        "<username>%@</username>"
                        "<actpassword>%@</actpassword>"
                        "</element>"
                        "</elements>"
                        "</body>",self.userNameTextField.text,self.passWordTextField.text];
    [unmd5str appendString:xmlStr];
    
    NSMutableString *post = [[NSMutableString alloc] init];
    post = [NSMutableString stringWithFormat:
            @"SumaLottery=<?xml version =\"1.0\"encoding=\"UTF-8\"?>"
            "<message version=\"1.0\">"
            "<header>"
            "<transactiontype>10008_1.1</transactiontype>"
            "<timestamp>%@</timestamp>"
            "<digest>%@</digest>"
            "<agenterid>10000002</agenterid>"
            "<ipaddress></ipaddress>"
            "<source>WEB</source>"
            "</header>"
            "<body>"
            "<elements>"
            "<element>"
            "<username>%@</username>"
            "<actpassword>%@</actpassword>"
            "</element>"
            "</elements>"
            "</body>"
            "</message>",
            [Utils getcurrenttime],[Utils md5:unmd5str],self.userNameTextField.text,self.passWordTextField.text];
    
    NSLog(@"login request %@",post);
    [self showProgressHUD:@"加载中"];
    
    [self.connection requestConnection:SERVER_URL
                            postParams:post
                            completion:^(NSMutableDictionary *responseDict)
     {
         [self hideProgressHUD];
         NSLog(@"login responestdict %@",responseDict);
         NSDictionary *bodyDic = [responseDict objectForKey:@"body"];
         NSDictionary *element = [bodyDic objectForKey:@"element"];
         NSDictionary *oelement = [bodyDic objectForKey:@"oelement"];
         if([[oelement objectForKey:@"errorcode"] intValue] == 0)
         {
             if(isSavePassword)
             {
                 [[NSUserDefaults standardUserDefaults] setValue:self.userNameTextField.text forKey:@"userName"];
                 [[NSUserDefaults standardUserDefaults] setValue:self.passWordTextField.text forKey:@"password"];
             }
             
             [[NSUserDefaults standardUserDefaults] setValue:@"1" forKey:@"IsExit"];
             
             self.userName.text = [element objectForKey:@"username"];
             self.money.text = [element objectForKey:@"money"];
             
             [[AppDelegate getAppDelegate] setUid:[element objectForKey:@"uid"]];
             [[AppDelegate getAppDelegate] setUserName:self.userName.text];
//             [[AppDelegate getAppDelegate] setTelePhone:self.userNameTextField.text];
             [[AppDelegate getAppDelegate] setIsLogin:YES];
             [[AppDelegate getAppDelegate] setAccountRemaind:self.money.text];
             [[AppDelegate getAppDelegate] setUserPassword:self.passWordTextField.text];
             
//             [Utils showMessage:@"登陆成功"];
             
             [self.loginView setHidden:YES];
             [self.showInfroView setHidden:NO];
             [self.exitBtn setHidden:NO];
             [self requestUserfro];
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
             NSString *account = [elements objectForKey:@"account"];
             NSString *accountMonry = @"0";
             if (![account isEqualToString:@"0"]) {
            
                 accountMonry = [NSString stringWithFormat:@"%@.%@",[account substringWithRange:NSMakeRange(0, account.length - 1)],[account substringFromIndex:account.length - 2]];
             }
             
             [[AppDelegate getAppDelegate] setAccountRemaind:accountMonry];
             self.money.text = accountMonry;
             [[AppDelegate getAppDelegate] setIsUserInfro:YES];
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

//检查更新
- (void)checkUpdate
{
    NSMutableString *unmd5str = [[NSMutableString alloc] init];
    [unmd5str appendString:TestKey];
    
    NSString *xmlStr = [NSString stringWithFormat:
                        @"<body>"
                        "<elements>"
                        "<element>"
                        "<version>%@</version>"
                        "</element>"
                        "</elements>"
                        "</body>",[Utils appVersion]];
    [unmd5str appendString:xmlStr];
    
    NSMutableString *post = [[NSMutableString alloc] init];
    post = [NSMutableString stringWithFormat:
            @"SumaLottery=<?xml version =\"1.0\"encoding=\"UTF-8\"?>"
            "<message version=\"1.0\">"
            "<header>"
            "<transactiontype>10012</transactiontype>"
            "<timestamp>%@</timestamp>"
            "<digest>%@</digest>"
            "<agenterid>10000002</agenterid>"
            "<ipaddress></ipaddress>"
            "<source>WEB</source>"
            "</header>"
            "<body>"
            "<elements>"
            "<element>"
            "<version>%@</version>"
            "</element>"
            "</elements>"
            "</body>"
            "</message>",
            [Utils getcurrenttime],[Utils md5:unmd5str],[Utils appVersion]];
    
    NSLog(@"check update request %@",post);
    [self showProgressHUD:@"加载中"];
    
    [self.connection requestConnection:SERVER_URL
                            postParams:post
                            completion:^(NSMutableDictionary *responseDict)
     {
         [self hideProgressHUD];
         NSLog(@"check update responsedict %@",responseDict);
         NSDictionary *bodyDic = [responseDict objectForKey:@"body"];
         NSDictionary *oelement = [bodyDic objectForKey:@"oelement"];
         
         if([[oelement objectForKey:@"errorcode"] intValue] == 0)
         {
             [Utils showMessage:@"有新版本，请更新"];
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
