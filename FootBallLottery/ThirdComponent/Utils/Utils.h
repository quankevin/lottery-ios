//
//  Utils.h
//  FootBallLottery
//
//  Created by jaye on 15/1/2.
//  Copyright (c) 2015年 jaye. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CTBaseDialogView.h"
#import "MBProgressHUD.h"


@interface Utils : NSObject

//时间戳
+ (NSString *)timeStamp;

//获取当前时间戳
+ (NSString*)getcurrenttime;

//md5加密
+ (NSString*) md5:(NSString *)unmd5;

//密码加密
+ (NSString *)MD5Password:(NSString *)password;

//根据获取类型返回传入的时间的数据
+ (NSString *)dateDataWithDate:(NSDate *)date;

//16进制颜色值
+ (UIColor *) colorWithHexString: (NSString *)color;

//获取版本号
+ (NSString *)appVersion;

//判断距离今天几个月的时间戳
+ (NSString *)getPriousDateFromDate:(NSDate *)date withMonth:(int)month;

//展示信息
+ (void)showToastWihtMessage:(NSString *)message;

+ (void)showMessage:(NSString *)message;

//判断手机号码是否正确
+ (BOOL) isValidateMobile:(NSString *)mobile;

//验证身份证是否合法
+ (BOOL)checkIdentityCardNo:(NSString*)cardNo;

//校验用户名
+ (BOOL) validateUserName:(NSString *)str;

//校验邮箱
+ (BOOL) validateUserEmail:(NSString *)str;

// Find Focus Input View
+ (UIView *)findFocusInputView:(UIView *)view;
+ (BOOL)checkCanGoOn:(UIView *)view;

/////
//根据uiview得到图像
+ (UIImage *)getImageFromView:(UIView *)fromView useScreenScale:(BOOL)use;
//根据图像和尺寸截剪图片
+ (UIImage *)getImageFormImage:(UIImage *)fromView withRect:(CGRect)rect useScreenScale:(BOOL)use;
//根据图像和分隔的总等份分隔图像
+ (NSArray *)getSplitImageListWithImage:(UIImage *)image withCount:(NSInteger)count;
//图像合并成一张
+ (UIImage*)compoundImageWithSize:(CGSize)imageSize
                    withMainImage:(UIImage *)MainImage
                withMainImageRect:(CGRect)mainImageRect
                     withSubImage:(UIImage *)subImage
                 withSubImageRect:(CGRect) subImageRect;

@end
