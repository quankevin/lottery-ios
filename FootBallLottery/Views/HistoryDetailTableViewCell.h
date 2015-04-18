//
//  HistoryDetailTableViewCell.h
//  FootBallLottery
//
//  Created by jaye on 15/1/18.
//  Copyright (c) 2015年 jaye. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HistoryDetailTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *gameType;
@property (weak, nonatomic) IBOutlet UILabel *gameNum;
@property (weak, nonatomic) IBOutlet UILabel *gameTime;
@property (weak, nonatomic) IBOutlet UILabel *firstName;
@property (weak, nonatomic) IBOutlet UIImageView *winAndFailBg;
@property (weak, nonatomic) IBOutlet UILabel *halfNum;
@property (weak, nonatomic) IBOutlet UILabel *allNum;
@property (weak, nonatomic) IBOutlet UILabel *secondName;

@property (nonatomic, retain) NSDictionary *dataDic;

@end
