//
//  TollgateView.h
//  FootBallLottery
//
//  Created by jaye on 15/1/25.
//  Copyright (c) 2015年 jaye. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol TollgateViewDelegate <NSObject>

- (void)selectTollgate;

@end

@interface TollgateView : UIView

@property (weak, nonatomic) IBOutlet UIButton *singleBtn;
@property (weak, nonatomic) IBOutlet UIButton *twoBtn;
@property (weak, nonatomic) IBOutlet UIButton *threeBtn;
@property (weak, nonatomic) IBOutlet UIButton *fourBtn;
@property (weak, nonatomic) IBOutlet UIButton *fiveBtn;

@property (nonatomic, retain) NSArray *btnArray;

@property (nonatomic, retain) id<TollgateViewDelegate> delegate;
@end
