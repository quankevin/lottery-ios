//
//  BankListTableViewCell.h
//  FootBallLottery
//
//  Created by jaye on 15/1/29.
//  Copyright (c) 2015年 jaye. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface BankListTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *bgImageView;
@property (weak, nonatomic) IBOutlet UILabel *bankName;
@property (weak, nonatomic) IBOutlet UILabel *bankNum;
@property (weak, nonatomic) IBOutlet UILabel *bankType;


@property (nonatomic, retain) NSDictionary *dataDic;

@end
