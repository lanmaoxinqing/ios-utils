//
//  UIImageView+ImageDownloadGroup.m
//  Meixue
//
//  Created by 心情 on 2017/9/30.
//  Copyright © 2017年 NetEase. All rights reserved.
//

#import "UIImageView+MZImageDownloadGroup.h"
#import "MZImageDownloadGroupManager.h"

@implementation UIImageView (MZImageDownloadGroup)

+ (void)load {
    //swizz UIImageView 图片下载方法
    //    if ([UIImageView respondsToSelector:@selector(sd_setImageWithURL:placeholderImage:options:progress:completed:)]) {
    NSLog(@"swizz imageview");
    Method originImageDownload = class_getInstanceMethod([UIImageView class], @selector(sd_setImageWithURL:placeholderImage:options:progress:completed:));
    Method swizzlingImageDownload = class_getInstanceMethod([UIImageView class], @selector(mzsd_setImageWithURL:placeholderImage:options:progress:completed:));
    method_exchangeImplementations(originImageDownload, swizzlingImageDownload);
    //    }
}

- (void)mzsd_setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder options:(SDWebImageOptions)options progress:(SDWebImageDownloaderProgressBlock)progressBlock completed:(SDWebImageCompletionBlock)completedBlock {
    //不需要加入统计
    if (!self.mz_inImageDownloadGroup) {
        [self mzsd_setImageWithURL:url placeholderImage:placeholder options:options progress:progressBlock completed:completedBlock];
        return;
    }
    if (self.mz_imageGroupManager) {
        [self.mz_imageGroupManager taskRetain];//如果设置了manager，同步
    } else {
        self.mz_taskCount ++;//可能未设置manager，本地记录
    }
    [self mzsd_setImageWithURL:url placeholderImage:placeholder options:options progress:progressBlock completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if (self.mz_imageGroupManager) {
            [self.mz_imageGroupManager taskRelease];//如果设置了manager，同步
        } else {
            self.mz_taskCount --;//可能未设置manager，本地记录
        }
        completedBlock(image, error, cacheType, imageURL);
    }];
}

@end
