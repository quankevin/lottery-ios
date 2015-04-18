//
//  BaseViewController.h
//  FootBallLottery
//
//  Created by jaye on 15/1/2.
//  Copyright (c) 2015年 jaye. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppConstants.h"
#import "MFSideMenu.h"
#import "AppDelegate.h"
#import "Utils.h"
#import "HttpConnnection.h"
#import "MJRefresh.h"

@interface BaseViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,UIAlertViewDelegate,UICollectionViewDataSource,UICollectionViewDelegate>

@property (nonatomic, retain) MFSideMenu *sideMenu;
@property (nonatomic, retain) HttpConnnection *connection;
@property (nonatomic, retain) MBProgressHUD *baseProgRessHUD;

//展示信息
- (MBProgressHUD* )showProgressHUD:(NSString*) labelText;
- (MBProgressHUD* )showFailMessage:(NSString*) labelText;
- (void) hideProgressHUD;

- (CTBaseDialogView *)showDialogView:(UIView *)subview fromFrame:(CGRect)fromFrame;

@end
