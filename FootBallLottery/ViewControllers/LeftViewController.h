//
//  LeftViewController.h
//  FootBallLottery
//
//  Created by jaye on 15/1/2.
//  Copyright (c) 2015年 jaye. All rights reserved.
//

#import "BaseViewController.h"
#import "ChangePasswordViewController.h"
#import "FeedBackSuggestViewController.h"
#import "VoteRecordViewController.h"
#import "RechargeMoneyViewController.h"
#import "MyInfroViewController.h"
#import "GetoutMoneyViewController.h"
#import "MyDetailListViewController.h"
#import "FindPasswordViewController.h"
#import "RegisterViewController.h"

@interface LeftViewController : BaseViewController<UITextFieldDelegate>
{
    BOOL isSavePassword;
}

//登陆
@property (strong, nonatomic) IBOutlet UIView *loginView;
@property (weak, nonatomic) IBOutlet UIImageView *userNameTextBg;
@property (weak, nonatomic) IBOutlet UITextField *userNameTextField;
@property (weak, nonatomic) IBOutlet UIImageView *passwordBg;
@property (weak, nonatomic) IBOutlet UITextField *passWordTextField;
@property (weak, nonatomic) IBOutlet UIButton *savePasswordBtn;
@property (strong, nonatomic) IBOutlet UIButton *exitBtn;


//登陆成功后显示页面
@property (strong, nonatomic) IBOutlet UIView *showInfroView;
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UILabel *money;


@end
