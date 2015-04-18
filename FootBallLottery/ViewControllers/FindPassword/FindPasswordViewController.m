//
//  FindPasswordViewController.m
//  FootBallLottery
//
//  Created by jaye on 15/1/17.
//  Copyright (c) 2015年 jaye. All rights reserved.
//

#import "FindPasswordViewController.h"

@interface FindPasswordViewController ()

@end

@implementation FindPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupMenuBarButtonItems];
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
    label.text = @"找回密码";
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
}

//发送验证码
- (IBAction)sendCheckCode:(id)sender
{
    if(self.telePhoneTextField.text.length != 11 ||  ![Utils isValidateMobile:self.telePhoneTextField.text])
    {
        [Utils showMessage:@"请正确填写手机号码"];
        return;
    }
    
    [self requestCheckCode];
}

//获取新密码
- (IBAction)getNewPassword:(id)sender
{
    if(self.telePhoneTextField.text.length != 11 ||  ![Utils isValidateMobile:self.telePhoneTextField.text])
    {
        [Utils showMessage:@"请正确填写手机号码"];
        return;
    }
    
    if(self.checkCodeTextField.text.length != 4)
    {
        [Utils showMessage:@"请正确填写验证码"];
        return;
    }
}


#pragma marl - textField delegate
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if(textField == self.telePhoneTextField)
    {
        [self.telePhoneBg setImage:[UIImage imageNamed:@"textfield_active.png"]];
        [self.checkCodeBg setImage:[UIImage imageNamed:@"textfieldPassword_normal.png"]];
    }
    
    if(textField == self.checkCodeTextField)
    {
        [self.telePhoneBg setImage:[UIImage imageNamed:@"textfieldPassword_normal.png"]];
        [self.checkCodeBg setImage:[UIImage imageNamed:@"textfield_active.png"]];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if(textField == self.telePhoneTextField)
    {
        return [self.checkCodeTextField becomeFirstResponder];
    }
    
    if(textField == self.checkCodeTextField)
    {
        [self.checkCodeBg setImage:[UIImage imageNamed:@"textfieldPassword_normal.png"]];
    }
    
    return [textField resignFirstResponder];
}

#pragma mark - touch
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
    [self.telePhoneBg setImage:[UIImage imageNamed:@"textfieldPassword_normal.png"]];
    [self.checkCodeBg setImage:[UIImage imageNamed:@"textfieldPassword_normal.png"]];
}

#pragma mark - request server
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
                        "<type>02</type>"
                        "</element>"
                        "</elements>"
                        "</body>",
                        self.telePhoneTextField.text];
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
            "<type>02</type>"
            "</element>"
            "</elements>"
            "</body>"
            "</message>",
            [Utils getcurrenttime],[Utils md5:unmd5str],self.telePhoneTextField.text];
    
    NSLog(@"121212 %@",post);
    [self showProgressHUD:@"加载中"];
    
    [self.connection requestConnection:SERVER_URL
                            postParams:post
                            completion:^(NSMutableDictionary *responseDict)
     {
         [self hideProgressHUD];
         NSLog(@"datadic %@",responseDict);
         if([[responseDict objectForKey:@"errorcode"] intValue] == 0)
         {
             [Utils showMessage:@"短信已发送您手机，请注意查收"];
             [self.checkCodeBtn setTitle:@"60" forState:UIControlStateNormal];
             [self.checkCodeBtn setBackgroundImage:[UIImage imageNamed:@"yanzhengma_active.png"] forState:UIControlStateNormal];
             timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(countTime) userInfo:nil repeats:YES];
             self.checkCodeBtn.userInteractionEnabled = NO;
         }
         else
         {
             [Utils showMessage:[responseDict objectForKey:@"errormsg"]];
         }
     }
     failed:^(NSString *failedMessage)
     {
         NSLog(@"error %@",failedMessage);
         [self showFailMessage:failedMessage];
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
