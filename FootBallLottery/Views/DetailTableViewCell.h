//
//  DetailTableViewCell.h
//  FootBallLottery
//
//  Created by jaye on 15/1/8.
//  Copyright (c) 2015年 jaye. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *dataLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *accountTypeLabel;
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;

@property (nonatomic, retain) NSDictionary *dataDic;


@end
