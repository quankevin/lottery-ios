//
//  FindPasswordViewController.h
//  FootBallLottery
//
//  Created by jaye on 15/1/17.
//  Copyright (c) 2015年 jaye. All rights reserved.
//

#import "BaseViewController.h"

@interface FindPasswordViewController : BaseViewController
{
    NSTimer *timer;
}

@property (weak, nonatomic) IBOutlet UIImageView *telePhoneBg;
@property (weak, nonatomic) IBOutlet UITextField *telePhoneTextField;
@property (weak, nonatomic) IBOutlet UIImageView *checkCodeBg;
@property (weak, nonatomic) IBOutlet UITextField *checkCodeTextField;
@property (weak, nonatomic) IBOutlet UIButton *checkCodeBtn;

@end
