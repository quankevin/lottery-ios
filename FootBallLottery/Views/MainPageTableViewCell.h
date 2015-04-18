//
//  MainPageTableViewCell.h
//  FootBallLottery
//
//  Created by jaye on 15/1/2.
//  Copyright (c) 2015年 jaye. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Utils.h"

@protocol MainPageTableViewCellDelegate <NSObject>

- (void)selectWinTieFail:(UIView *)view index:(long)index isSelect:(BOOL)isSelect;

@end

@interface MainPageTableViewCell : UITableViewCell
{
    BOOL isSelect;
}

@property (weak, nonatomic) IBOutlet UILabel *gameTime;
@property (weak, nonatomic) IBOutlet UILabel *HostTeam;
@property (weak, nonatomic) IBOutlet UILabel *gameType;
@property (weak, nonatomic) IBOutlet UILabel *visitingTeam;

@property (weak, nonatomic) IBOutlet UIButton *winBtn;
@property (weak, nonatomic) IBOutlet UIButton *tieBtn;
@property (weak, nonatomic) IBOutlet UIButton *failBtn;

@property (weak, nonatomic) IBOutlet UIButton *mixBtn;
@property (weak, nonatomic) IBOutlet UIButton *analyseBtn;
@property (weak, nonatomic) IBOutlet UIButton *disagreeBtn;


@property (nonatomic, retain) NSMutableDictionary *dataDic;

@property (nonatomic, retain) id<MainPageTableViewCellDelegate> delegate;

@end
