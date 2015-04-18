//
//  HistoryTableViewCell.h
//  FootBallLottery
//
//  Created by jaye on 15/1/11.
//  Copyright (c) 2015年 jaye. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Utils.h"

@interface HistoryTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *resuleLabel;

@property (nonatomic, retain) NSDictionary *dataDic;


@end
