//
//  ChangePasswordViewController.h
//  FootBallLottery
//
//  Created by jaye on 15/1/2.
//  Copyright (c) 2015年 jaye. All rights reserved.
//

#import "BaseViewController.h"

@interface ChangePasswordViewController : BaseViewController<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *passwordBg;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UIImageView *freshPasswordBg;
@property (weak, nonatomic) IBOutlet UITextField *freshPasswordTextField;
@property (weak, nonatomic) IBOutlet UIImageView *doneFreshBg;
@property (weak, nonatomic) IBOutlet UITextField *doneFreshPasswordTextField;

@end
