//
//  MZLevelRegion.h
//  Meixue
//
//  Created by 心情 on 2017/7/10.
//  Copyright © 2017年 NetEase. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MZIdNamePair.h"


/**
 省市县三级区域
 */
@interface MZLevelRegion : NSObject

@property (nonatomic, strong) MZIdNamePair *province;
@property (nonatomic, strong) MZIdNamePair *city;
@property (nonatomic, strong) MZIdNamePair *county;

- (NSString *)componentsJoinedByString:(NSString *)separator;

@end

@interface MZLevelRegionItem : NSObject<YYModel>

@property (nonatomic, strong) MZIdNamePair *info;
@property (nonatomic, strong) NSArray<MZLevelRegionItem *> *subItems;

@end
