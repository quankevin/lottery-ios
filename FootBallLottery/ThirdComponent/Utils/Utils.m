//
//  Utils.m
//  FootBallLottery
//
//  Created by jaye on 15/1/2.
//  Copyright (c) 2015年 jaye. All rights reserved.
//

#import "Utils.h"
#import <CommonCrypto/CommonDigest.h>
#include "test.c"

@implementation Utils

//时间戳
+ (NSString *)timeStamp {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"]];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString *newDateString = [formatter stringFromDate:[NSDate date]];
    
    return newDateString;
}

//获取当前时间戳
+ (NSString*)getcurrenttime
{
    NSDateFormatter *nsdf = [[NSDateFormatter alloc] init];
    [nsdf setDateStyle:kCFDateFormatterShortStyle];
    [nsdf setDateFormat:@"YYYYMMDDHHmmss"];
    
    NSString *ct=[nsdf stringFromDate:[NSDate date]];
    
    return ct;
}

//md5加密
+ (NSString *)md5:(NSString *)str
{
    const char *cStr = [str UTF8String];
    unsigned char result[16];
    CC_MD5(cStr, strlen(cStr), result); // This is the md5 call
    return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ]; 
}

//密码加密
+ (NSString *)MD5Password:(NSString *)password
{
    const char *mim = [password cStringUsingEncoding:NSASCIIStringEncoding];
    const char *miya = [PasswordKey cStringUsingEncoding:NSASCIIStringEncoding];
    NSString *md5password;
    if (mim != nil) {
        char *mima = hmac_md5(mim,miya);
        md5password = [[NSString alloc] initWithCString:(const char*)mima encoding:NSASCIIStringEncoding];
    }
    return md5password;
}

//根据获取类型返回传入的时间的数据
+ (NSString *)dateDataWithDate:(NSDate *)date
{
    static NSDateFormatter *formatter = nil;
    static NSCalendar *calendar = nil;
    static NSDateComponents *comps = nil;
    static NSInteger unitflags = 0;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        formatter = [[NSDateFormatter alloc] init];
        [formatter setTimeStyle:NSDateFormatterMediumStyle];
        calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
        comps = [[NSDateComponents alloc] init];
        unitflags = NSYearCalendarUnit |
        NSMonthCalendarUnit |
        NSDayCalendarUnit |
        NSWeekdayCalendarUnit |
        NSHourCalendarUnit |
        NSMinuteCalendarUnit |
        NSSecondCalendarUnit;
    });
    
    comps = [calendar components:unitflags fromDate:date];
    int week = [comps weekday];

    week = week - 1;
    if (week == 0)  //根据上面的 1是星期天 7是星期六 所以 －1后等于0的是星期天
    {
        week = 7;
    }
    
    if (week == 1)
        return @"周一";
    if (week == 2)
        return @"周二";
    if (week == 3)
        return @"周三";
    if (week == 4)
        return @"周四";
    if (week == 5)
        return @"周五";
    if (week == 6)
        return @"周六";
    return @"周日";
}

//颜色值
+ (UIColor *) colorWithHexString: (NSString *)color
{
    NSString *cString = [[color stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // String should be 6 or 8 characters
    if ([cString length] < 6) {
        return [UIColor clearColor];
    }
    
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"])
        cString = [cString substringFromIndex:2];
    if ([cString hasPrefix:@"#"])
        cString = [cString substringFromIndex:1];
    if ([cString length] != 6)
        return [UIColor clearColor];
    
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    
    //r
    NSString *rString = [cString substringWithRange:range];
    
    //g
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    //b
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f) green:((float) g / 255.0f) blue:((float) b / 255.0f) alpha:1.0f];
}

+ (NSString *)appVersion {
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    NSString *appVersion = nil;
    NSString *marketingVersionNumber = [bundle objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
    NSString *developmentVersionNumber = [bundle objectForInfoDictionaryKey:@"CFBundleVersion"];
    if (marketingVersionNumber && developmentVersionNumber) {
        if ([marketingVersionNumber isEqualToString:developmentVersionNumber]) {
            appVersion = marketingVersionNumber;
        } else {
            appVersion = [NSString stringWithFormat:@"%@",marketingVersionNumber];
        }
    } else {
        appVersion = (marketingVersionNumber ? marketingVersionNumber : developmentVersionNumber);
    }
    return appVersion;
}

#pragma mark - Find Focus Input View
+ (UIView *)findFocusInputView:(UIView *)view
{
    if ([Utils checkCanGoOn:view]) {
        for (int i = 0; i < view.subviews.count; i++) {
            UIView *subview = [view.subviews objectAtIndex:i];
            if ([subview isKindOfClass:[UITextField class]] ||
                [subview isMemberOfClass:[UITextField class]]) {
                if ([subview isFirstResponder]) {
                    return subview;
                }
            }else if ([subview isKindOfClass:[UITextView class]] ||
                      [subview isMemberOfClass:[UITextView class]]){
                if ([subview isFirstResponder]) {
                    return subview;
                }
            }else if ([self checkCanGoOn:subview]){
                UIView *focusView = [Utils findFocusInputView:subview];
                if (focusView) {
                    return focusView;
                }
            }
        }
    }
    
    return nil;
}

+ (BOOL)checkCanGoOn:(UIView *)view
{
    if ([view isKindOfClass:[UIButton class]] || [view isMemberOfClass:[UIButton class]]) {
        return NO;
    }
    if ([view isKindOfClass:[UIImageView class]] || [view isMemberOfClass:[UIImageView class]]) {
        return NO;
    }
    if ([view isKindOfClass:[UITableView class]] || [view isMemberOfClass:[UITableView class]]) {
        return NO;
    }
    
    return (view.subviews ? YES : NO);
}

#pragma mark - Image
//根据uiview得到图像
+ (UIImage *)getImageFromView:(UIView *)fromView useScreenScale:(BOOL)use
{
    NSInteger scale = use ? kScreenScale : 1;
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(fromView.bounds.size.width, fromView.bounds.size.height), NO, scale);
    [fromView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return viewImage;
}

//根据图像和尺寸截剪图片
+ (UIImage *)getImageFormImage:(UIImage *)fromView withRect:(CGRect)rect useScreenScale:(BOOL)use
{
    NSInteger scale = use ? kScreenScale : 1;
    CGRect scaleRect = CGRectMake(rect.origin.x * scale, rect.origin.y * scale, rect.size.width * scale, rect.size.height * scale); //得到剪切部分的图片的scale后的rect
    CGImageRef imageRef = CGImageCreateWithImageInRect([fromView CGImage], scaleRect);
    UIImage *avatarImage = [[UIImage alloc] initWithCGImage:imageRef scale:scale orientation:UIImageOrientationUp];
    CFRelease(imageRef);
    return avatarImage;
}

//根据图像和分隔的总等份分隔图像
+ (NSArray *)getSplitImageListWithImage:(UIImage *)image withCount:(NSInteger)count
{
    CGFloat height = image.size.height / count;
    NSMutableArray *arrayImage = [NSMutableArray arrayWithCapacity:count];
    for (int i = 0; i < count; i++)
    {
        UIImage *imgSplit = [self getImageFormImage:image withRect:CGRectMake(0, i*height, image.size.width, height) useScreenScale:NO];
        [arrayImage addObject:imgSplit];
    }
    return arrayImage;
}

//图像合并成一张
+ (UIImage*)compoundImageWithSize:(CGSize)imageSize
                    withMainImage:(UIImage *)MainImage
                withMainImageRect:(CGRect)mainImageRect
                     withSubImage:(UIImage *)subImage
                 withSubImageRect:(CGRect) subImageRect
{
    UIGraphicsBeginImageContext(imageSize);
    
    [MainImage drawInRect:mainImageRect];
    [subImage drawInRect:subImageRect];
    
    UIImage *resultingImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return resultingImage;
}

//展示信息
+ (void)showToastWihtMessage:(NSString *)message {
    
    UIView *mainView = nil;
    
    if ([[[UIApplication sharedApplication] windows] count]>1) {
        mainView = [[[UIApplication sharedApplication] windows] objectAtIndex:1];
    }
    else {
        mainView = [[[UIApplication sharedApplication] windows] objectAtIndex:0];
    }
    
    MBProgressHUD *tip = [[MBProgressHUD alloc] initWithFrame:CGRectMake(0,
                                                                         mainView.frame.size.height/2.0 ,
                                                                         mainView.frame.size.width,
                                                                         mainView.frame.size.height/2.0)];
    tip.yOffset += tip.frame.size.height/2.0;
    [mainView addSubview:tip];
    tip.labelText = message;
    
    tip.mode = MBProgressHUDModeCustomView;
    tip.removeFromSuperViewOnHide = YES;
    [tip show:YES];
    [tip hide:YES afterDelay:1];
}

+ (void)showMessage:(NSString *)message
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:message delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alertView show];
}

+ (NSString *)getPriousDateFromDate:(NSDate *)date withMonth:(int)month
{
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    [comps setMonth:month];
    NSCalendar *calender = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDate *mDate = [calender dateByAddingComponents:comps toDate:date options:0];
    
    NSDateFormatter *formatter = [[NSDateFormatter  alloc ]  init ];
    [formatter setDateFormat:@"yyyy-MM-dd"];

    return [formatter stringFromDate:mDate];
}

//判断手机号码是否正确
+ (BOOL) isValidateMobile:(NSString *)mobile
{
    //手机号以13， 15，18开头，八个 \d 数字字符
    NSString *phoneRegex = @"^((13[0-9])|(15[^4,\\D])|(18[0,0-9]))\\d{8}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    return [phoneTest evaluateWithObject:mobile];
}

//验证身份证是否合法
+ (BOOL)checkIdentityCardNo:(NSString*)cardNo
{
    if (cardNo.length != 18) {
        return  NO;
    }
    
    NSArray* codeArray = [NSArray arrayWithObjects:@"7",@"9",@"10",@"5",@"8",@"4",@"2",@"1",@"6",@"3",@"7",@"9",@"10",@"5",@"8",@"4",@"2", nil];
    NSDictionary* checkCodeDic = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:@"1",@"0",@"X",@"9",@"8",@"7",@"6",@"5",@"4",@"3",@"2", nil]  forKeys:[NSArray arrayWithObjects:@"0",@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10", nil]];
    
    NSScanner* scan = [NSScanner scannerWithString:[cardNo substringToIndex:17]];
    
    int val;
    BOOL isNum = [scan scanInt:&val] && [scan isAtEnd];
    if (!isNum) {
        return NO;
    }
    int sumValue = 0;
    
    for (int i =0; i<17; i++) {
        sumValue+=[[cardNo substringWithRange:NSMakeRange(i , 1) ] intValue]* [[codeArray objectAtIndex:i] intValue];
    }
    
    NSString* strlast = [checkCodeDic objectForKey:[NSString stringWithFormat:@"%d",sumValue%11]];
    
    if ([strlast isEqualToString: [[cardNo substringWithRange:NSMakeRange(17, 1)]uppercaseString]]) {
        return YES;
    }
    return  NO;
}

//校验用户名
+ (BOOL) validateUserName:(NSString *)str {
    NSRegularExpression *regularexpression = [[NSRegularExpression alloc]
                                              initWithPattern:@"^(\\w+)|([\u0391-\uFFE5]+)$"
                                              options:NSRegularExpressionCaseInsensitive
                                              error:nil];
    NSUInteger numberofMatch = [regularexpression numberOfMatchesInString:str
                                                                  options:NSMatchingReportProgress
                                                                    range:NSMakeRange(0, str.length)];
    
    if(numberofMatch > 0)
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

//校验邮箱
+ (BOOL) validateUserEmail:(NSString *)str {
    NSRegularExpression *regularexpression = [[NSRegularExpression alloc]
                                              initWithPattern:@"\\w+([-+.]\\w+)*@\\w+([-.]\\w+)*\\.\\w+([-.]\\w+)*"
                                              options:NSRegularExpressionCaseInsensitive
                                              error:nil];
    NSUInteger numberofMatch = [regularexpression numberOfMatchesInString:str
                                                                  options:NSMatchingReportProgress
                                                                    range:NSMakeRange(0, str.length)];
    if(numberofMatch > 0)
    {
        
        return YES;
    }
    return NO;
}

@end
