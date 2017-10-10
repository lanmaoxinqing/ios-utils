//
//  UIImageView+ImageDownloadGroup.h
//  Meixue
//
//  Created by 心情 on 2017/9/30.
//  Copyright © 2017年 NetEase. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView (MZImageDownloadGroup)

- (void)mzsd_setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder options:(SDWebImageOptions)options progress:(SDWebImageDownloaderProgressBlock)progressBlock completed:(SDWebImageCompletionBlock)completedBlock;

@end
