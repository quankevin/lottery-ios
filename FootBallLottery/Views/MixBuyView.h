//
//  MixBuyView.h
//  FootBallLottery
//
//  Created by jaye on 15/1/2.
//  Copyright (c) 2015年 jaye. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MixBuyViewDelegate <NSObject>

- (void)MixDoneAction:(NSMutableArray *)spArray rqDic:(NSDictionary *)rqDic  bfDic:(NSDictionary *)bfDic jqDic:(NSDictionary *)jqDic bqDic:(NSDictionary *)bqDic indexRow:(NSInteger)index;

@end

@interface MixBuyView : UIView

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UILabel *hostLabel;
@property (weak, nonatomic) IBOutlet UILabel *visiteLabel;

//胜负平
@property (weak, nonatomic) IBOutlet UIButton *winBtn;
@property (weak, nonatomic) IBOutlet UIButton *tieBtn;
@property (weak, nonatomic) IBOutlet UIButton *failBtn;
@property (nonatomic, retain) NSMutableArray *spArray;
@property (nonatomic, retain) NSMutableArray *sfpArray;

//让球
@property (weak, nonatomic) IBOutlet UIButton *rqWinBtn;
@property (weak, nonatomic) IBOutlet UIButton *rqTieBtn;
@property (weak, nonatomic) IBOutlet UIButton *rqFailBtn;
@property (nonatomic, retain) NSMutableArray *rqArray;
@property (nonatomic, retain) NSMutableArray *selectRqArray;

//比分
@property (nonatomic, retain) NSMutableArray *bfArray;
@property (nonatomic, retain) NSMutableArray *selectBfArray;

//总进球
@property (nonatomic, retain) UILabel *jqLabel;
@property (nonatomic, retain) NSMutableArray *jqArray;
@property (nonatomic, retain) NSMutableArray *selectJqArray;

//半全场
@property (nonatomic, retain) UILabel *bqLabel;
@property (nonatomic, retain) NSMutableArray *bqArray;
@property (nonatomic, retain) NSMutableArray *selectBqArray;

@property (nonatomic, retain) NSDictionary *dataDic;

@property (nonatomic, retain) id<MixBuyViewDelegate> delegate;
@property (nonatomic, assign) NSInteger indexRow;

@end
