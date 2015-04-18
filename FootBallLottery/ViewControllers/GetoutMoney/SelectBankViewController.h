//
//  SelectBankViewController.h
//  FootBallLottery
//
//  Created by jaye on 15/1/5.
//  Copyright (c) 2015年 jaye. All rights reserved.
//

#import "BaseViewController.h"
#import "BankTableViewCell.h"

@interface SelectBankViewController : BaseViewController

@property (weak, nonatomic) IBOutlet UIImageView *selectGroundImage;

@property (nonatomic, retain) UITableView *tableView;
@property (nonatomic, retain) NSMutableArray *saveBankImageArray;
@property (nonatomic, retain) NSMutableArray *creaditCardImageArray;
@property (nonatomic, retain) NSMutableArray *saveBankNameArray;
@property (nonatomic, retain) NSMutableArray *creditCardNameArray;

@end
