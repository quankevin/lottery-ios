//
//  JCUtil.m
//  JCUtil
//
//  Created by xjm on 14-8-20.
//  Copyright (c) 2015年 XJM. All rights reserved.
//

#import "JCUtil.h"
#import "ExtendNSString.h"

@implementation JCUtil

+ (void) testTZ
{
    JCUtil* obj = [JCUtil alloc];
    int intBallotNum = 0;
    NSString *str1 = @"HT@63134|SP=3&63135|SP=3/1&63136|SP=3/1/0&63137|RQ=3,SP=3/1/0@3*4@1"; // 131 OK
    //var_dump
    NSString *str2 = @"HT@61655|SP=3/1/0&61656|SP=3/1/0&61657|SP=3/1/0&61658|SP=3/1/0&61659|SP=3/1/0&61660|SP=3/1/0&61661|SP=3/1/0@2*1,3*1,6*1,7*1@1"; // 8424 OK
    NSString *str3 = @"HT@63146|SP=1&63147|SP=1@2*1@1"; // 1 OK
    NSString *str4 = @"HT@63146|RQ=3/1,SP=3/1&63147|RQ=3/1,SP=3/1&63148|RQ=3/1,SP=3/1@2*1,3*1@1"; // 112 OK
    NSString *str5 = @"HT@62959|RQ=3/1/0,SP=3/1/0&62960|RQ=3/1/0,SP=3/1/0&62961|RQ=3/1/0,SP=3/1/0&62962|RQ=3/1/0,SP=3/1/0&62963|RQ=3/1/0,SP=3/1/0&62964|RQ=3/1/0,SP=3/1/0&62965|RQ=3/1/0,SP=3/1/0@5*5@1"; // 272160
    NSString *str6 = @"HT@62959|RQ=3/1/0,SP=3/1/0&62960|RQ=3/1/0,SP=3/1/0&62961|RQ=3/1/0,SP=3/1/0&62962|RQ=3/1/0,SP=3/1/0&62963|RQ=3/1/0,SP=3/1/0&62964|RQ=3/1/0,SP=3/1/0@4*6@1";  // 12960 OK
    
    NSString *str7 = @"HT@63092|RQ=1,SP=0&63093|RQ=3,SP=1@2*1@1"; // 4 OK
    
    intBallotNum = [self getMultiPassBallotNum:str6];
    
    intBallotNum = [obj getBallotNum:str4];
    NSLog(@"ballotNum = %d\r\n",intBallotNum);
    
    intBallotNum = [obj getBallotNum:str2];
    NSLog(@"ballotNum = %d\r\n",intBallotNum);
    
    intBallotNum = [obj getBallotNum:str3];
    NSLog(@"ballotNum = %d\r\n",intBallotNum);
    
    intBallotNum = [obj getBallotNum:str4];
    NSLog(@"ballotNum = %d\r\n",intBallotNum);
    
    intBallotNum = [obj getBallotNum:str5];
    NSLog(@"ballotNum = %d\r\n",intBallotNum);
    
    intBallotNum = [obj getBallotNum:str7];
    NSLog(@"ballotNum = %d\r\n",intBallotNum);   
   
}


+ (void) testScrambleUrl
{
    
    // （1）URL的参数之间通过&&进行连接(因为可能参数中本身带有&以避免无法区分的问题)
    // TODO:这个串你自己构造
    NSString *urlParam=@"un=kkkk&&pp=1&&pc=HT@61655|SP=3/1/0&61656|SP=3/1/0&61657|SP=3/1/0&61658|SP=3/1/0&61659|SP=3/1/0&61660|SP=3/1/0&61661|SP=3/1/0@2*1,3*1,4*1,5*1@1&&mu=1&&pt=1&&ub=1&&pw=000000";
    // 这在系统中是定义死的常量，测试时给个值，正式发布的时候修改下
    NSString * str = [self scrambleUrl:urlParam];
    
    NSLog(@"%@",str);
}

/**
 *获取多个过关类型的总的投注数
 * @param $strMatchContent
 * @return int
 * @"HT@63146|RQ=3/1,SP=3/1&63147|RQ=3/1,SP=3/1&63148|RQ=3/1,SP=3/1@2*1,3*1@1"; // 112
 * @throws MyException
 */
+ (int) getMultiPassBallotNum: (NSString *)strMatchContent
{
    JCUtil* obj = [JCUtil alloc];
    int intBallotNum = 0;
    
    NSArray * arrPassType = [obj splitPassType:strMatchContent];
    for (int i=0; i< arrPassType.count;i++) {
        NSString *val = arrPassType[i];
        intBallotNum += [obj getBallotNum:val];
    }

    NSLog(@"ballotNum = %d",intBallotNum);
    
    return intBallotNum;
}

/**
 *拆分投注内容
 * @param $strMatchContent
 * @return array
 * @throws MyException
 */
- (NSDictionary *) getMatchInfo:(NSString *)strMatchContent
{
    // $arrData = array('flag' => '', 'content' => '', 'guoGuanType' => '', 'multiple' => 1);
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    
    NSArray* arrMatchInfo = [self explode:"@" totalstring:strMatchContent];
    if (4 != arrMatchInfo.count) {
        //throw new MyException('方案内容格式不正确', 0);
        NSLog(@"方案内容格式不正确");
        return nil;
    }
   
    [dic setObject:[arrMatchInfo objectAtIndex:0] forKey:@"flag"];
    [dic setObject:[arrMatchInfo objectAtIndex:1] forKey:@"content"];
    [dic setObject:[arrMatchInfo objectAtIndex:2] forKey:@"gouGuanType"];
    [dic setObject:[arrMatchInfo objectAtIndex:3] forKey:@"multiple"];
   
    return dic;
}

/**
 *将多串玩法投注内容拆分
 * @param $strMatchContent
 * @return array
 * @throws MyException
 */
- (NSArray *) getMatchs :(NSString *)strMatchContent
{
    NSMutableArray *arrMatchs = [NSMutableArray arrayWithCapacity:0];
    NSDictionary *matchInfo = [self getMatchInfo:strMatchContent];
    //比赛场次数
    NSArray *content = [self explode:"&" totalstring:[matchInfo objectForKey:@"content"] ];
    int matchNum = content.count;
    
    //过关类型
    NSString *type = [matchInfo objectForKey:@"gouGuanType"];
    NSArray *guoGuanTpye = [self explode:"*" totalstring:type ];
    int guoGuanNum = [[guoGuanTpye objectAtIndex:0] intValue];
    NSArray *arrPaiLie = [self combine:matchNum intLen:guoGuanNum];
    
    for (int i=0;i<arrPaiLie.count;i++) {
        NSArray * oneLayer  = [arrPaiLie objectAtIndex:i];
        for (int j=0;j<oneLayer.count;j++) {
            NSNumber* nsI = [oneLayer objectAtIndex:j];
            if (0 == j) {
                [arrMatchs addObject: [content objectAtIndex:[nsI intValue]]];
            } else {
                NSString* str = [arrMatchs objectAtIndex:i];
                str = [NSString stringWithFormat:@"%@%c%@", str, '&', [content objectAtIndex:[nsI intValue]] ];
                [arrMatchs replaceObjectAtIndex:i withObject:str];
            }
        }
    }
    
    for (int i = 0;i<arrMatchs.count;i++) {
        NSString * mVal = [arrMatchs objectAtIndex:i];
        NSString* str = [NSString stringWithFormat:@"%@%c%@%c%@%c%@",[matchInfo objectForKey:@"flag"],
                          '@',mVal, '@',type,'@',[matchInfo objectForKey:@"multiple"]];
        [arrMatchs replaceObjectAtIndex:i withObject:str];
        
    }
    return arrMatchs;
}

/**
 *混投注数（带重复）
 * @param $strMatchContent
 * @return int
 * @throws MyException
 */
- (int) getBallotNum: (NSString *)strMatchContent
{
    NSArray* matchs = [self getMatchs:strMatchContent];
    int intBallotNum = 0;
    for (NSString *match in matchs) {
        intBallotNum += [self getHtBallotDuplite:match];
    }
    return intBallotNum;
}

- (int) getHtBallotDuplite :(NSString *)strContent
{
    int intBallot = 0;
    NSMutableArray* arrContents =  [NSMutableArray arrayWithCapacity:0];
    
    //将投注内容解析为单一场次只有一种玩法的投注内容
    NSArray *arrContent = [self explode:"@" totalstring:strContent ];
    if (4 != arrContent.count) {
        //throw new MyException('投注内容格式不正确', 0);
        NSLog(@"投注内容格式不正确");
        return 0;
    }
    
    NSArray *arrContentInfo = [self explode:"&" totalstring:[arrContent objectAtIndex:1]];
    NSMutableArray *content = [NSMutableArray arrayWithCapacity:0];
    //拆分
    for (int i=0;i<arrContentInfo.count;i++) {
        NSString * infoVal  = [arrContentInfo objectAtIndex:i];
        NSArray *info = [self explode :"|" totalstring:infoVal ];
        if (2 != info.count) {
            //throw new MyException('方案内容格式不正确', 0);
            NSLog(@"方案内容格式不正确");
            return 0;
        }
        
        NSString *matchId = [info objectAtIndex:0];
        NSArray *playTypes = [self explode:"," totalstring:[info objectAtIndex:1]];
        
        NSMutableArray *contentElem = [NSMutableArray arrayWithCapacity:0];
        for (NSString * type in playTypes) {
            NSString *str= [NSString stringWithFormat:@"%@%c%@",matchId,'|',type];
            [contentElem  addObject: str];
        }
        [content addObject:contentElem];
    }
    
    //        var_dump($content);exit;
    NSArray *matchContent = [self fun:content first:1];
    
    //        var_dump($matchContent);
    //        exit;
    for (int i=0;i<matchContent.count;i++) {
        NSArray *mVal =[matchContent objectAtIndex:i];
        NSString *str = @"";
        for (int j=0;j<mVal.count;j++) {
            NSString * val =[mVal objectAtIndex:j];
            if (0 == j) {
                str = val;
            } else {
                str = [NSString stringWithFormat:@"%@%c%@",str,'&',val];
            }
        }
        
        str = [NSString stringWithFormat:@"%@%c%@%c%@%c%@",[arrContent objectAtIndex:0],'@',str,'@',[arrContent objectAtIndex:2],'@',[arrContent objectAtIndex:3]];
        [arrContents addObject:str];
    }
    
    //计算注数
    for (int i=0;i<arrContents.count;i++) {
        NSString * aVal = [arrContents objectAtIndex:i];
        NSDictionary *matchCountent = [self getHtMatchContent:aVal];
        NSArray * arrChangCi = [matchCountent objectForKey:@"arrChangCi"] ;
        NSArray * arrGuoGuanType = [matchCountent objectForKey:@"passTypes"];
        intBallot += [self getProjectNum: arrChangCi arrGuoGuanType:arrGuoGuanType] ;
    }
    return intBallot;
}

- (int) getProjectNum: (NSArray *) arrChangCi arrGuoGuanType: (NSArray *)arrGuoGuanType
{
    int intTotalNum = 0;
    for (int i=0;i< arrGuoGuanType.count;i++) {
        NSString * guoGuanType = [arrGuoGuanType objectAtIndex:i];
        NSMutableArray *arrType = [self getPassDetail:guoGuanType];
        
        for (int j=0;j<arrType.count;j++) {
            NSString * str = [NSString stringWithFormat:@"%@*1",[arrType objectAtIndex:j]];
            [arrType replaceObjectAtIndex:j withObject:str];
        }
        
        intTotalNum += [self getProjectTotalNumber:arrChangCi arrGuoGuanType:arrType];
    }
    return intTotalNum;
}

- (NSMutableArray *) getPassDetail:(NSString *) passType
{
    
    if ([passType isEqualToString:@"单关"] || [passType isEqualToString:@"1*1"]) {
        //$atier = array(1);
        //return array(1, $atier);
        
        NSMutableArray *atier = [NSMutableArray arrayWithCapacity:0];
        [atier addObject:[NSNumber numberWithInt:1]];
        return atier;
    } else if ([passType isEqualToString:@"2*1"]) {
        //$atier = array(2);
        //return array(2, $atier);
        
        NSMutableArray *atier = [NSMutableArray arrayWithCapacity:0];
        [atier addObject:[NSNumber numberWithInt:2]];
        return atier;
    } else if ([passType isEqualToString:@"3*1"]) {
        //$atier = array(3);
        //return array(3, $atier);
        
        NSMutableArray *atier = [NSMutableArray arrayWithCapacity:0];
        [atier addObject:[NSNumber numberWithInt:3]];
        return atier;
    } else if ([passType isEqualToString:@"3*3"]) {
        //$atier = array(2);
        //return array(3, $atier);
        
        NSMutableArray *atier = [NSMutableArray arrayWithCapacity:0];
        [atier addObject:[NSNumber numberWithInt:2]];
        return atier;
    } else if ([passType isEqualToString:@"3*4"]) {
        //$atier = array(2, 3);
        //return array(3, $atier);
        
        NSMutableArray *atier = [NSMutableArray arrayWithCapacity:0];
        [atier addObject:[NSNumber numberWithInt:2]];
        [atier addObject:[NSNumber numberWithInt:3]];
        return atier;
    } else if ([passType isEqualToString:@"4*1"]) {
        //$atier = array(4);
        //return array(4, $atier);
        
        NSMutableArray *atier = [NSMutableArray arrayWithCapacity:0];
        [atier addObject:[NSNumber numberWithInt:4]];
        return atier;

    } else if ([passType isEqualToString:@"4*4"]) {
        //$atier = array(3);
        //return array(4, $atier);
        
        NSMutableArray *atier = [NSMutableArray arrayWithCapacity:0];
        [atier addObject:[NSNumber numberWithInt:3]];
        return atier;

    } else if ([passType isEqualToString:@"4*5"]) {
        //$atier = array(3, 4);
        //return array(4, $atier);
        
         NSMutableArray *atier = [NSMutableArray arrayWithCapacity:0];
        [atier addObject:[NSNumber numberWithInt:3]];
        [atier addObject:[NSNumber numberWithInt:4]];
        return atier;

    } else if ([passType isEqualToString:@"4*6"]) {
        //$atier = array(2);
        //return array(4, $atier);
        
        NSMutableArray *atier = [NSMutableArray arrayWithCapacity:0];
        [atier addObject:[NSNumber numberWithInt:2]];
        return atier;

    } else if ([passType isEqualToString:@"4*11"]) {
        //$atier = array(2, 3, 4);
        //return array(4, $atier);
        NSMutableArray *atier = [NSMutableArray arrayWithCapacity:0];
        
        [atier addObject:[NSNumber numberWithInt:2]];
        [atier addObject:[NSNumber numberWithInt:3]];
        [atier addObject:[NSNumber numberWithInt:4]];
        return atier;
    } else if ([passType isEqualToString:@"5*1"]) {
        //$atier = array(5);
        //return array(5, $atier);
        
        NSMutableArray *atier = [NSMutableArray arrayWithCapacity:0];
        [atier addObject:[NSNumber numberWithInt:5]];
        return atier;

    } else if ([passType isEqualToString:@"5*5"]) {
        //$atier = array(4);
        //return array(5, $atier);
        
        NSMutableArray *atier = [NSMutableArray arrayWithCapacity:0];
        [atier addObject:[NSNumber numberWithInt:4]];
        return atier;

    } else if ([passType isEqualToString:@"5*6"]) {
        //$atier = array(4, 5);
        //return array(5, $atier);
        
        NSMutableArray *atier = [NSMutableArray arrayWithCapacity:0];
        [atier addObject:[NSNumber numberWithInt:4]];
        [atier addObject:[NSNumber numberWithInt:5]];
        return atier;
    } else if ([passType isEqualToString:@"5*10"]) {
        //$atier = array(2);
        //return array(5, $atier);
        
        NSMutableArray *atier = [NSMutableArray arrayWithCapacity:0];
        [atier addObject:[NSNumber numberWithInt:2]];
        return atier;

    } else if ([passType isEqualToString:@"5*16"]) {
        //$atier = array(3, 4, 5);
        //return array(5, $atier);
        
        NSMutableArray *atier = [NSMutableArray arrayWithCapacity:0];
        [atier addObject:[NSNumber numberWithInt:3]];
        [atier addObject:[NSNumber numberWithInt:4]];
        [atier addObject:[NSNumber numberWithInt:5]];
        return atier;
    } else if ([passType isEqualToString:@"5*20"]) {
        //$atier = array(2, 3);
        //return array(5, $atier);
        
        NSMutableArray *atier = [NSMutableArray arrayWithCapacity:0];
        [atier addObject:[NSNumber numberWithInt:2]];
        [atier addObject:[NSNumber numberWithInt:3]];
        return atier;
    } else if ([passType isEqualToString:@"5*26"]) {
        //$atier = array(2, 3, 4, 5);
        //return array(5, $atier);
        
        NSMutableArray *atier = [NSMutableArray arrayWithCapacity:0];
        [atier addObject:[NSNumber numberWithInt:2]];
        [atier addObject:[NSNumber numberWithInt:3]];
        [atier addObject:[NSNumber numberWithInt:4]];
        [atier addObject:[NSNumber numberWithInt:5]];
        return atier;

    } else if ([passType isEqualToString:@"6*1"]) {
        //$atier = array(6);
        //return array(6, $atier);
        
        NSMutableArray *atier = [NSMutableArray arrayWithCapacity:0];
        [atier addObject:[NSNumber numberWithInt:6]];
        return atier;

    } else if ([passType isEqualToString:@"6*6"]) {
        //$atier = array(5);
        //return array(6, $atier);
       
        NSMutableArray *atier = [NSMutableArray arrayWithCapacity:0];
        [atier addObject:[NSNumber numberWithInt:5]];
        return atier;

    } else if ([passType isEqualToString:@"6*7"]) {
        //$atier = array(5, 6);
        //return array(6, $atier);
       
        NSMutableArray *atier = [NSMutableArray arrayWithCapacity:0];
        [atier addObject:[NSNumber numberWithInt:5]];
        [atier addObject:[NSNumber numberWithInt:6]];
        return atier;

    } else if ([passType isEqualToString:@"6*15"]) {
        //$atier = array(2);
        //return array(6, $atier);
        
        NSMutableArray *atier = [NSMutableArray arrayWithCapacity:0];
        [atier addObject:[NSNumber numberWithInt:2]];
        return atier;

    } else if ([passType isEqualToString:@"6*20"]) {
        //$atier = array(3);
        //return array(6, $atier);
       
        NSMutableArray *atier = [NSMutableArray arrayWithCapacity:0];
        [atier addObject:[NSNumber numberWithInt:3]];
        return atier;

    } else if ([passType isEqualToString:@"6*22"]) {
        //$atier = array(4, 5, 6);
        //return array(6, $atier);
      
        NSMutableArray *atier = [NSMutableArray arrayWithCapacity:0];
        [atier addObject:[NSNumber numberWithInt:4]];
        [atier addObject:[NSNumber numberWithInt:5]];
        [atier addObject:[NSNumber numberWithInt:6]];
        return atier;

    } else if ([passType isEqualToString:@"6*35"]) {
        //$atier = array(2, 3);
        //return array(6, $atier);
    
        NSMutableArray *atier = [NSMutableArray arrayWithCapacity:0];
        [atier addObject:[NSNumber numberWithInt:2]];
        [atier addObject:[NSNumber numberWithInt:3]];
         return atier;

    } else if ([passType isEqualToString:@"6*42"]) {
        //$atier = array(3, 4, 5, 6);
        //return array(6, $atier);
   
        NSMutableArray *atier = [NSMutableArray arrayWithCapacity:0];
        [atier addObject:[NSNumber numberWithInt:3]];
        [atier addObject:[NSNumber numberWithInt:4]];
        [atier addObject:[NSNumber numberWithInt:5]];
        [atier addObject:[NSNumber numberWithInt:6]];
        return atier;

    } else if ([passType isEqualToString:@"6*50"]) {
        //$atier = array(2, 3, 4);
        //return array(6, $atier);
  
        NSMutableArray *atier = [NSMutableArray arrayWithCapacity:0];
        [atier addObject:[NSNumber numberWithInt:2]];
        [atier addObject:[NSNumber numberWithInt:3]];
        [atier addObject:[NSNumber numberWithInt:4]];
        [atier addObject:atier];
        return atier;

    } else if ([passType isEqualToString:@"6*57"]) {
        //$atier = array(2, 3, 4, 5, 6);
        //return array(6, $atier);
        NSMutableArray *atier = [NSMutableArray arrayWithCapacity:0];
        [atier addObject:[NSNumber numberWithInt:2]];
        [atier addObject:[NSNumber numberWithInt:3]];
        [atier addObject:[NSNumber numberWithInt:4]];
        [atier addObject:[NSNumber numberWithInt:5]];
        [atier addObject:[NSNumber numberWithInt:6]];
        return atier;

    } else if ([passType isEqualToString:@"7*1"]) {
        //$atier = array(7);
        //return array(7, $atier);
        
        NSMutableArray *atier = [NSMutableArray arrayWithCapacity:0];
        [atier addObject:[NSNumber numberWithInt:7]];
        return atier;

    } else if ([passType isEqualToString:@"7*7"]) {
        //$atier = array(6);
        //return array(7, $atier);
         NSMutableArray *atier = [NSMutableArray arrayWithCapacity:0];
        [atier addObject:[NSNumber numberWithInt:6]];
        return atier;

    } else if ([passType isEqualToString:@"7*8"]) {
        //$atier = array(6, 7);
        //return array(7, $atier);
     
        NSMutableArray *atier = [NSMutableArray arrayWithCapacity:0];
        [atier addObject:[NSNumber numberWithInt:6]];
        [atier addObject:[NSNumber numberWithInt:7]];
         return atier;

    } else if ([passType isEqualToString:@"7*21"]) {
        //$atier = array(5);
        //return array(7, $atier);
        NSMutableArray *atier = [NSMutableArray arrayWithCapacity:0];
        [atier addObject:[NSNumber numberWithInt:5]];
         return atier;

    } else if ([passType isEqualToString:@"7*35"]) {
        //$atier = array(4);
        //return array(7, $atier);
    
        NSMutableArray *atier = [NSMutableArray arrayWithCapacity:0];
        [atier addObject:[NSNumber numberWithInt:4]];
        return atier;

    } else if ([passType isEqualToString:@"7*120"]) {
        //$atier = array(2, 3, 4, 5, 6, 7);
        //return array(7, $atier);
    
        NSMutableArray *atier = [NSMutableArray arrayWithCapacity:0];
        [atier addObject:[NSNumber numberWithInt:2]];
        [atier addObject:[NSNumber numberWithInt:3]];
        [atier addObject:[NSNumber numberWithInt:4]];
        [atier addObject:[NSNumber numberWithInt:5]];
        [atier addObject:[NSNumber numberWithInt:6]];
        [atier addObject:[NSNumber numberWithInt:7]];
        return atier;

    } else if ([passType isEqualToString:@"8*1"]) {
        //$atier = array(8);
        //return array(8, $atier);
   
        NSMutableArray *atier = [NSMutableArray arrayWithCapacity:0];
        [atier addObject:[NSNumber numberWithInt:8]];
        return atier;

    } else if ([passType isEqualToString:@"8*8"]) {
        //$atier = array(7);
        //return array(8, $atier);
   
        NSMutableArray *atier = [NSMutableArray arrayWithCapacity:0];
        [atier addObject:[NSNumber numberWithInt:7]];
        return atier;

    } else if ([passType isEqualToString:@"8*9"]) {
        //$atier = array(7, 8);
        //return array(8, $atier);
   
        NSMutableArray *atier = [NSMutableArray arrayWithCapacity:0];
        [atier addObject:[NSNumber numberWithInt:7]];
        [atier addObject:[NSNumber numberWithInt:8]];
        return atier;

    } else if ([passType isEqualToString:@"8*28"]) {
        //$atier = array(6);
        //return array(8, $atier);
  
        NSMutableArray *atier = [NSMutableArray arrayWithCapacity:0];
        [atier addObject:[NSNumber numberWithInt:6]];
        [atier addObject:atier];
        return atier;

    } else if ([passType isEqualToString:@"8*56"]) {
        //$atier = array(5);
        //return array(8, $atier);
   
        NSMutableArray *atier = [NSMutableArray arrayWithCapacity:0];
        [atier addObject:[NSNumber numberWithInt:5]];
        return atier;

    } else if ([passType isEqualToString:@"8*70"]) {
        //$atier = array(4);
        //return array(8, $atier);
        
        NSMutableArray *atier = [NSMutableArray arrayWithCapacity:0];
        [atier addObject:[NSNumber numberWithInt:4]];
        return atier;

    } else if ([passType isEqualToString:@"8*247"]) {
        //$atier = array(2, 3, 4, 5, 6, 7, 8);
        //return array(8, $atier);
 
        NSMutableArray *atier = [NSMutableArray arrayWithCapacity:0];
        [atier addObject:[NSNumber numberWithInt:2]];
        [atier addObject:[NSNumber numberWithInt:3]];
        [atier addObject:[NSNumber numberWithInt:4]];
        [atier addObject:[NSNumber numberWithInt:5]];
        [atier addObject:[NSNumber numberWithInt:6]];
        [atier addObject:[NSNumber numberWithInt:7]];
        [atier addObject:[NSNumber numberWithInt:8]];
        return atier;

    } else {
        //return array(0, array());
        //		throw new MyException("过关方式不存在", 1);
   
        NSMutableArray *atier = [NSMutableArray arrayWithCapacity:0];
        return atier;
    }
}

/**
 * 根据比赛场次和过关方式，计算方案总注数
 * @param $arrChangCi array(2,3)两场比赛，玩法分别有2种和3种
 * @param $arrGuoGuanType array('1*1','2*1')过关方式
 * @return int
 */
- (int) getProjectTotalNumber:(NSArray *) arrChangCi arrGuoGuanType:(NSArray *)arrGuoGuanType
{
    int intSum = arrChangCi.count;
    
    int intAllDanGeZhuHe = 0;
    
    for (int i = 0; i < arrGuoGuanType.count; i++) {
        NSString *strGuoGuanType = [arrGuoGuanType objectAtIndex:i];
        NSArray *arrSubGuoGuanType = [self explode:"*" totalstring:strGuoGuanType ];
        int intLen = atoi([[arrSubGuoGuanType objectAtIndex:0] UTF8String]);
        int intZhuShu = atoi([[arrSubGuoGuanType objectAtIndex:1]UTF8String]);
        NSArray *arrCombine = [self combine:intSum intLen:intLen];
        
        int intSumDanGeZhuHe = 0;
        for (int j = 0; j < arrCombine.count; j++) {
            NSArray * oneLayer = [arrCombine objectAtIndex:j];
            int intDanGeZhuHe = 1;
            for (int k = 0; k < oneLayer.count; k++) {
                int intIndex = [[oneLayer objectAtIndex:k] intValue];
                intDanGeZhuHe *= [[arrChangCi objectAtIndex:intIndex] intValue];
            }
            intSumDanGeZhuHe += intDanGeZhuHe;
        }
        intAllDanGeZhuHe += intSumDanGeZhuHe * intZhuShu;
    }
    
    return intAllDanGeZhuHe;
}

/**
 *解析混投投注内容
 * @param $strMatchContent投注内容
 * @return array('type' => '', 'passTypes' => '', 'sumMatch' => '', 'arrMatchs' => '','arrMatchPlayType' => '','sumPassType' => '', 'arrChangCi' => '','mutiple' => '');
 */
- (NSDictionary*) getHtMatchContent:(NSString *) strMatchContent
{
    //$returnData = array('type' => '', 'passTypes' => '', 'sumMatch' => '', 'arrMatchs' => '', 'arrMatchPlayType' => '', 'sumPassType' => '', 'arrChangCi' => '', 'mutiple' => '');
    NSMutableDictionary *returnData = [NSMutableDictionary dictionary];
    NSMutableDictionary *changCi =[NSMutableDictionary dictionary];
    NSMutableArray *arrMatchs = [NSMutableArray arrayWithCapacity:0];
    NSMutableArray *arrMatchPlayType = [NSMutableArray arrayWithCapacity:0];
    
    if (strMatchContent == nil || strMatchContent.length == 0) {
        return false;
    }
    
    NSArray *matchContent = [self explode:"@" totalstring:strMatchContent ];
    if (4 != matchContent.count) {
        return false; //投注内容格式不正确
    }
    
    [returnData setObject:[matchContent objectAtIndex:0] forKey:@"type"];
    
    NSArray * passTypes = [self explode:"," totalstring:[matchContent objectAtIndex:2] ];
    [returnData setObject: passTypes forKey:@"passTypes"];
    
    [returnData setObject:[NSNumber numberWithInt:passTypes.count] forKey:@"sumPassType"];
    
    [returnData setObject:[matchContent objectAtIndex:3] forKey:@"mutiple"];
    
    NSArray *arrContent = [self explode:"&"  totalstring:[matchContent objectAtIndex:1] ];
    [returnData setObject:[NSNumber numberWithInt:arrContent.count] forKey:@"sumMatch"];
    
    for (NSString * contVal in arrContent) {
        NSArray *contents = [self explode:"|" totalstring:contVal ];
        if (2 != contents.count) {
            return false;
        }
        
        NSString *matchId = [contents objectAtIndex:0];

        if (![self in_array: matchId arr:arrMatchs]) {
            [arrMatchs addObject:matchId];
        }
        
        NSArray* content = [self explode:"," totalstring:[contents objectAtIndex:1] ];
  
        for (int i= 0; i<content.count; i++) {
            NSString * con = [content objectAtIndex:i];
            NSArray *match = [self explode :"=" totalstring:con ];;
            if (2 != match.count) {
                return false;
            }
            // TODO: 这段代码好像没用到
            //NSString* playType = [match objectAtIndex:0];
            NSArray *matchInfo = [self explode:"/" totalstring:[match objectAtIndex:1]  ];
            
            if ([self array_key_exists:matchId dict:changCi]) {
                int sum = [[changCi objectForKey:matchId] intValue];
                sum += matchInfo.count;
                [changCi setObject:[NSNumber numberWithInt:sum]forKey:matchId];
                
                //$changCi[$matchId] += count($matchInfo);
            } else {
                //$changCi[$matchId] = count($matchInfo);
                
                [changCi setObject:[NSNumber numberWithInt:matchInfo.count]forKey:matchId];
            }
            
            // TODO: 这段代码好像没用到
            //$matchPlayType = array($matchId => $playType);
            //if (!in_array($matchPlayType, $arrMatchPlayType)) {
            //    $arrMatchPlayType[] = $matchPlayType;
            //}
        }
      }

    NSMutableArray *arrChangCi = [NSMutableArray arrayWithCapacity:0];
    
    for (id akey in [changCi allKeys]) {
        
        NSNumber *num= (NSNumber *)[changCi objectForKey:akey];
        
        [arrChangCi addObject:num];
    }
    
    [returnData setObject:arrMatchs forKey:@"arrMatchs"];
    // TODO: 这段代码好像没用到
    //[returnData setObject:arrMatchPlayType forKey:@"arrMatchPlayType"];
    [returnData setObject:arrChangCi forKey:@"arrChangCi"];
    
    return returnData;
}

- (NSArray *) explode:(char*)splitchar totalstring:(NSString *)totalstring
{
    NSMutableArray *arrmSplit = [NSMutableArray arrayWithCapacity:0];
    char *p = malloc(totalstring.length +1);
    char *pFree = p;
    
    strcpy(p, [totalstring UTF8String]);
    
    char *buf = strstr(p, splitchar);
    NSString *str = nil;
    
	while( buf != NULL )
	{
		buf[0]='\0';
//		printf( "%s\n ", p);
       
        str=[NSString stringWithCString:p encoding:NSUTF8StringEncoding];
        [arrmSplit addObject:str];
        
		p = buf + strlen(splitchar);
		/* Get next token: */
		buf = strstr( p, splitchar);
    }
    
    str=[NSString stringWithCString:p encoding:NSUTF8StringEncoding];
    [arrmSplit addObject:str];
    
    free(pFree);
    return arrmSplit;
}


/**
 *排列组合
 * @param $res
 * @param $index
 * @param $arr
 * @param $intLen
 * @param $boolFirstCall
 * @return array
 */

//static int g_total = 0;
static NSMutableArray *g_b = nil;

- (NSMutableArray *)format:(NSMutableArray *)a index:(int)index arr:(NSMutableArray *)arr intLen:(int)intLen boolFirstCall:(bool) boolFirstCall
{

    //NSLog(@"a=%@\r\n",a);
    //NSLog(@"index=%d\r\n",index);
    //NSLog(@"b=%@\r\n",g_b);

    if (boolFirstCall == true) {
        //g_total = 0;
        g_b = [NSMutableArray arrayWithCapacity:0];
        boolFirstCall = false;
    }
    
    NSMutableArray * new_a = [NSMutableArray arrayWithCapacity:0];
    [new_a addObjectsFromArray:a];
    
    if (index == arr.count) {
        if (new_a.count == intLen) {
            NSMutableArray * new_a_tmp =[NSMutableArray arrayWithCapacity:0];
            [new_a_tmp addObjectsFromArray:new_a];
            [g_b addObject:new_a_tmp];
            //g_total++;
        }
        return nil;
    }
    [self format:new_a index:index + 1 arr:arr intLen:intLen boolFirstCall:boolFirstCall];
    [new_a addObject: arr[index]];
    [self format:new_a index:index + 1 arr:arr intLen:intLen boolFirstCall:boolFirstCall];
    return g_b;
}
/**
 *排列组合算法
 * @param $intSum
 * @param $intLen
 * @return array
 */
- (NSArray *) combine:(int)intSum intLen:(int)intLen
{
    NSMutableArray* arr = [NSMutableArray arrayWithCapacity:0];
    
    for (int i = 0; i < intSum; i++) {
        NSNumber* nsI = [NSNumber numberWithInt:i];
        arr[i] = nsI;
    }
    
    NSMutableArray* a = [NSMutableArray arrayWithCapacity:0];
    bool boolFirstCall = true;
    NSMutableArray *b = [self format:a index:0 arr:arr intLen:intLen boolFirstCall:boolFirstCall];
    return b;
}

/**
 *笛卡尔乘积递归算法
 * @param $arr
 * @param array $tmp
 * @param int $first
 * @return array
 */

NSMutableArray* globalFunArrRes;
NSMutableArray* globalFunArrTmp;

- (NSArray *) fun:(NSMutableArray *)arr first:(int)first
{
    if (first == 1) {
        globalFunArrRes =  [NSMutableArray arrayWithCapacity:0];
        globalFunArrTmp = [NSMutableArray arrayWithCapacity:0];
    }
    
    NSArray * arrTwoLayer = [self array_shift:arr];
    for (int i=0; i<arrTwoLayer.count; i++) {
        NSString *v = [arrTwoLayer objectAtIndex:i];
       [globalFunArrTmp addObject: v];
        
        if (arr.count > 0) {
            NSMutableArray * arr_cpy = [NSMutableArray arrayWithCapacity:0];
            [arr_cpy addObjectsFromArray:arr];
            [self fun:arr_cpy first:0];
        } else {
            NSMutableArray * tmp_cpy =[NSMutableArray arrayWithCapacity:0];
            [tmp_cpy addObjectsFromArray:globalFunArrTmp];
            [globalFunArrRes addObject:tmp_cpy];
        }
        [self array_pop:globalFunArrTmp];
    }
    return globalFunArrRes;
}

- (NSArray *) array_shift:(NSMutableArray *) arr
{
    if (arr.count > 0) {
        NSArray* top = [arr objectAtIndex:0];
        [arr removeObjectAtIndex:0];
        return top;
    }
    else {
        return nil;
    }
}

- (void) array_pop:(NSMutableArray *) arr
{
    if (arr.count > 0) {
        [arr removeObjectAtIndex:arr.count-1];
    }
}
- (BOOL) in_array:(NSString *)obj arr:(NSArray *)arr
{
    for(NSString * elem in arr)
    {
        if ([elem isEqualToString:obj])
            return true;
    }
    return NO;
}
- (BOOL ) array_key_exists:(NSString *)key dict:(NSDictionary *)dict
{
    BOOL bRet = NO;
    for (NSString *elem in dict) {
        if([elem isEqualToString:key])
        {
            bRet = YES;
            break;
        }
    }
    
    return bRet;
}
/**
 * 每个投注内容中只包含一种过关方式
 * @strContent
 * @return array
 */

- (NSArray *) splitPassType:(NSString *) strContent
{
    NSArray *arrContent = [self explode:"@" totalstring:strContent];
    
    if( 4 != arrContent.count){
        return nil;
    }
    
    NSString *flag = arrContent[0];
    NSString *content = arrContent[1];
    NSString *playType = arrContent[2];
    NSString *mulitple = arrContent[3];
    
    NSArray *arrPlayType = [self explode:"," totalstring:playType];
    NSMutableArray *resData = [NSMutableArray arrayWithCapacity:0];
    
    for (int i=0;i<arrPlayType.count;i++)
    {
        NSString *val = arrPlayType[i];
        NSString *strPlayType = [NSString stringWithFormat:@"%@@%@@%@@%@",flag,content,val,mulitple];
    
        [resData addObject:strPlayType];
    }
    
    return resData;
}


+ (NSString*) scrambleUrl:(NSString *)urlParam
{
       // (2) key is OK?
     // TODO:key没必要做检查，自己为难自己，定义的时候定义一个OK的就行
     NSString *base64 = [NSString encodeBase64String:urlParam];
     NSData *dataBase64 = [base64 dataUsingEncoding: NSUTF8StringEncoding];
     Byte *bytesBase64 = (Byte *)[dataBase64 bytes];
     NSString *md5Digest = [NSString md5:base64];
     
     
     // (3) how many part?
     NSData* keyData = [SCRAMBLEURL_KEY dataUsingEncoding:NSUTF8StringEncoding];
     Byte *keyBytes = (Byte *)[keyData bytes];
     int part = [SCRAMBLEURL_KEY characterAtIndex:SCRAMBLEURL_KEY.length -1];
     if (isdigit(part)) {
         part = part -'0';
     }
    
    if ([base64 characterAtIndex:base64.length-1] == '=') {
        base64 = [base64 substringWithRange:NSMakeRange(0, base64.length-1)];
    }
    if ([base64 characterAtIndex:base64.length-1] == '=') {
        base64 = [base64 substringWithRange:NSMakeRange(0, base64.length-1)];
    }

     NSMutableArray *urlPartArray = [[NSMutableArray alloc] init];
     char* partStr = malloc(part+1);
     int mod = base64.length % part;
     int nUrlPart = (mod >0?1:0) +base64.length / part;
     NSString* keyCycle = SCRAMBLEURL_KEY;
     for(;;) {
         if(keyCycle.length >= nUrlPart) break;
         
         keyCycle = [keyCycle stringByAppendingString:SCRAMBLEURL_KEY];
     }
     
     NSString *msg=@"";
     
     for(int i = 0;i < nUrlPart  ;i ++) {
         memset(partStr, 0, part+1);
         if (i == nUrlPart-1 && mod != 0)
             memcpy(partStr, bytesBase64+i*part, mod);
         else
             memcpy(partStr, bytesBase64+i*part, part);
         
         char posCh = [keyCycle characterAtIndex:i];
         int pos = posCh % part;
         NSString *msgPart=@"";
         
         if (i == nUrlPart-1 && mod != 0) {
             msg = [NSString stringWithFormat:@"%@%c", msg, posCh ];
             msg = [NSString stringWithFormat:@"%@%s", msg, partStr];
         } else {
             for (int j=0; j<part; j++) {
                 if (pos ==j) {
                     msgPart = [NSString stringWithFormat:@"%@%c", msgPart, posCh ];
                 }
                 msgPart = [NSString stringWithFormat:@"%@%c", msgPart, partStr[j] ];
             }
             
             msg = [NSString stringWithFormat:@"%@%@", msg, msgPart];
         }
         
     }
     
    
     NSString * returnStr = [NSString stringWithFormat:@"msg=%@&code=%@",msg,md5Digest];

     return returnStr;
 }
 
 
@end
