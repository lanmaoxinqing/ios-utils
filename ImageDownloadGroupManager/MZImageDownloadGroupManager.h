//
//  MZImageDownloadGroupManager.h
//  Meixue
//
//  Created by 心情 on 2017/9/29.
//  Copyright © 2017年 NetEase. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MZImageDownloadGroupManager;
@protocol MZImageDownloadGroupManagerDelegate<NSObject>

@optional
- (void)imageDownloadGroupManagerDidAddTask:(MZImageDownloadGroupManager *)manager;
- (void)imageDownloadGroupManagerDidRemoveTask:(MZImageDownloadGroupManager *)manager;
- (void)imageDownloadGroupManagerDidAllTaskFinished:(MZImageDownloadGroupManager *)manager;

@end

/**
 管理指定视图下的图片下载，所有图片下载完成后，发出通知
 */
@interface MZImageDownloadGroupManager : NSObject

@property (nonatomic, weak) id<MZImageDownloadGroupManagerDelegate> delegate;


/**
 初始化，给指定视图下的子视图设置manager
 @param rootView 根视图
 @return manager实例
 */
- (instancetype)initWithRootView:(UIView *)rootView NS_DESIGNATED_INITIALIZER;
- (instancetype)initWithRootView:(UIView *)rootView allTaskFinishedCompletion:(void (^)())completion;
- (void)taskRetain;//增加一个任务下载数量
- (void)taskRelease;//减少一个任务下载数量

@end


@interface UIView (MZImageDownloadGroup)

@property (nonatomic, assign) NSUInteger mz_taskCount;//正在进行的任务数量，可能未设置manager，本地记录
@property (nonatomic, assign) BOOL mz_inImageDownloadGroup;//是否需要记录下载状态，默认UIImageView和UIButton为YES，其他为NO
@property (nonatomic, strong) MZImageDownloadGroupManager *mz_imageGroupManager;//任务上报的manager，由外部绑定。设置时会把本地taskCount同步至manager

@end

