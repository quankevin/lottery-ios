//
//  VoteRecordViewController.h
//  FootBallLottery
//
//  Created by jaye on 15/1/2.
//  Copyright (c) 2015年 jaye. All rights reserved.
//

#import "BaseViewController.h"
#import "VoteRecordTableViewCell.h"
#import "OrderDetailViewController.h"

@interface VoteRecordViewController : BaseViewController
{
    int indexPage;
    int count;
}

@property (retain, nonatomic) UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIImageView *selectGroundImage;

@property (nonatomic, retain) NSMutableArray *dataArray;

@property (nonatomic, assign) VoteRecordType voteRecordType;

@end
