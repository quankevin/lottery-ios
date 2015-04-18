//
//  HttpConnnection.m
//  FootBallLottery
//
//  Created by jaye on 15/1/16.
//  Copyright (c) 2015年 jaye. All rights reserved.
//

#import "HttpConnnection.h"
#import "XMLDictionary.h"

@implementation HttpConnnection

- (void)requestConnection:(NSString *)serverUrl
               postParams:(NSMutableString *)postParams
               completion:(void (^)(NSMutableDictionary *))completion
                   failed:(void (^)(NSString *))failed
{
    NSData *postData = [postParams dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:serverUrl]];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:postData];
    request.timeoutInterval = 30.0f;
    
    self.dataDic = [[NSDictionary alloc] init];
    self.receiveData = [[NSMutableData alloc] init];
    
    CompletionBlock = [completion copy];
    FailedErrorBlock = [failed copy];
    
    //在状态栏显示开启网络请求
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    //创建请求
    NSOperationQueue *queue = [NSOperationQueue mainQueue];
    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError)
    {
        //在状态栏显示关闭网络请求
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        if (connectionError) //请求失败
        {
            FailedErrorBlock(@"请求失败!");
        }
        else                 //请求成功
        {
            [self.receiveData appendData:data];
            //XML转化为NSDictionary
            self.dataDic = [NSDictionary dictionaryWithXMLData:self.receiveData];
            CompletionBlock(self.dataDic);
        }
    }];
}

@end
