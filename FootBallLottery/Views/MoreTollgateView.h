//
//  MoreTollgateView.h
//  FootBallLottery
//
//  Created by jaye on 15/1/25.
//  Copyright (c) 2015年 jaye. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@protocol MoreTollgateViewDelegate <NSObject>

//选择串关
- (void)selectTollgate;

@end

@interface MoreTollgateView : UIView

@property (nonatomic, retain) NSString *tollgateName;
@property (nonatomic, retain) id<MoreTollgateViewDelegate> delegate;
@property (nonatomic, retain) NSMutableArray *tollgateArray;



@end
