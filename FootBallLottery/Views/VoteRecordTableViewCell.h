//
//  VoteRecordTableViewCell.h
//  FootBallLottery
//
//  Created by jaye on 15/1/3.
//  Copyright (c) 2015年 jaye. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VoteRecordTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *dataLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *voteTypeLabel;
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;
@property (weak, nonatomic) IBOutlet UILabel *selectTypeLabel;

@property (nonatomic, retain) NSDictionary *dataDic;


@end
