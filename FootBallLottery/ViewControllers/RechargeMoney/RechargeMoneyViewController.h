//
//  RechargeMoneyViewController.h
//  FootBallLottery
//
//  Created by jaye on 15/1/2.
//  Copyright (c) 2015年 jaye. All rights reserved.
//

#import "BaseViewController.h"
#import "BankViewController.h"
#import "BankListTableViewCell.h"
#import "ShortCutPayViewController.h"

@interface RechargeMoneyViewController : BaseViewController
{
    NSInteger rowCount;
}

@property (weak, nonatomic) IBOutlet UITextField *rechargeMoney;
@property (weak, nonatomic) IBOutlet UIButton *firshBtn;
@property (weak, nonatomic) IBOutlet UIButton *secondBtn;
@property (weak, nonatomic) IBOutlet UIButton *thirdBtn;
@property (weak, nonatomic) IBOutlet UIButton *fouthBtn;
@property (nonatomic, retain) NSArray *btnArray;

@property (nonatomic, retain) UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIView *addBankView;
@property (nonatomic, retain) NSMutableArray *bankListArray;
@property (strong, nonatomic) IBOutlet UIView *kuaijieView;

@property (nonatomic) NSInteger indexNum;


@end
