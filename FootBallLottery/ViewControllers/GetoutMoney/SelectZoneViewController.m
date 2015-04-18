//
//  SelectZoneViewController.m
//  FootBallLottery
//
//  Created by jaye on 15/1/5.
//  Copyright (c) 2015年 jaye. All rights reserved.
//

#import "SelectZoneViewController.h"

@interface SelectZoneViewController ()

@end

@implementation SelectZoneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupMenuBarButtonItems];
}

#pragma mark - navigationController
- (void)setupMenuBarButtonItems
{
    self.navigationItem.leftBarButtonItem = [self backBarButtonItem];
    self.navigationItem.titleView =         [self tittleLabel];
}

//标题
- (UILabel *)tittleLabel
{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 50)];
    label.textColor = [Utils colorWithHexString:@"#E6E9E7"];
    label.font = [UIFont systemFontOfSize:20.0f];
    label.text = @"选择开户地";
    label.textAlignment = NSTextAlignmentCenter;
    return label;
}

//返回
- (UIBarButtonItem *)backBarButtonItem
{
    UIButton *leftBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 20, 40)];
    [leftBtn setImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(backButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    return [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
}

- (void)backButtonPressed:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
