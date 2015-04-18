//
//  MyDetailListViewController.h
//  FootBallLottery
//
//  Created by jaye on 15/1/8.
//  Copyright (c) 2015年 jaye. All rights reserved.
//

#import "BaseViewController.h"
#import "DetailTableViewCell.h"
#import "GetAndOutViewController.h"

@interface MyDetailListViewController : BaseViewController
{
    BOOL isWeek;
    int pageIndex;
    int pageCount;
    NSString *startDate;
    NSString *endDate;
}

//账户，充值，提现选择试图
@property (strong, nonatomic) IBOutlet UIView *selectView;
@property (weak, nonatomic) IBOutlet UIImageView *selectGroundImage;

//时间选择试图
@property (strong, nonatomic) IBOutlet UIView *weekSelectView;
@property (weak, nonatomic) IBOutlet UIImageView *weekSelectBg;

@property (strong, nonatomic) IBOutlet UIView *headView;
@property (nonatomic, retain) UITableView *tableView;

@property (nonatomic, retain) NSString *mflag;
@property (nonatomic, retain) NSMutableArray *dataArray;

@property (weak, nonatomic) IBOutlet UILabel *outMoney;
@property (weak, nonatomic) IBOutlet UILabel *inMoney;

@end
