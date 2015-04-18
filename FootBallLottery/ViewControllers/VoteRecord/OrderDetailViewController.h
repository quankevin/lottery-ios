//
//  OrderDetailViewController.h
//  FootBallLottery
//
//  Created by jaye on 15/1/3.
//  Copyright (c) 2015年 jaye. All rights reserved.
//

#import "BaseViewController.h"

@interface OrderDetailViewController : BaseViewController
{
    NSString *bonus;
    CGSize cellSize;
}

@property (nonatomic, retain) NSString *serialid;
@property (nonatomic, retain) NSDictionary *dataDic;
@property (nonatomic, assign) VoteRecordType voteRecordType;

@property (weak, nonatomic) IBOutlet UILabel *voteType;
@property (weak, nonatomic) IBOutlet UILabel *voteNum;
@property (weak, nonatomic) IBOutlet UILabel *voteMoney;
@property (weak, nonatomic) IBOutlet UILabel *voteDetailType;
@property (weak, nonatomic) IBOutlet UILabel *winMoney;
@property (weak, nonatomic) IBOutlet UILabel *openTime;
@property (weak, nonatomic) IBOutlet UILabel *zhushu;
@property (weak, nonatomic) IBOutlet UILabel *beishu;

@property (nonatomic, retain) UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIView *headView;
@property (strong, nonatomic) IBOutlet UIView *footView;
@property (weak, nonatomic) IBOutlet UILabel *voteTime;
@property (weak, nonatomic) IBOutlet UILabel *projectNum;


@end
