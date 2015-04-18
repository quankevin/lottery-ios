//
//  GetoutMoneyViewController.h
//  FootBallLottery
//
//  Created by jaye on 15/1/2.
//  Copyright (c) 2015年 jaye. All rights reserved.
//

#import "BaseViewController.h"
#import "SelectBankViewController.h"
#import "SelectZoneViewController.h"

@interface GetoutMoneyViewController : BaseViewController<UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet UIView *headView;
@property (weak, nonatomic) IBOutlet UITextField *getOutMoneyTextFild;
@property (weak, nonatomic) IBOutlet UILabel *remainMoney;

@property (strong, nonatomic) IBOutlet UIView *firstView;

//银行卡信息
@property (weak, nonatomic) IBOutlet UIImageView *cardOwnerBg;
@property (weak, nonatomic) IBOutlet UITextField *cardOwnerTextField;
@property (weak, nonatomic) IBOutlet UIImageView *IdBg;
@property (weak, nonatomic) IBOutlet UITextField *IdTextField;
@property (weak, nonatomic) IBOutlet UIImageView *bankBg;
@property (weak, nonatomic) IBOutlet UITextField *bankTextField;
@property (weak, nonatomic) IBOutlet UIImageView *cardNumBg;
@property (weak, nonatomic) IBOutlet UITextField *cardNumberTextField;
@property (weak, nonatomic) IBOutlet UIImageView *accountZoneBg;
@property (weak, nonatomic) IBOutlet UITextField *accountZoneTextField;
@property (weak, nonatomic) IBOutlet UIImageView *passwordBg;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;

//银行卡信息
@property (strong, nonatomic) IBOutlet UIView *bankInfroView;
@property (weak, nonatomic) IBOutlet UILabel *bankName;
@property (weak, nonatomic) IBOutlet UILabel *bankNumber;

//支付试图
@property (strong, nonatomic) IBOutlet UIView *payView;
@property (weak, nonatomic) IBOutlet UILabel *payMoneyLabel;
@property (weak, nonatomic) IBOutlet UILabel *payMoney;
@property (weak, nonatomic) IBOutlet UIImageView *checkCodeBg;
@property (weak, nonatomic) IBOutlet UITextField *checkCodeTextField;

//支付成功试图
@property (strong, nonatomic) IBOutlet UIView *paySuccessView;
@property (weak, nonatomic) IBOutlet UILabel *getOutRemainMoney;

@end
