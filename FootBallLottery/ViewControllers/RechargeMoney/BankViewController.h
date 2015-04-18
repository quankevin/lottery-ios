//
//  BankViewController.h
//  FootBallLottery
//
//  Created by jaye on 15/1/29.
//  Copyright (c) 2015年 jaye. All rights reserved.
//

#import "BaseViewController.h"
#import "SelectBankViewController.h"

@interface BankViewController : BaseViewController
{
    NSTimer *timer;
}

@property (strong, nonatomic) IBOutlet UIView *headView;

@property (nonatomic, retain) NSString *rechargeMoney;
@property (nonatomic, retain) NSString *requestOrderId;
@property (nonatomic, retain) NSString *tradeId;

//储蓄卡试图
@property (weak, nonatomic) IBOutlet UIView *bankView;
@property (weak, nonatomic) IBOutlet UIImageView *cardHolderBg;
@property (weak, nonatomic) IBOutlet UITextField *cardHolderTextField;
@property (weak, nonatomic) IBOutlet UIImageView *cardIdBg;
@property (weak, nonatomic) IBOutlet UITextField *cardIdTextField;
@property (weak, nonatomic) IBOutlet UIImageView *bankBg;
@property (weak, nonatomic) IBOutlet UITextField *bankTextField;
@property (weak, nonatomic) IBOutlet UIImageView *cardNumberBg;
@property (weak, nonatomic) IBOutlet UITextField *cardNumberTextField;
@property (weak, nonatomic) IBOutlet UIImageView *telephoneBg;
@property (weak, nonatomic) IBOutlet UITextField *telephoneTextField;
@property (weak, nonatomic) IBOutlet UIImageView *checkCodeBg;
@property (weak, nonatomic) IBOutlet UITextField *checkCodeTextField;

//信用卡试图
@property (strong, nonatomic) IBOutlet UIView *creadBankView;
@property (weak, nonatomic) IBOutlet UIImageView *creadHolderBg;
@property (weak, nonatomic) IBOutlet UITextField *creadHolderTextField;
@property (weak, nonatomic) IBOutlet UIImageView *creadCardIdBg;
@property (weak, nonatomic) IBOutlet UITextField *creadIdTextField;
@property (weak, nonatomic) IBOutlet UIImageView *creadBankNameBg;
@property (weak, nonatomic) IBOutlet UITextField *creadBankNameTextField;
@property (weak, nonatomic) IBOutlet UIImageView *creadCardNumBg;
@property (weak, nonatomic) IBOutlet UITextField *creadCardNumTextField;
@property (weak, nonatomic) IBOutlet UIImageView *indateBg;
@property (weak, nonatomic) IBOutlet UITextField *indateTextField;
@property (weak, nonatomic) IBOutlet UIImageView *cvnCodeBg;
@property (weak, nonatomic) IBOutlet UITextField *cvnCodeTextField;
@property (weak, nonatomic) IBOutlet UIImageView *creadTelephoneBg;
@property (weak, nonatomic) IBOutlet UITextField *creadTelephoneTextField;
@property (weak, nonatomic) IBOutlet UIImageView *creadCheckCodeBg;
@property (weak, nonatomic) IBOutlet UITextField *creadCheckCodeTextField;

@property (weak, nonatomic) IBOutlet UIButton *saveCheckCodeBtn;
@property (weak, nonatomic) IBOutlet UIButton *creditCheckCodeBtn;

@property (nonatomic, retain) NSString *randomValidateId;


@end
