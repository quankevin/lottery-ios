//
//  VoteWebView.h
//  FootBallLottery
//
//  Created by jaye on 15/2/12.
//  Copyright (c) 2015年 jaye. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VoteWebView : UIView

@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (nonatomic, retain) NSString *webUrl;

@end
