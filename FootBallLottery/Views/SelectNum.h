//
//  SelectNum.h
//  FootBallLottery
//
//  Created by jaye on 15/2/1.
//  Copyright (c) 2015年 jaye. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SelectNumDelegate <NSObject>

- (void)selectCount:(NSString *)num;

@end

@interface SelectNum : UIView<UITextFieldDelegate>

@property (nonatomic, retain) id<SelectNumDelegate> delegate;
@property (weak, nonatomic) IBOutlet UITextField *numTextField;

@end
