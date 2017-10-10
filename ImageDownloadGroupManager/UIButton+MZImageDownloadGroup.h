//
//  UIButton+MZImageDownloadGroup.h
//  Meixue
//
//  Created by 心情 on 2017/9/30.
//  Copyright © 2017年 NetEase. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (MZImageDownloadGroup)

- (void)mzsd_setImageWithURL:(NSURL *)url forState:(UIControlState)state placeholderImage:(UIImage *)placeholder options:(SDWebImageOptions)options completed:(SDWebImageCompletionBlock)completedBlock;

@end
