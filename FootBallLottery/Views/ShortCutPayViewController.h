//
//  ShortCutPayViewController.h
//  FootBallLottery
//
//  Created by jaye on 15/2/2.
//  Copyright (c) 2015年 jaye. All rights reserved.
//

#import "BaseViewController.h"

@interface ShortCutPayViewController : BaseViewController
{
    NSTimer *timer;
}


@property (nonatomic, retain) NSString *bandId;
@property (nonatomic, retain) NSString *bankCode;
@property (nonatomic, retain) NSString *bankCardNum;
@property (nonatomic, retain) NSString *rechargeMoney;
@property (nonatomic, retain) NSString *bankType;


@property (strong, nonatomic) IBOutlet UIView *payView;
@property (weak, nonatomic) IBOutlet UILabel *bankInfro;
@property (weak, nonatomic) IBOutlet UILabel *money;
@property (weak, nonatomic) IBOutlet UITextField *checkCodeTextField;
@property (weak, nonatomic) IBOutlet UIButton *checkCodeBtn;
@property (weak, nonatomic) IBOutlet UIImageView *checkCodeBg;


@property (strong, nonatomic) IBOutlet UIView *successView;
@property (weak, nonatomic) IBOutlet UILabel *remainMoney;

@property (nonatomic, retain) NSString *requestOrderId;
@property (nonatomic, retain) NSString *tradeId;
@property (nonatomic, retain) NSString *randomValidateId;
@end
