//
//  MZActivityViewController.h
//  meizhuang
//
//  Created by Ricky on 16/6/14.
//  Copyright © 2016年 netease. All rights reserved.
//

#import "MZViewController.h"

typedef NS_ENUM(NSInteger, MZActivityPresentationStyle) {
    MZActivityPresentationStyleDimmer,
    MZActivityPresentationStyleBlur
};

@interface MZActivityViewController : MZViewController
@property (nonatomic, readonly, strong) UIView *contentView;
@property (nonatomic, assign) CGFloat contentHeight;    // default 300, set before present, or it won't work
@property (nonatomic, assign) MZActivityPresentationStyle style;
@end
