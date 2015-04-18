//
//  VoteView.h
//  FootBallLottery
//
//  Created by jaye on 15/1/10.
//  Copyright (c) 2015年 jaye. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol VoteViewDelegate <NSObject>

- (void)voteAction;     //去投注

@end

@interface VoteView : UIView
@property (weak, nonatomic) IBOutlet UILabel *voteMoney;
@property (weak, nonatomic) IBOutlet UILabel *remainMoney;
@property (weak, nonatomic) IBOutlet UILabel *voteType;
@property (weak, nonatomic) IBOutlet UIImageView *smileImageView;
@property (weak, nonatomic) IBOutlet UILabel *remarkLabel;

@property (nonatomic, retain) id<VoteViewDelegate> delegate;

@end
