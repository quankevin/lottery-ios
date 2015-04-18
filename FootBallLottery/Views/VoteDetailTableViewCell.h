//
//  VoteDetailTableViewCell.h
//  FootBallLottery
//
//  Created by jaye on 15/2/11.
//  Copyright (c) 2015年 jaye. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VoteDetailTableViewCell : UITableViewCell

@property (nonatomic, retain) NSDictionary *dataDic;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *numLabel;
@property (weak, nonatomic) IBOutlet UILabel *hostTeam;
@property (weak, nonatomic) IBOutlet UILabel *visterTeam;
@property (weak, nonatomic) IBOutlet UILabel *voteType;
@property (weak, nonatomic) IBOutlet UILabel *voteLabel;
@property (weak, nonatomic) IBOutlet UILabel *result;

@end
