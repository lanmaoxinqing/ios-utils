//
//  MZLevelRegionPickerViewController.h
//  Meixue
//
//  Created by 心情 on 2017/7/10.
//  Copyright © 2017年 NetEase. All rights reserved.
//

#import "MZActivityViewController.h"
#import "MZLevelRegion.h"

@class MZLevelRegionPickerViewController;

@protocol MZLevelRegionPickerDelegate <NSObject>

- (void)levelRegionPicker:(MZLevelRegionPickerViewController *)picker didSelectRegion:(MZLevelRegion *)region;
- (void)levelRegionPickerDidCancel:(MZLevelRegionPickerViewController *)picker;

@end

@interface MZLevelRegionPickerViewController : MZActivityViewController

@property (nonatomic, weak) id<MZLevelRegionPickerDelegate> delegate;
@property (nonatomic, strong) MZLevelRegion *selectedRegion;

@end
