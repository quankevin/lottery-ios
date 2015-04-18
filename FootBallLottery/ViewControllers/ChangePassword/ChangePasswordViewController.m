//
//  ChangePasswordViewController.m
//  FootBallLottery
//
//  Created by jaye on 15/1/2.
//  Copyright (c) 2015年 jaye. All rights reserved.
//

#import "ChangePasswordViewController.h"

@interface ChangePasswordViewController ()

@end

@implementation ChangePasswordViewController

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
    label.text = @"修改密码";
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

#pragma mark - textField delegate
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if(textField == self.passwordTextField)
    {
        [self.passwordBg setImage:[UIImage imageNamed:@"textfield_active.png"]];
        [self.freshPasswordBg setImage:[UIImage imageNamed:@"textfield_normal.png"]];
        [self.doneFreshBg setImage:[UIImage imageNamed:@"textfield_normal.png"]];
    }
    
    if(textField == self.freshPasswordTextField)
    {
        [self.passwordBg setImage:[UIImage imageNamed:@"textfield_normal.png"]];
        [self.freshPasswordBg setImage:[UIImage imageNamed:@"textfield_active.png"]];
        [self.doneFreshBg setImage:[UIImage imageNamed:@"textfield_normal.png"]];
    }
    
    if(textField == self.doneFreshPasswordTextField)
    {
        [self.passwordBg setImage:[UIImage imageNamed:@"textfield_normal.png"]];
        [self.freshPasswordBg setImage:[UIImage imageNamed:@"textfield_normal.png"]];
        [self.doneFreshBg setImage:[UIImage imageNamed:@"textfield_active.png"]];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if(textField == self.passwordTextField)
    {
        return [self.freshPasswordTextField becomeFirstResponder];
    }
    if(textField == self.freshPasswordTextField)
    {
        return [self.doneFreshPasswordTextField becomeFirstResponder];
    }
    if(textField == self.doneFreshPasswordTextField)
    {
        [self.doneFreshBg setImage:[UIImage imageNamed:@"textfield_normal.png"]];
        return [self.doneFreshPasswordTextField resignFirstResponder];
    }
    
    return [self.doneFreshPasswordTextField resignFirstResponder];
}

//提交
- (IBAction)doneActionClick:(id)sender
{
    if(self.passwordTextField.text.length < 6 || self.passwordTextField.text.length > 16)
    {
        [Utils showMessage:@"请输入6到16位密码"];
        return;
    }
    else if(self.freshPasswordTextField.text.length < 6 || self.freshPasswordTextField.text.length > 16)
    {
        [Utils showMessage:@"请输入6到16位新密码"];
        return;
    }
    else if(self.doneFreshPasswordTextField.text.length < 6 || self.doneFreshPasswordTextField.text.length > 16)
    {
        [Utils showMessage:@"请输入6到16位确认新密码"];
        return;
    }
    else if(![self.freshPasswordTextField.text isEqualToString:self.doneFreshPasswordTextField.text])
    {
        [Utils showMessage:@"新密码不一致"];
        return;
    }
    
    if([self.freshPasswordTextField.text isEqualToString:[[AppDelegate getAppDelegate] userPassword]])
    {
        [Utils showMessage:@"新旧密码一致"];
        return;
    }
    
    [self.view endEditing:YES];
    [self.passwordBg setImage:[UIImage imageNamed:@"textfield_normal.png"]];
    [self.freshPasswordBg setImage:[UIImage imageNamed:@"textfield_normal.png"]];
    [self.doneFreshBg setImage:[UIImage imageNamed:@"textfield_normal.png"]];
    
    [self requestChangePassWord];
}

#pragma mark - view touch
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
    [self.passwordBg setImage:[UIImage imageNamed:@"textfield_normal.png"]];
    [self.freshPasswordBg setImage:[UIImage imageNamed:@"textfield_normal.png"]];
    [self.doneFreshBg setImage:[UIImage imageNamed:@"textfield_normal.png"]];
}

#pragma mark - request server
- (void)requestChangePassWord
{
    NSMutableString *unmd5str = [[NSMutableString alloc] init];
    [unmd5str appendString:TestKey];
    
    NSString *xmlStr = [NSString stringWithFormat:
                        @"<body>"
                        "<elements>"
                        "<element>"
                        "<uid>%@</uid>"
                        "<oldpassword>%@</oldpassword>"
                        "<newpassword>%@</newpassword>"
                        "</element>"
                        "</elements>"
                        "</body>",[[AppDelegate getAppDelegate] uid],[Utils MD5Password:self.passwordTextField.text],[Utils MD5Password:self.freshPasswordTextField.text]];
    [unmd5str appendString:xmlStr];
    
    NSMutableString *post = [[NSMutableString alloc] init];
    post = [NSMutableString stringWithFormat:
            @"SumaLottery=<?xml version =\"1.0\"encoding=\"UTF-8\"?>"
            "<message version=\"1.0\">"
            "<header>"
            "<transactiontype>10003_1.1</transactiontype>"
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
            "<oldpassword>%@</oldpassword>"
            "<newpassword>%@</newpassword>"
            "</element>"
            "</elements>"
            "</body>"
            "</message>",
            [Utils getcurrenttime],[Utils md5:unmd5str],[[AppDelegate getAppDelegate] uid],[Utils MD5Password:self.passwordTextField.text],[Utils MD5Password:self.freshPasswordTextField.text]];
    
    [self showProgressHUD:@"加载中"];
    NSLog(@"changePassword request %@",post);
    
    [self.connection requestConnection:SERVER_URL
                            postParams:post
                            completion:^(NSMutableDictionary *responseDict)
     {
         [self hideProgressHUD];
         NSLog(@"login responestdict %@",responseDict);
         NSDictionary *bodyDic = [responseDict objectForKey:@"body"];
         NSDictionary *oelement = [bodyDic objectForKey:@"oelement"];
         if([[oelement objectForKey:@"errorcode"] intValue] == 0)
         {
             [Utils showMessage:@"密码修改成功"];

             [[AppDelegate getAppDelegate] setIsSlider:YES];
             [self.navigationController popToRootViewControllerAnimated:YES];
//             [[NSNotificationCenter defaultCenter] postNotificationName:@"back" object:nil];
             [[NSNotificationCenter defaultCenter] postNotificationName:@"changePassword" object:nil];
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
