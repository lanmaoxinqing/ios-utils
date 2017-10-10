//
//  MZActivityViewController.m
//  meizhuang
//
//  Created by Ricky on 16/6/14.
//  Copyright © 2016年 netease. All rights reserved.
//

#import <Masonry/Masonry.h>

#import "MZActivityViewController.h"

#import "UIKit+Beauty.h"

@interface MZActivityViewController () <UIViewControllerTransitioningDelegate, UIViewControllerAnimatedTransitioning>
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UIView *backgroundView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIButton *addButton;
@end

@implementation MZActivityViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.contentHeight = 300.f;
        self.transitioningDelegate = self;
        self.modalPresentationStyle = UIModalPresentationCustom;
        self.title = @"添加到合辑";
    }
    return self;
}

//- (void)setTitle:(NSString *)title
//{
//    [super setTitle:title];
//    if (self.isViewLoaded) {
//        self.titleLabel.text = title;
//    }
//}

- (void)loadView
{
    self.view = [[UIControl alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.view.backgroundColor = [UIColor clearColor];
    [(UIControl *)self.view addTarget:self
                               action:@selector(onDismiss:)
                     forControlEvents:UIControlEventTouchDown];
    
    self.contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.contentHeight)];
    self.contentView.backgroundColor = [UIColor whiteColor];
    self.contentView.bottom = self.view.height;
    self.contentView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    [self.view addSubview:self.contentView];
    
    /*
     self.titleLabel = [[UILabel alloc] init];
     self.titleLabel.font = [UIFont systemFontOfSize:16.f];
     self.titleLabel.textColor = [UIColor defaultNavigationTintColor];
     self.titleLabel.text = self.title;
     [self.contentView addSubview:self.titleLabel];
     [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
     make.left.offset(8.f);
     make.centerY.equalTo(self.contentView.mas_top).offset(20.f);
     }];
     
     self.addButton = [UIButton buttonWithType:UIButtonTypeContactAdd];
     self.addButton.titleLabel.font = [UIFont systemFontOfSize:14.f];
     self.addButton.tintColor = [UIColor defaultNavigationTintColor];
     [self.addButton setTitle:@"新建" forState:UIControlStateNormal];
     [self.addButton setTitleColor:[UIColor defaultNavigationTintColor]
     forState:UIControlStateNormal];
     [self.contentView addSubview:self.addButton];
     [self.addButton mas_makeConstraints:^(MASConstraintMaker *make) {
     make.right.offset(-8.f);
     make.centerY.equalTo(self.contentView.mas_top).offset(20.f);
     }];*/
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    /*
     if ([UIDevice currentDevice].systemVersion.floatValue >= 8.f) {
     UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight];
     UIVisualEffectView *blurView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
     blurView.frame = self.contentView.bounds;
     blurView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
     blurView.userInteractionEnabled = NO;
     [self.contentView insertSubview:blurView
     atIndex:0];
     }
     */
    
    [self setNeedsStatusBarAppearanceUpdate];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (self.isBeingPresented) {
        switch (self.style) {
            case MZActivityPresentationStyleDimmer: {
                self.backgroundView = [[UIView alloc] init];
                self.backgroundView.backgroundColor = [UIColor colorWithWhite:0 alpha:.6];
                break;
            }
            case MZActivityPresentationStyleBlur: {
                UIImage *snapshot = [self.presentingViewController.view mz_snapshotImage];
                self.backgroundView = [[UIImageView alloc] initWithImage:[snapshot stackBlur:10]];
                break;
            }
        }
        self.backgroundView.userInteractionEnabled = NO;
        self.backgroundView.alpha = 0;
    }
}

- (BOOL)shouldAutorotate
{
    return NO;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return UIInterfaceOrientationPortrait;
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    if (self.presentingViewController) {
        self.view.frame = self.presentingViewController.view.frame;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)setContentHeight:(CGFloat)contentHeight
{
    if (_contentHeight != contentHeight) {
        _contentHeight = contentHeight;
        if (self.isViewLoaded) {
            self.contentView.height = contentHeight;
        }
    }
}

- (void)setBackgroundView:(UIView *)backgroundView
{
    if (_backgroundView != backgroundView) {
        [_backgroundView removeFromSuperview];
        
        _backgroundView = backgroundView;
        
        _backgroundView.frame = self.view.bounds;
        _backgroundView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        [self.view insertSubview:_backgroundView atIndex:0];
    }
}

- (void)onDismiss:(id)sender
{
    [self dismissViewControllerAnimated:YES
                             completion:NULL];
}

#pragma mark - UIViewController Transitioning

- (id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented
                                                                   presentingController:(UIViewController *)presenting
                                                                       sourceController:(UIViewController *)source
{
    return self;
}

- (id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed
{
    return self;
}

- (NSTimeInterval)transitionDuration:(id <UIViewControllerContextTransitioning>)transitionContext
{
    return UINavigationControllerHideShowBarDuration;
}

// This method can only  be a nop if the transition is interactive and not a percentDriven interactive transition.
- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext
{
    MZActivityViewController *from = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    MZActivityViewController *to = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    // presenting
    if ([to isKindOfClass:[MZActivityViewController class]]) {
        UIView *containerView = [transitionContext containerView];
        to.view.frame = containerView.bounds;
        to.contentView.top = to.view.height;
        [containerView addSubview:to.view];
        
        [UIView animateWithDuration:[self transitionDuration:transitionContext]
                              delay:0
                            options:UIViewAnimationOptionCurveEaseOut | UIViewAnimationOptionBeginFromCurrentState
                         animations:^{
                             to.backgroundView.alpha = 1;
                             to.contentView.bottom = containerView.height - containerView.top;
                         }
                         completion:^(BOOL finished) {
                             [transitionContext completeTransition:!transitionContext.transitionWasCancelled];
                         }];
    }
    // dismissing
    else if ([from isKindOfClass:[MZActivityViewController class]]) {
        [UIView animateWithDuration:[self transitionDuration:transitionContext]
                              delay:0
                            options:UIViewAnimationOptionCurveEaseIn | UIViewAnimationOptionBeginFromCurrentState
                         animations:^{
                             from.contentView.top = from.view.height;
                             from.backgroundView.alpha = 0;
                         }
                         completion:^(BOOL finished) {
                             [transitionContext completeTransition:!transitionContext.transitionWasCancelled];
                         }];
    }
}


@end
