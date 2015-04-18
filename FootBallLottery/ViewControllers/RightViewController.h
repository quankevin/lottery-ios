//
//  RightViewController.h
//  FootBallLottery
//
//  Created by jaye on 15/1/2.
//  Copyright (c) 2015年 jaye. All rights reserved.
//

#import "BaseViewController.h"
#import "HistoryTableViewCell.h"
#import "HistoryDetailViewController.h"

@interface RightViewController : BaseViewController
{
    BOOL isSuccess;
    int count;
    int indexPage;
}

@property (retain, nonatomic) UITableView *tableView;
@property (nonatomic, retain) NSMutableArray *dataArray;


@end
