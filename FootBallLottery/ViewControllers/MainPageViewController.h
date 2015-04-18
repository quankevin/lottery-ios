//
//  MainPageViewController.h
//  FootBallLottery
//
//  Created by jaye on 15/1/2.
//  Copyright (c) 2015年 jaye. All rights reserved.
//

#import "BaseViewController.h"
#import "MainPageTableViewCell.h"
#import "MixBuyView.h"
#import "DisagreeView.h"
#import "AnalyseView.h"
#import "VoteView.h"
#import "TollgateView.h"
#import "NOVoteView.h"
#import "SelectNum.h"
#import "JCUtil.h"
#import "VoteWebView.h"
#import "TollgateCollectionViewCell.h"

@interface MainPageViewController : BaseViewController<MainPageTableViewCellDelegate,TollgateViewDelegate,VoteViewDelegate,NOVoteViewDelegate,DisagreeViewDelegate,SelectNumDelegate,MixBuyViewDelegate>
{
    int pageIndex;
    BOOL isUpdate;
    CGFloat moneyFloat;
    int pageCount;
    BOOL isSuccess;
    int beishu;
    int ballotNum;
    NSInteger tollgateCount;
    NSString *urlSelectInfro;
}

@property (nonatomic,retain)NSString *message;
@property (nonatomic, retain) UILabel *messageLabel;

@property (weak, nonatomic) IBOutlet UIView *headView;
@property (strong, nonatomic) IBOutlet UIView *footView;
@property (nonatomic, retain) UIImageView *guideImage;

@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *weekLabel;
@property (weak, nonatomic) IBOutlet UILabel *countLabel;
@property (retain, nonatomic) UITableView *tableView;

@property (nonatomic, retain) NSMutableArray *dataArray;
@property (nonatomic, retain) NSMutableArray *selectArray;
@property (nonatomic, retain) NSMutableArray *rqArray;
@property (nonatomic, retain) NSMutableArray *jqArray;
@property (nonatomic, retain) NSMutableArray *bfArray;
@property (nonatomic, retain) NSMutableArray *bqArray;

@property (nonatomic, retain) NSMutableArray *hasDgArray1;
@property (nonatomic, retain) NSMutableArray *hasDgArray2;


@property (weak, nonatomic) IBOutlet UILabel *beishuLabel;
@property (weak, nonatomic) IBOutlet UILabel *voteMoneyLabel;
@property (weak, nonatomic) IBOutlet UILabel *getMoneyLabel;

@property (nonatomic, retain) NSString *tollgateStr;
@property (nonatomic, retain) NSString *voteinfoStr;
@property (nonatomic, retain) NSString *matchId;

@property (strong, nonatomic) IBOutlet TollgateView *normalTollgateView;
@property (nonatomic, retain) UIView *MoreTollgate;
@property (weak, nonatomic) IBOutlet UIButton *tollgateBtn;
@property (weak, nonatomic) IBOutlet UIButton *moreTollgateBtn;

@property (strong, nonatomic) UICollectionView  *collectionView;

@property (weak, nonatomic) IBOutlet UIButton *beishuBtn;

@property (nonatomic, retain) NSMutableArray *winVoteArray;

@property (nonatomic, retain) NSMutableDictionary *selectVoteDic;

@property (strong, nonatomic) IBOutlet UIView *tollgateView;

@property (weak, nonatomic) IBOutlet UIButton *danguanBtn;
@property (weak, nonatomic) IBOutlet UIButton *twoToone;
@property (weak, nonatomic) IBOutlet UIButton *threeToone;
@property (weak, nonatomic) IBOutlet UIButton *fourToone;
@property (weak, nonatomic) IBOutlet UIButton *fiveToone;

@property (nonatomic, retain) NSMutableArray *tollgateArray;
@property (nonatomic, retain) NSMutableArray *tollgateNameArray;
@property (nonatomic, retain) NSMutableArray *tollgateNormalArray;

@end
