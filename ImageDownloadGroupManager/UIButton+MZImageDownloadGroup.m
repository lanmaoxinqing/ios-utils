//
//  UIButton+MZImageDownloadGroup.m
//  Meixue
//
//  Created by 心情 on 2017/9/30.
//  Copyright © 2017年 NetEase. All rights reserved.
//

#import "UIButton+MZImageDownloadGroup.h"
#import "MZImageDownloadGroupManager.h"

@implementation UIButton (MZImageDownloadGroup)

+ (void)load {
    //swizz UIButton 图片下载方法
    //    if ([UIButton respondsToSelector:@selector(sd_setImageWithURL:forState:placeholderImage:options:completed:)]) {
    NSLog(@"swizz uibutton");
    Method originImageDownload = class_getInstanceMethod([UIButton class], @selector(sd_setImageWithURL:forState:placeholderImage:options:completed:));
    Method swizzlingImageDownload = class_getInstanceMethod([UIButton class], @selector(mzsd_setImageWithURL:forState:placeholderImage:options:completed:));
    method_exchangeImplementations(originImageDownload, swizzlingImageDownload);
    //    }
}

- (void)mzsd_setImageWithURL:(NSURL *)url forState:(UIControlState)state placeholderImage:(UIImage *)placeholder options:(SDWebImageOptions)options completed:(SDWebImageCompletionBlock)completedBlock {
    //不需要加入统计
    if (!self.mz_inImageDownloadGroup) {
        [self mzsd_setImageWithURL:url forState:state placeholderImage:placeholder options:options completed:completedBlock];
        return;
    }
    self.mz_taskCount ++;//可能未设置manager，本地记录
    [self.mz_imageGroupManager taskRetain];//如果设置了manager，同步
    [self mzsd_setImageWithURL:url forState:state placeholderImage:placeholder options:options completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        self.mz_taskCount --;//可能未设置manager，本地记录
        [self.mz_imageGroupManager taskRelease];//如果设置了manager，同步
        completedBlock(image, error, cacheType, imageURL);
    }];
}

@end
