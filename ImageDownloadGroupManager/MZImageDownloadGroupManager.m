//
//  MZImageDownloadGroupManager.m
//  Meixue
//
//  Created by 心情 on 2017/9/29.
//  Copyright © 2017年 NetEase. All rights reserved.
//

#import "MZImageDownloadGroupManager.h"

@implementation UIView(MZImageDownloadGroup)

- (void)setMz_inImageDownloadGroup:(BOOL)mz_inImageDownloadGroup {
    objc_setAssociatedObject(self, @selector(mz_inImageDownloadGroup), @(mz_inImageDownloadGroup), OBJC_ASSOCIATION_ASSIGN);
}

- (BOOL)mz_inImageDownloadGroup {
    BOOL result = NO;
    if ([self isKindOfClass:[UIImageView class]] ||
        [self isKindOfClass:[UIButton class]]) {
        result = YES;
    }
    id obj = objc_getAssociatedObject(self, @selector(mz_inImageDownloadGroup));
    if (obj) {
        result = [obj boolValue];
    }
    return result;
}

- (void)setMz_taskCount:(NSUInteger)mz_taskCount {
    objc_setAssociatedObject(self, @selector(mz_taskCount), @(mz_taskCount), OBJC_ASSOCIATION_ASSIGN);
}

- (NSUInteger)mz_taskCount {
    id obj = objc_getAssociatedObject(self, @selector(mz_taskCount));
    if (obj) {
        return [obj intValue];
    }
    return 0;
}

- (void)setMz_imageGroupManager:(MZImageDownloadGroupManager *)mz_imageGroupManager {
    //任务数量同步
    for (int i = 0; i < self.mz_taskCount; i++) {
        [mz_imageGroupManager taskRetain];
    }
    objc_setAssociatedObject(self, @selector(mz_imageGroupManager), mz_imageGroupManager, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (MZImageDownloadGroupManager *)mz_imageGroupManager {
    MZImageDownloadGroupManager *manager = objc_getAssociatedObject(self, @selector(mz_imageGroupManager));
    return manager;
}

@end

//MARK:- manager
@interface MZImageDownloadGroupManager()

@property (atomic, assign) NSUInteger taskCount;
@property (nonatomic, copy) void (^completion)();


@end

@implementation MZImageDownloadGroupManager

- (instancetype)init
{
    self = [self initWithRootView:nil];
    return self;
}

- (instancetype)initWithRootView:(UIView *)rootView {
    if (self = [super init]) {
        [self setupManagerInRootView:rootView];
    }
    return self;
}


- (instancetype)initWithRootView:(UIView *)rootView allTaskFinishedCompletion:(void (^)())completion {
    self = [self initWithRootView:rootView];
    if (self) {
        self.completion = completion;
    }
    return self;
}

- (void)setupManagerInRootView:(UIView *)rootView {
    for (UIView *subview in rootView.subviews) {
        if (subview.mz_inImageDownloadGroup) {
            subview.mz_imageGroupManager = self;
        }
        [self setupManagerInRootView:subview];
    }
}

- (void)taskRetain {
    self.taskCount ++;
    if ([self.delegate respondsToSelector:@selector(imageDownloadGroupManagerDidAddTask:)]) {
        [self.delegate imageDownloadGroupManagerDidAddTask:self];
    }
}

- (void)taskRelease {
    self.taskCount --;
    if ([self.delegate respondsToSelector:@selector(imageDownloadGroupManagerDidRemoveTask:)]) {
        [self.delegate imageDownloadGroupManagerDidRemoveTask:self];
    }
    
    if (self.taskCount == 0) {
        if ([self.delegate respondsToSelector:@selector(imageDownloadGroupManagerDidAllTaskFinished:)]) {
            [self.delegate imageDownloadGroupManagerDidAllTaskFinished:self];
        }
        if (self.completion) {
            self.completion();
        }
    }
}



@end

