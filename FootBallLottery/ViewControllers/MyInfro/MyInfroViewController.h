//
//  MyInfroViewController.h
//  FootBallLottery
//
//  Created by jaye on 15/1/2.
//  Copyright (c) 2015年 jaye. All rights reserved.
//

#import "BaseViewController.h"
#import "SelectBankViewController.h"
#import "SelectZoneViewController.h"

@interface MyInfroViewController : BaseViewController

@property (strong, nonatomic) IBOutlet UIView *headView;
@property (weak, nonatomic) IBOutlet UIImageView *backGroundImage;

//身份信息
@property (strong, nonatomic) IBOutlet UIView *handInInfo;
@property (weak, nonatomic) IBOutlet UIImageView *IDBg;
@property (weak, nonatomic) IBOutlet UITextField *IDTextField;
@property (weak, nonatomic) IBOutlet UIImageView *realNameBg;
@property (weak, nonatomic) IBOutlet UITextField *realName;

//显示我的信息
@property (strong, nonatomic) IBOutlet UIView *showInfroView;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *IDLabel;
@property (weak, nonatomic) IBOutlet UILabel *realNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *telephoneLabel;

//提款银行卡
@property (strong, nonatomic) IBOutlet UIView *bankView;
@property (weak, nonatomic) IBOutlet UIImageView *cardHolderBg;
@property (weak, nonatomic) IBOutlet UITextField *cardholderTextField;
@property (weak, nonatomic) IBOutlet UIImageView *identifyCardBg;
@property (weak, nonatomic) IBOutlet UITextField *identityCardTextField;
@property (weak, nonatomic) IBOutlet UIImageView *bankBg;
@property (weak, nonatomic) IBOutlet UITextField *bankTextField;
@property (weak, nonatomic) IBOutlet UIImageView *cardNumBg;
@property (weak, nonatomic) IBOutlet UITextField *cardNumberTextField;
@property (weak, nonatomic) IBOutlet UIImageView *accountZoneBg;
@property (weak, nonatomic) IBOutlet UITextField *accountZoneTextField;
@property (weak, nonatomic) IBOutlet UIImageView *passwordBg;
@property (weak, nonatomic) IBOutlet UITextField *passWordTextField;

//显示提交的银行信息
@property (strong, nonatomic) IBOutlet UIView *showBankView;
@property (weak, nonatomic) IBOutlet UIImageView *bankIcon;
@property (weak, nonatomic) IBOutlet UILabel *bankName;
@property (weak, nonatomic) IBOutlet UILabel *bankCard;
@property (weak, nonatomic) IBOutlet UILabel *bankCardType;

@end
