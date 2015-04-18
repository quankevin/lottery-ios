//
//  HttpConnnection.h
//  FootBallLottery
//
//  Created by jaye on 15/1/16.
//  Copyright (c) 2015年 jaye. All rights reserved.
//
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface HttpConnnection : NSObject<NSXMLParserDelegate>
{
    void (^CompletionBlock)(NSDictionary *resp);
    void (^FailedErrorBlock)(NSString *resultMsg);
}

@property (nonatomic, retain) NSURLConnection *connection;
@property (nonatomic, retain) NSMutableData *receiveData;
@property (nonatomic, retain) NSDictionary *dataDic;
@property (nonatomic, retain) NSString *element;

//post 请求Http
- (void)requestConnection:(NSString *)serverUrl
               postParams:(NSMutableString *)postParams
               completion:(void (^)(NSMutableDictionary *))completion
                   failed:(void (^)(NSString *))failed;

@end
