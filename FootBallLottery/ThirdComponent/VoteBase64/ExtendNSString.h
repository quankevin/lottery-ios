//
//  Util.h
//  FPRestaurant
//
//  Created by xjm on 15-1-24.
//  Copyright (c) 2015年 maBiao. All rights reserved.
//

#ifndef FPRestaurant_Util_h
#define FPRestaurant_Util_h

//.h
@interface NSString (Util)
#pragma mark - base64
+ (NSString*)encodeBase64String:(NSString *)input;
+ (NSString*)decodeBase64String:(NSString *)input;
+ (NSString*)encodeBase64Data:(NSData *)data;
+ (NSString*)decodeBase64Data:(NSData *)data;

+ (NSString *)md5:(NSString *)str;
@end

#endif
