//
//  HistoryDetailViewController.h
//  FootBallLottery
//
//  Created by jaye on 15/1/11.
//  Copyright (c) 2015年 jaye. All rights reserved.
//

#import "BaseViewController.h"
#import "HistoryDetailTableViewCell.h"

@interface HistoryDetailViewController : BaseViewController

@property (weak, nonatomic) IBOutlet UILabel *dataLabel;
@property (weak, nonatomic) IBOutlet UILabel *weekLabel;
@property (weak, nonatomic) IBOutlet UILabel *resultLabel;
@property (nonatomic, retain) NSString *data;
@property (nonatomic, retain) NSString *hitCount;
@property (nonatomic, retain) NSString *count;

@property (nonatomic, retain) UITableView *tableView;

@property (nonatomic, retain) NSMutableArray *dataArray;

@end
