//
//  BaseViewController.m
//  FootBallLottery
//
//  Created by jaye on 15/1/2.
//  Copyright (c) 2015年 jaye. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if(self)
    {
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = [Utils colorWithHexString:@"#262833"];
    self.connection = [[HttpConnnection alloc] init];
}

#pragma mark - Show DialogView
- (CTBaseDialogView *)showDialogView:(UIView *)subview fromFrame:(CGRect)fromFrame
{
    return [self showDialogView:subview animatedType:CTAnimationTypeUnwind fromFrame:fromFrame];
}

- (CTBaseDialogView *)showDialogView:(UIView *)subview animatedType:(CTAnimationType)animatedType fromFrame:(CGRect)fromFrame
{
    CTBaseDialogView *dialogView = [[CTBaseDialogView alloc] initWithSubView:subview animation:animatedType fromFrame:fromFrame];
    dialogView.isNoNeedCloseBtn = YES;
    [dialogView show];
    
    return dialogView;
}

#pragma mark - show message
- (MBProgressHUD *)showProgressHUD:(NSString*) labelText
{
    if(_baseProgRessHUD != nil) {
        [self hideProgressHUD];
    }
    _baseProgRessHUD = [[MBProgressHUD alloc] initWithView:self.view];
    _baseProgRessHUD.alpha = 0;
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    _baseProgRessHUD.alpha = 1;
    [UIView commitAnimations];
    if(labelText) {
        _baseProgRessHUD.labelText = labelText;
    }
    [self.view addSubview:_baseProgRessHUD];
    [_baseProgRessHUD show:YES];
    return _baseProgRessHUD;
}

- (MBProgressHUD* )showFailMessage:(NSString*) labelText
{
    if(_baseProgRessHUD != nil) {
        [self hideProgressHUD];
    }
    _baseProgRessHUD = [[MBProgressHUD alloc] initWithView:self.view];
    _baseProgRessHUD.alpha = 0;
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:2];
    _baseProgRessHUD.alpha = 1;
    [UIView commitAnimations];
    if(labelText) {
        _baseProgRessHUD.labelText = labelText;
    }
    [self.view addSubview:_baseProgRessHUD];
    [_baseProgRessHUD show:YES];
    [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(hideProgressHUD) userInfo:nil repeats:NO];
    return _baseProgRessHUD;
}

- (void)hideProgressHUD
{
    if(_baseProgRessHUD != nil) {
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.3];
        _baseProgRessHUD.alpha = 0;
        [UIView commitAnimations];
        [_baseProgRessHUD removeFromSuperview];
        _baseProgRessHUD = nil;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
