//
//  VoteWebView.m
//  FootBallLottery
//
//  Created by jaye on 15/2/12.
//  Copyright (c) 2015年 jaye. All rights reserved.
//

#import "VoteWebView.h"

@implementation VoteWebView

- (void)setWebUrl:(NSString *)webUrl
{
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:webUrl]];
    [self.webView loadRequest:request];
}

@end
