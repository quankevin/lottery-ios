//
//  CTBaseDialogView.m
//  MulScreen
//
//  Created by lingmin on 12-3-23.
//  Copyright 2012 Shenzhen iDooFly Technology Co., Ltd. All rights reserved.
//

#import "CTBaseDialogView.h"

@interface CTBaseDialogView ()

@property (nonatomic, strong) UIButton *closeBtn;
@property (nonatomic, strong) UIScrollView *mainView;
@property (nonatomic, strong) id tempObj;
@property (nonatomic, assign) CGRect fromFrame;

@end

@implementation CTBaseDialogView

@synthesize mainView;
@synthesize tempObj = _tempObj;

#pragma mark - Memory

- (void)addObservers
{
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deviceOrientationDidChange:) name:UIDeviceOrientationDidChangeNotification object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)removeObservers
{
	[[NSNotificationCenter defaultCenter] removeObserver:self name:UIDeviceOrientationDidChangeNotification object:nil];
	[[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

#pragma mark - Lifecycle

- (void)dealloc
{
//    MGDebug(@"[CTBaseDialogView] dealloc");
}

- (id)initWithSubView:(UIView*)subView animation:(CTAnimationType)animationType fromFrame:(CGRect)fromFrame
{
    self = [super init];
    if(self){
        if (CGRectIsEmpty(fromFrame) || CGRectIsNull(fromFrame)) {
            UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
            self.fromFrame = CGRectMake(window.center.y, window.center.x, 1, 1);
        }else{
            self.fromFrame = fromFrame;
        }
        
        _animationType = animationType;
        _orientation = UIDeviceOrientationUnknown;
		_showingKeyboard = NO;
		[self sizeToFitOrientation:NO];
		
		self.backgroundColor=[UIColor clearColor];
		self.autoresizesSubviews = YES;
		self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        self.contentMode = UIViewContentModeRedraw;
		
		overView = [[UIView alloc] initWithFrame:CGRectMake(0,0,self.frame.size.width,self.frame.size.height)];
		overView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
		overView.backgroundColor = [UIColor blackColor];
		overView.alpha = 0.3f;
        
		[self addSubview:overView];
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(whenCloseBtnTapped:)];
        [subView addGestureRecognizer:tapGesture];
        
		UIButton *btnClose = [UIButton buttonWithType:UIButtonTypeCustom];
		btnClose.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
		btnClose.frame = CGRectMake(0, 0, 1024, 768);
		btnClose.backgroundColor = [UIColor clearColor];
		[btnClose addTarget:self action:@selector(whenCloseBtnTapped:) forControlEvents:UIControlEventTouchUpInside];
		[overView addSubview:btnClose];
		
        self.mainView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, subView.bounds.size.width, subView.bounds.size.height)];
        self.mainView.backgroundColor = [UIColor clearColor];
        self.mainView.contentSize = self.mainView.bounds.size;
        NSInteger x = self.frame.size.width/2 - self.mainView.bounds.size.width/2;
        NSInteger y = self.frame.size.height/2 - self.mainView.bounds.size.height/2;
        self.mainView.frame = CGRectMake(x, y, self.mainView.bounds.size.width, self.mainView.bounds.size.height);
        [self.mainView addSubview:subView];
        self.bodyView = subView;
        
        self.closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.closeBtn setFrame:CGRectMake(self.mainView.bounds.size.width-64, 6, 44, 44)];
        [self.closeBtn setBackgroundColor:[UIColor clearColor]];
        [self.closeBtn setImage:[UIImage imageNamed:@"dialog_btn_close"] forState:UIControlStateNormal];
        [self.closeBtn addTarget:self action:@selector(whenCloseBtnTapped:) forControlEvents:UIControlEventTouchUpInside];
        [self.mainView addSubview:self.closeBtn];
        
		[self addSubview:mainView];
        
    }
    
    return  self;
}

- (BOOL)shouldRotateToOrientation:(UIDeviceOrientation)orientation
{
    return orientation == UIDeviceOrientationLandscapeLeft
    || orientation == UIDeviceOrientationLandscapeRight;
//	if (orientation == _orientation) {
//		return NO;
//	} else {
//		return orientation == UIDeviceOrientationLandscapeLeft
//		|| orientation == UIDeviceOrientationLandscapeRight
//		|| orientation == UIDeviceOrientationPortrait
//		|| orientation == UIDeviceOrientationPortraitUpsideDown;
//	}
}

//视图需要旋转的角度
- (CGAffineTransform)transformForOrientation
{
	UIDeviceOrientation orientation = (UIDeviceOrientation)[UIApplication sharedApplication].statusBarOrientation;
    if ([UIDevice currentDevice].orientation == UIDeviceOrientationLandscapeLeft || [UIDevice currentDevice].orientation == UIDeviceOrientationLandscapeRight) {
        orientation = [UIDevice currentDevice].orientation;
    }
	if (orientation == UIDeviceOrientationLandscapeLeft) {
		return CGAffineTransformMakeRotation(M_PI_2);//顺时针旋转90
	} else if (orientation == UIDeviceOrientationLandscapeRight) {
		return CGAffineTransformMakeRotation(M_PI * 1.5);//逆时针90
	} else if (orientation == UIDeviceOrientationPortraitUpsideDown) {
		return CGAffineTransformMakeRotation(-M_PI);//逆时针旋转180
	} else {
		return CGAffineTransformIdentity;
	}
}

- (void)sizeToFitOrientation:(BOOL)transform
{
	if (transform) {
		self.transform = CGAffineTransformIdentity;
	}
	
    CGRect frame;
    if (kSystemVersion7) {
        frame = [UIScreen mainScreen].bounds;
    }else{
        frame = [UIScreen mainScreen].applicationFrame;
    }
    NSInteger x = frame.size.width/2;
    NSInteger y = frame.size.height/2;
	CGPoint center = CGPointMake(frame.origin.x + x, frame.origin.y + y);
	
	_orientation = (UIDeviceOrientation)[UIApplication sharedApplication].statusBarOrientation;
	//判断是否是横屏
	if (UIInterfaceOrientationIsLandscape(_orientation) && !kSystemVersion8) {
		self.frame = CGRectMake(0, 0, frame.size.height, frame.size.width);
	} else {
		self.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
	}
	self.center = center;
	
	if (transform && !kSystemVersion8) {
		self.transform = [self transformForOrientation];
	}
}

#pragma mark - Methods

-(void)tagerViewAnimation:(UIView*)view type:(CTAnimationType)type
{
    switch (type) {
        case CTAnimationTypeUnwind:{
            overView.hidden = YES;
            CGRect orgFrame = self.mainView.frame;
            self.mainView.frame = self.fromFrame;
            self.mainView.alpha = 0;
            overView.alpha = 0;
            overView.hidden = NO;
            [UIView animateWithDuration:kAnimationTime
                             animations:^{
                                 self.mainView.frame = orgFrame;
                                 self.mainView.alpha = 1.0f;
                                 overView.alpha = 0.5f;
                             } completion:^(BOOL finished) {
                                 overView.hidden = NO;
                                 
                                 // Add View To UIWindow
                                 UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
                                 UIView *tempView = [[UIView alloc] initWithFrame:window.bounds];
                                 tempView.backgroundColor = [UIColor clearColor];
                                 tempView.userInteractionEnabled = YES;
                                 tempView.tag = kOverViewInWindowTag;
                                 [window insertSubview:tempView belowSubview:self];
                             }];
            break;
        }
            
        case CTAnimationTypeOverturn:{
            
            break;
        }
            
        default:{
            overView.hidden = NO;
            overView.alpha = 0.3f;
            self.mainView.alpha = 1.0f;
            break;
        }
    }
}

- (void)backToTargetSelector
{
    // Remove View To UIWindow
    UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
    for (int i = window.subviews.count-1; i > 0; i--) {
        UIView *subview = [window.subviews objectAtIndex:i];
        if (subview.tag == kOverViewInWindowTag) {
            [subview removeFromSuperview];
            break;
        }
    }
    
    if (self.target && [self.target respondsToSelector:self.selector]) {
        [self.target performSelector:self.selector withObject:self afterDelay:0];
    }
}

- (void)removeFromSuperview
{
    if (self.mainView.subviews && self.mainView.subviews.count > 0) {
        UIView *subview = [self.mainView.subviews objectAtIndex:0];
        if ([subview respondsToSelector:@selector(clear)]) {
            [subview performSelector:@selector(clear) withObject:nil afterDelay:0];
        }
    }
    
    [super removeFromSuperview];
}

- (void)addTarget:(id)target selector:(SEL)selector
{
    self.target = target;
    self.selector = selector;
}

//在已经显示出来的情况下再次模拟打开时候的动画
- (void)animationWithShow
{
    [self tagerViewAnimation:mainView type:_animationType];
}


- (void)setIsNoReposeWhenBackgroundTouched:(BOOL)isNoReposeWhenBackgroundTouched
{
    _isNoReposeWhenBackgroundTouched = isNoReposeWhenBackgroundTouched;
    
//    self.closeBtn.hidden = self.isNoReposeWhenBackgroundTouched;
}

- (void)setIsNoNeedCloseBtn:(BOOL)isNoNeedCloseBtn
{
    _isNoNeedCloseBtn = isNoNeedCloseBtn;
    
    self.closeBtn.hidden = isNoNeedCloseBtn;
}

- (void)whenCloseBtnTapped:(UIButton *)button
{
    //如果是单击手势，说明是在显示窗口中点击空白处触发的，隐藏键盘即可    ||     如果设置为点击灰色背景不关闭窗口且当前点击的不是关闭按钮(点击的是灰色背景)，则只隐藏键盘
    if ([button isKindOfClass:[UIGestureRecognizer class]] || (self.isNoReposeWhenBackgroundTouched && button != self.closeBtn)) {
        UIView *focusView = [Utils findFocusInputView:self.mainView];
        if (focusView) {
            [focusView resignFirstResponder];
            return;
        }
    } else {
        if (!self.isNoReposeWhenBackgroundTouched || button == self.closeBtn) {
            // Check Text Become Res
            UIView *focusView = [Utils findFocusInputView:self.mainView];
            if (focusView) {
                [focusView resignFirstResponder];
                return;
            }
            self.userInteractionEnabled = NO;
            [self close:YES];
        }
    }
}

- (void)close
{
    self.userInteractionEnabled = NO;
    [self close:YES];
}

- (void)close:(BOOL)animation
{
    [self close:animation target:nil selector:nil];
}

// Animation 还不知道怎么设置结束后的访问，所以先不做这块，直接最简单的动画效果
- (void)close:(BOOL)animation target:(id)target selector:(SEL)selector
{
    if (target && [target respondsToSelector:selector]) {
        self.target = target;
        self.selector = selector;
    }
    
	[self removeObservers];
    
    if (animation) {
        switch (_animationType) {
            default:{
                UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.mainView.frame];
                //imageView.image = [KBUtil getImageFromView:viewController.view useScreenScale:YES];
                imageView.image = [Utils getImageFromView:self.mainView useScreenScale:NO];
                [self addSubview:imageView];
                
                self.mainView.hidden = YES;
                
                [UIView animateWithDuration:kAnimationTime
                                 animations:^{
                                     imageView.frame = self.fromFrame;
                                     imageView.alpha = 0;
                                     overView.alpha = 0;
                                 } completion:^(BOOL finished) {
                                     [imageView removeFromSuperview];
                                     
                                     for (int i = 0; i < self.mainView.subviews.count;i++)
                                     {
                                         UIView *view = [self.mainView.subviews objectAtIndex:i];
                                         [view removeFromSuperview];
                                         if ([view respondsToSelector:NSSelectorFromString(@"viewDidDisappear")]) {
                                             SEL selector = NSSelectorFromString(@"viewDidDisappear");
                                             IMP imp = [view methodForSelector:selector];
                                             void (*func)(id, SEL) = (void *)imp;
                                             func(view, selector);
                                         }
                                     }
                                     
                                     [self removeFromSuperview];
                                     
                                     [self backToTargetSelector];
                                 }];
                break;
            }
        }
    }else{
        [self removeFromSuperview];
        
        [self backToTargetSelector];
    }
}

-(void)show
{
    [self sizeToFitOrientation:YES];
    UIWindow *window = [[[UIApplication sharedApplication] windows] objectAtIndex:0];
    [window addSubview:self];
    [self tagerViewAnimation:mainView type:_animationType];
    [self addObservers];
}

-(void)showTime:(NSTimeInterval)time withAnimation:(CTAnimationType)animationType
{
    _animationType=animationType;
    [self showWithAnimation:animationType];
    [self performSelector:@selector(close) withObject:nil afterDelay:time];
}

-(void)showWithAnimation:(CTAnimationType)animationType
{
	[self sizeToFitOrientation:YES];
	UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    switch (animationType) {
        case CTAnimationTypeNone:{
            break;
        }
            
        case CTAnimationTypeAlphaTo1:{
            [self tagerViewAnimation:mainView type:4];
            break;
        }
            
        default:{
            [self tagerViewAnimation:mainView type:1];
            break;
        }
    }
    
	[window addSubview:self];
	[self addObservers];
}

//////////////////////////////////////////////////////
// UIDeviceOrientationDidChangeNotification
- (void)deviceOrientationDidChange:(void*)object
{
	UIDeviceOrientation orientation = [UIDevice currentDevice].orientation;
//    MGDebug(@"%d",orientation);
    //如果是支持的旋转方向，且当前视图旋转的角度不等于需要旋转到的角度，则可以旋转到需要的角度。否则不旋转。
	if ([self shouldRotateToOrientation:orientation] && !CGAffineTransformEqualToTransform(self.transform, [self transformForOrientation])) {
		CGFloat duration = [UIApplication sharedApplication].statusBarOrientationAnimationDuration;
		[UIView beginAnimations:nil context:nil];
		[UIView setAnimationDuration:duration];
		[self sizeToFitOrientation:YES];
		[UIView commitAnimations];
	}
}

//////////////////////////////////////////////////////
// UIKeyboardNotifications
- (void) keyboardWillShow:(NSNotification *) notification
{
    //获取键盘高度
//    NSDictionary *userInfo = [notification userInfo];
//    NSValue *keyboardValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
//    CGRect keyboardRect = [keyboardValue CGRectValue];
//    float keyBoardHeight = kSystemVersion8 ? keyboardRect.size.height : keyboardRect.size.width;    //由于ios8和ios7一下如果是横屏的系统宽高刚好放过来，所以反过来
//    CGFloat height = mainView.frame.origin.y+mainView.frame.size.height-keyBoardHeight;
//	if(height > 0){
        mainView.frame = CGRectMake(mainView.frame.origin.x, 80, mainView.frame.size.width, mainView.frame.size.height);
//	}
	_showingKeyboard = YES;
}

- (void) keyboardWillHide:(NSNotification *) notification
{
//    mainView.frame = CGRectMake(mainView.frame.origin.x, mainView.frame.origin.y, mainView.contentSize.width, mainView.contentSize.height);
//    
//    NSInteger x = self.frame.size.width / 2 - ((UIView *)[mainView.subviews objectAtIndex:0]).frame.size.height / 2;
//    NSInteger y = self.frame.size.height / 2 - ((UIView *)[mainView.subviews objectAtIndex:0]).frame.size.width / 2;
	mainView.frame=CGRectMake(mainView.frame.origin.x,174,mainView.frame.size.width,mainView.frame.size.height);
	_showingKeyboard = NO;
}

@end
