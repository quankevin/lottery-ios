//
//  JCUtil.h
//  JCUtil
//
//  Created by xjm on 15-1-25.
//  Copyright (c) 2015年 xjm. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JCUtil : NSObject

// 计算投注数
// 格式："HT@63146|RQ=3/1,SP=3/1&63147|RQ=3/1,SP=3/1&63148|RQ=3/1,SP=3/1@2*1,3*1@1"
+ (int) getMultiPassBallotNum: (NSString *)strMatchContent;

// 扰乱URL的参数串
#define SCRAMBLEURL_KEY @"chhbz0xNDAx6"
// 正式发布如果KEY变了直接修改上值
/**
 * URL的参数之间通过&&进行连接(因为可能参数中本身带有&以避免无法区分的问题)
 * urlParam=@"un=kkkk&&pp=1&&pc=HT@61655|SP=3/1/0&61656|SP=3/1/0&61657|SP=3/1/0&61658|SP=3/1/0&61659|SP=3/1/0&61660|SP=3/1/0&61661|SP=3/1/0@2*1,3*1,4*1,5*1@1&&mu=1&&pt=1&&ub=1&&pw=000000";
 */
+ (NSString*) scrambleUrl:(NSString *)urlParam;

// 计算投注数的测试用例
+ (void) testTZ ;
// 扰乱URL的测试用例
+ (NSString*) testScrambleUrl;

@end
