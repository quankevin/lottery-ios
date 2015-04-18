//
//  UIView+CTDialog.m
//  KidsBook
//
//  Created by Lukes Lu on 10/16/13.
//  Copyright (c) 2013 KidsBook Office. All rights reserved.
//

#import "UIView+CTDialog.h"

#import "CTBaseDialogView.h"

@implementation UIView (CTDialog)

- (CTBaseDialogView *)dialogView
{
    if ([self.superview isKindOfClass:[UIScrollView class]]) {
        if ([self.superview.superview isKindOfClass:[CTBaseDialogView class]]) {
            return (CTBaseDialogView *)self.superview.superview;
        }
    }
    
    return nil;
}

@end
