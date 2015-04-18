//
//  AppDelegate.m
//  FootBallLottery
//
//  Created by jaye on 15/1/2.
//  Copyright (c) 2015年 jaye. All rights reserved.
//

#import "AppDelegate.h"
#import "MFSideMenu.h"
#import "MainPageViewController.h"
#import "LeftViewController.h"
#import "RightViewController.h"
#import "Utils.h"

@interface AppDelegate ()

@end

@implementation AppDelegate
+ (id)getAppDelegate
{
    return [[UIApplication sharedApplication] delegate];
}

- (void)initData
{
    self.bankList = [[NSMutableArray  alloc] init];
    self.bankList_c = [[NSMutableArray alloc] init];
    self.tollgateArray = [[NSMutableArray alloc] initWithObjects:@"1*1", nil];
    self.bankType = saveBank;
    self.isSlider = YES;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [Utils colorWithHexString:@"#262833"];
    
    [self initData];
    
    MainPageViewController *mainPageViewContoller = [[MainPageViewController alloc] initWithNibName:@"MainPageViewController" bundle:nil];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:mainPageViewContoller];
    navigationController.navigationBar.barTintColor = [Utils colorWithHexString:@"#138C65"];
    
    LeftViewController *leftController = [[LeftViewController alloc]
                                          initWithNibName:@"LeftViewController" bundle:nil];
    RightViewController *rightController = [[RightViewController alloc] initWithNibName:@"RightViewController" bundle:nil];
    
    MFSideMenu *sideMenu = [MFSideMenu menuWithNavigationController:navigationController leftSideMenuController:leftController rightSideMenuController:rightController];
    
    leftController.sideMenu  = sideMenu;
    rightController.sideMenu = sideMenu;
    
    self.window.rootViewController = sideMenu.navigationController;
    [self.window makeKeyAndVisible];
    
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    
    if(kSystemVersion7Later)
    {
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    }
    
    return YES;
}

//投注回调
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation{
    NSString* strurl = [url absoluteString];
    NSLog(@"%@",strurl);
    if([[strurl substringFromIndex:strurl.length - 4] isEqualToString:@"true"])
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"voteSuccessRefresh" object:nil];
    }
    return YES;
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url{
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    [[NSNotificationCenter defaultCenter] postNotificationName:@"activeNotification" object:nil];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
