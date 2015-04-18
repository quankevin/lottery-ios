//
//  NOVoteView.h
//  FootBallLottery
//
//  Created by jaye on 15/1/25.
//  Copyright (c) 2015年 jaye. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol NOVoteViewDelegate <NSObject>

- (void)rechargeAction;

@end

@interface NOVoteView : UIView

@property (weak, nonatomic) IBOutlet UILabel *voteMoney;
@property (weak, nonatomic) IBOutlet UILabel *remainMoney;

@property (nonatomic, retain) id<NOVoteViewDelegate> delegate;

@end
