//
//  RegisterViewController.h
//  FootBallLottery
//
//  Created by jaye on 15/1/21.
//  Copyright (c) 2015年 jaye. All rights reserved.
//

#import "BaseViewController.h"

@interface RegisterViewController : BaseViewController
{
    NSTimer *timer;
    NSString *telephoneStr;
    BOOL isDone;
}

@property (strong, nonatomic) IBOutlet UIView *userView;
@property (weak, nonatomic) IBOutlet UIImageView *usernameBg;
@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;
@property (weak, nonatomic) IBOutlet UIImageView *telephoneBg;
@property (weak, nonatomic) IBOutlet UITextField *telephoneTextField;
@property (weak, nonatomic) IBOutlet UIImageView *passwordBg;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;


@property (strong, nonatomic) IBOutlet UIView *registerView;
@property (weak, nonatomic) IBOutlet UIImageView *checkCodeBg;
@property (weak, nonatomic) IBOutlet UITextField *checkCodeTextField;
@property (weak, nonatomic) IBOutlet UIButton *checkCodeBtn;
@property (weak, nonatomic) IBOutlet UIButton *registerBtn;

@end
