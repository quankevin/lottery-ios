//
//  AppDelegate.h
//  FootBallLottery
//
//  Created by jaye on 15/1/2.
//  Copyright (c) 2015年 jaye. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppConstants.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (nonatomic) BOOL isSlider;                    //是否可以滑动
@property (nonatomic) BOOL isUserInfro;                 //是否已经请求用户信息
@property (nonatomic) BOOL isResigter;                  //是否在注册

@property (nonatomic) BOOL    isLogin;                   //判断登录
@property (nonatomic, retain) NSString *userName;        //用户名
@property (nonatomic, retain) NSString *telePhone;       //手机号码
@property (nonatomic, retain) NSString *accountRemaind;  //账户余额
@property (nonatomic, retain) NSString *uid;             //用户ID
@property (nonatomic, retain) NSString *userPassword;    //用户密码

@property (nonatomic) BOOL isHandInFro;                  //判断绑定个人信息(个人信息)
@property (nonatomic, retain) NSString *realName;        //真实姓名
@property (nonatomic, retain) NSString *cardId;          //身份证ID

@property (nonatomic) BOOL isHandBankFro;                //判断绑定银行卡信息(个人信息)
@property (nonatomic, retain) NSString *bankName;        //银行名
@property (nonatomic, retain) NSString *bankAddress;     //银行地址
@property (nonatomic, retain) NSString *bankCard;        //银行卡号

@property (nonatomic, retain) NSString *rechargeBankCard;   //提现银行卡

@property (nonatomic, retain) NSMutableArray *bankList;     //储蓄卡列表
@property (nonatomic, retain) NSMutableArray *bankList_c;   //信用卡列表
@property (nonatomic, retain) NSString *bankCode;          //银行代码

@property (nonatomic, assign) BankType bankType;      //银行卡类型

@property (nonatomic, retain) NSMutableArray *tollgateArray;

+ (id)getAppDelegate;

@end

