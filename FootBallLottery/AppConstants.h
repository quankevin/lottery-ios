//
//  AppConstants.h
//  FootBallLottery
//
//  Created by jaye on 15/1/2.
//  Copyright (c) 2015年 jaye. All rights reserved.
//

#ifndef FootBallLottery_AppConstants_h
#define FootBallLottery_AppConstants_h

#define SERVER_URL @"http://220.167.29.50:8380/lotteryxml.php"   //测试地址

#define Vote_URL   @"http://220.167.29.50/la/jczq/daigou_phone?" //投注跳转URL


//设备高度
#define kWindowHeight [[UIScreen mainScreen] bounds].size.height
//设备宽度
#define kWindowWidth  [[UIScreen mainScreen] bounds].size.width
//设备比例
#define kScreenScale  [UIScreen mainScreen].scale

//系统版本
#define kSystemVersion [[[UIDevice currentDevice] systemVersion] doubleValue]
#define kSystemVersion5 kSystemVersion >= 5.0 && kSystemVersion < 6.0
#define kSystemVersion6 kSystemVersion >= 6.0 && kSystemVersion < 7.0
#define kSystemVersion7 kSystemVersion >= 7.0 && kSystemVersion < 8.0
#define kSystemVersion8 kSystemVersion >= 8.0
#define kSystemVersion7Later kSystemVersion >= 7.0

//设备类型
#define KIsIphone6Plus  (kWindowHeight == 960)
#define KIsIphone6      (kWindowHeight == 667)
#define kIsIphone5      (kWindowHeight == 568)
#define kIsIphone4      (kWindowHeight == 480)

#define kShowMessageTime 2.0f           //提示显示时间
#define kOverViewInWindowTag 10086120   //弹框添加的视图
#define kAnimationTime 0.5f             //弹框使用的动画时间

#define ISNULLSTR(str) (str == nil || (NSObject *)str == [NSNull null] || str.length == 0)

#define TestKey @"e826d69087c0d43236d27170f3421923"

#define PasswordKey @"97d2dcb2ea177246d44f1114e2d5e9c5"

typedef enum
{
    saveBank       = 1,    //储蓄卡
    creaditBank    = 2,    //信用卡
}BankType;

typedef enum
{
    allVote       = 0,    //全部
    winVote       = 1,    //中奖
    noOpenVote    = 2,    //待开
}VoteRecordType;

#endif
