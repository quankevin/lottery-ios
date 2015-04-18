//
//  RegisterViewController.m
//  FootBallLottery
//
//  Created by jaye on 15/1/21.
//  Copyright (c) 2015年 jaye. All rights reserved.
//

#import "RegisterViewController.h"

@interface RegisterViewController ()

@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupMenuBarButtonItems];
    self.userView.frame = CGRectMake(0, 70, CGRectGetWidth(self.userView.frame), CGRectGetHeight(self.userView.frame));
    [self.view addSubview:self.userView];
    self.userView.hidden = NO;
    self.registerView.frame = CGRectMake(0, 70, CGRectGetWidth(self.userView.frame), CGRectGetHeight(self.userView.frame));
    [self.view addSubview:self.registerView];
    self.registerView.hidden = YES;
    telephoneStr = @"13312345678";
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
    label.text = @"注册";
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

#pragma mark - alertView delegate
- (void)showMessage:(NSString *)message
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:message delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    alertView.delegate = self;
    [alertView show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [[AppDelegate getAppDelegate] setIsSlider:YES];
    [self.navigationController popToRootViewControllerAnimated:YES];
    [[NSUserDefaults standardUserDefaults] setValue:self.usernameTextField.text forKey:@"userName"];
    [[NSUserDefaults standardUserDefaults] setValue:self.passwordTextField.text forKey:@"password"];
    [[AppDelegate getAppDelegate] setUserName:self.usernameTextField.text];
    [[AppDelegate getAppDelegate] setUserPassword:self.passwordTextField.text];
    [[AppDelegate getAppDelegate] setIsResigter:YES];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"autoLogin" object:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"back" object:nil];
}

#pragma mark - textField delegate
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if(textField == self.usernameTextField)
    {
        [self.usernameBg setImage:[UIImage imageNamed:@"field_active.png"]];
        [self.telephoneBg setImage:[UIImage imageNamed:@"field_normal.png"]];
        [self.passwordBg setImage:[UIImage imageNamed:@"field_normal.png"]];
        [self.checkCodeBg setImage:[UIImage imageNamed:@"field_normal.png"]];
    }
    
    if(textField == self.telephoneTextField)
    {
        [self.usernameBg setImage:[UIImage imageNamed:@"field_normal.png"]];
        [self.telephoneBg setImage:[UIImage imageNamed:@"field_active.png"]];
        [self.passwordBg setImage:[UIImage imageNamed:@"field_normal.png"]];
        [self.checkCodeBg setImage:[UIImage imageNamed:@"field_normal.png"]];
        
        if(self.usernameTextField.text.length < 4 || self.usernameTextField.text.length > 16) //|| ![Utils validateUserName:self.usernameTextField.text])
        {
            [Utils showMessage:@"请输入4至16位用户名"];
            return;
        }
        else
        {
            [self requestCheckInfo];
        }
    }
    
    if(textField == self.passwordTextField)
    {
        [self.usernameBg setImage:[UIImage imageNamed:@"field_normal.png"]];
        [self.telephoneBg setImage:[UIImage imageNamed:@"field_normal.png"]];
        [self.passwordBg setImage:[UIImage imageNamed:@"field_active.png"]];
        [self.checkCodeBg setImage:[UIImage imageNamed:@"field_normal.png"]];
        
        if(self.telephoneTextField.text.length != 11 ||  ![Utils isValidateMobile:self.telephoneTextField.text])
        {
            [Utils showMessage:@"请正确输入手机号码"];
            return;
        }
        else
        {
            telephoneStr = self.telephoneTextField.text;
            [self requestCheckInfo];
        }
    }
    
    if(textField == self.checkCodeTextField)
    {
        [self.usernameBg setImage:[UIImage imageNamed:@"field_normal.png"]];
        [self.telephoneBg setImage:[UIImage imageNamed:@"field_normal.png"]];
        [self.passwordBg setImage:[UIImage imageNamed:@"field_normal.png"]];
        [self.checkCodeBg setImage:[UIImage imageNamed:@"field_active.png"]];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if(textField == self.usernameTextField)
    {
        return [self.telephoneTextField becomeFirstResponder];
    }
    
    if(textField == self.telephoneTextField)
    {
        return [self.passwordTextField becomeFirstResponder];
    }
    
    if(textField == self.passwordTextField)
    {
//        return [self.checkCodeTextField becomeFirstResponder];
        [self.passwordBg setImage:[UIImage imageNamed:@"field_normal.png"]];
    }
    
    if(textField == self.checkCodeTextField)
    {
        [self.checkCodeBg setImage:[UIImage imageNamed:@"field_normal.png"]];
    }
    return [textField resignFirstResponder];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
    [self.usernameBg setImage:[UIImage imageNamed:@"field_normal.png"]];
    [self.telephoneBg setImage:[UIImage imageNamed:@"field_normal.png"]];
    [self.passwordBg setImage:[UIImage imageNamed:@"field_normal.png"]];
    [self.checkCodeBg setImage:[UIImage imageNamed:@"field_normal.png"]];
}

- (IBAction)doneAction:(id)sender
{
    if(self.usernameTextField.text.length < 4 || self.usernameTextField.text.length > 16) //|| ![Utils validateUserName:self.usernameTextField.text])
    {
        [Utils showMessage:@"请输入4至16位用户名"];
        return;
    }
    
    if(self.telephoneTextField.text.length != 11 ||  ![Utils isValidateMobile:self.telephoneTextField.text])
    {
        [Utils showMessage:@"请正确输入手机号码"];
        return;
    }
    
    if(self.passwordTextField.text.length < 6 ||  self.passwordTextField.text.length > 15)
    {
        [Utils showMessage:@"请正确输入密码"];
        return;
    }
    isDone = YES;
    [self requestCheckInfo];
}

//发送验证码
- (IBAction)senderCheckCode:(id)sender
{
//    if(self.telephoneTextField.text.length != 11 || ![Utils isValidateMobile:self.telephoneTextField.text])
//    {
//        [Utils showMessage:@"请正确输入手机号码"];
//        return;
//    }
    [self nomarlTextField];
    [self requestCheckCode];
}

//注册
- (IBAction)registerActionClick:(id)sender
{
    if(self.checkCodeTextField.text.length != 4)
    {
        [Utils showMessage:@"请输入验证码"];
        return;
    }
    [self nomarlTextField];
    [self requestRegister];
}

- (void)nomarlTextField
{
    [self.usernameTextField resignFirstResponder];
    [self.telephoneTextField resignFirstResponder];
    [self.passwordTextField resignFirstResponder];
    [self.checkCodeTextField resignFirstResponder];
    
    [self.usernameBg setImage:[UIImage imageNamed:@"field_normal.png"]];
    [self.telephoneBg setImage:[UIImage imageNamed:@"field_normal.png"]];
    [self.passwordBg setImage:[UIImage imageNamed:@"field_normal.png"]];
    [self.checkCodeBg setImage:[UIImage imageNamed:@"field_normal.png"]];
}

#pragma mark - request server
//验证用户名是否存在
- (void)requestCheckInfo
{
    NSMutableString *unmd5str = [[NSMutableString alloc] init];
    [unmd5str appendString:TestKey];
    
    NSString *xmlstr = [NSString stringWithFormat:
                        @"<body>"
                        "<elements>"
                        "<element>"
                        "<username>%@</username>"
                        "<phone>%@</phone>"
                        "</element>"
                        "</elements>"
                        "</body>",
                        self.usernameTextField.text,telephoneStr];
    [unmd5str appendString:xmlstr];
    
    NSMutableString *post = [[NSMutableString alloc] init];
    post = [NSMutableString stringWithFormat:
            @"SumaLottery=<?xml version =\"1.0\"encoding=\"UTF-8\"?>"
            "<message version=\"1.0\">"
            "<header>"
            "<transactiontype>10010</transactiontype>"
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
            "<phone>%@</phone>"
            "</element>"
            "</elements>"
            "</body>"
            "</message>",
            [Utils getcurrenttime],[Utils md5:unmd5str],self.usernameTextField.text,telephoneStr];
    
    NSLog(@"register request %@",post);
    [self showProgressHUD:@"加载中"];
    
    [self.connection requestConnection:SERVER_URL
                            postParams:post
                            completion:^(NSMutableDictionary *responseDict)
     {
         [self hideProgressHUD];
         NSLog(@"register responseDict %@",responseDict);
         NSMutableDictionary *bodyDic = [responseDict objectForKey:@"body"];
         NSMutableDictionary *oelement = [bodyDic objectForKey:@"oelement"];
         NSMutableDictionary *element = [bodyDic objectForKey:@"element"];
         if([[oelement objectForKey:@"errorcode"] isEqualToString:@"0"])
         {
             NSString *ustate = [element objectForKey:@"ustate"];
             NSString *pstate = [element objectForKey:@"pstate"];
             if([ustate isEqualToString:@"1"] )
             {
                 [Utils showMessage:@"用户名已存在"];
             }else if( [pstate isEqualToString:@"1"]){
                 [Utils showMessage:@"手机号码已存在"];
             }
             else
             {
                 if (isDone)
                 {
                     [self.view endEditing:YES];
                     [self.usernameBg setImage:[UIImage imageNamed:@"field_normal.png"]];
                     [self.telephoneBg setImage:[UIImage imageNamed:@"field_normal.png"]];
                     [self.passwordBg setImage:[UIImage imageNamed:@"field_normal.png"]];
                     [self.checkCodeBg setImage:[UIImage imageNamed:@"field_normal.png"]];
                     self.userView.hidden = YES;
                     self.registerView.hidden = NO;
                     isDone = NO;
                 }
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

//请求验证码
- (void)requestCheckCode
{
    NSMutableString *unmd5str = [[NSMutableString alloc] init];
    [unmd5str appendString:TestKey];
    
    NSString *xmlstr = [NSString stringWithFormat:
                        @"<body>"
                        "<elements>"
                        "<element>"
                        "<tel>%@</tel>"
                        "<type>01</type>"
                        "</element>"
                        "</elements>"
                        "</body>",
                        self.telephoneTextField.text];
    [unmd5str appendString:xmlstr];
    
    NSMutableString *post = [[NSMutableString alloc] init];
    post = [NSMutableString stringWithFormat:
            @"SumaLottery=<?xml version =\"1.0\"encoding=\"UTF-8\"?>"
            "<message version=\"1.0\">"
            "<header>"
            "<transactiontype>10011</transactiontype>"
            "<timestamp>%@</timestamp>"
            "<digest>%@</digest>"
            "<agenterid>10000002</agenterid>"
            "<ipaddress></ipaddress>"
            "<source>WEB</source>"
            "</header>"
            "<body>"
            "<elements>"
            "<element>"
            "<tel>%@</tel>"
            "<type>01</type>"
            "</element>"
            "</elements>"
            "</body>"
            "</message>",
            [Utils getcurrenttime],[Utils md5:unmd5str],self.telephoneTextField.text];
    
    NSLog(@"register request %@",post);
    [self showProgressHUD:@"加载中"];
    
    [self.connection requestConnection:SERVER_URL
                            postParams:post
                            completion:^(NSMutableDictionary *responseDict)
     {
         [self hideProgressHUD];
         NSLog(@"register responseDict %@",responseDict);
         NSMutableDictionary *bodyDic = [responseDict objectForKey:@"body"];
         NSMutableDictionary *oelement = [bodyDic objectForKey:@"oelement"];
         if([[oelement objectForKey:@"errorcode"] isEqualToString:@"0"])
         {
             [Utils showMessage:@"短信已发送您手机，请注意查收"];
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

//注册请求
- (void)requestRegister
{
    NSMutableString *unmd5str = [[NSMutableString alloc] init];
    [unmd5str appendString:TestKey];
    
    NSString *xmlstr = [NSString stringWithFormat:
                        @"<body>"
                        "<elements>"
                        "<element>"
                        "<username>%@</username>"
                        "<mail></mail>"
                        "<actpassword>%@</actpassword>"
                        "<mobile>%@</mobile>"
                        "<serialuid></serialuid>"
                        "<type>1</type>"
                        "<code>%@</code>"
                        "</element>"
                        "</elements>"
                        "</body>",
                        self.usernameTextField.text,self.passwordTextField.text,self.telephoneTextField.text,self.checkCodeTextField.text];
    [unmd5str appendString:xmlstr];
    
    NSMutableString *post = [[NSMutableString alloc] init];
    post = [NSMutableString stringWithFormat:
            @"SumaLottery=<?xml version =\"1.0\"encoding=\"UTF-8\"?>"
            "<message version=\"1.0\">"
            "<header>"
            "<transactiontype>10001_1.1</transactiontype>"
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
            "<mail></mail>"
            "<actpassword>%@</actpassword>"
            "<mobile>%@</mobile>"
            "<serialuid></serialuid>"
            "<type>1</type>"
            "<code>%@</code>"
            "</element>"
            "</elements>"
            "</body>"
            "</message>",
            [Utils getcurrenttime],[Utils md5:unmd5str],self.usernameTextField.text,self.passwordTextField.text,self.telephoneTextField.text,self.checkCodeTextField.text];
    
    NSLog(@"register request %@",post);
    [self showProgressHUD:@"加载中"];
    
    [self.connection requestConnection:SERVER_URL
                            postParams:post
                            completion:^(NSMutableDictionary *responseDict)
     {
         [self hideProgressHUD];
         NSLog(@"reqister request %@",responseDict);
         NSDictionary *bodyDic = [responseDict objectForKey:@"body"];
         NSDictionary *oelement = [bodyDic objectForKey:@"oelement"];
         if([[oelement objectForKey:@"errorcode"] isEqualToString:@"0"])
         {
             if([timer isValid])
             {
                 [timer invalidate];
                 timer = nil;
             }
             self.checkCodeBtn.userInteractionEnabled = YES;
             [self.checkCodeBtn setTitle:@"" forState:UIControlStateNormal];
             [self.checkCodeBtn setBackgroundImage:[UIImage imageNamed:@"check_code.png"] forState:UIControlStateNormal];
             
             [self showMessage:@"注册成功"];
         }
         else
         {
//             [Utils showMessage:[oelement objectForKey:@"errormsg"]];
             [self showMessage:@"请求错误"];
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
