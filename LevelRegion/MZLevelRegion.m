//
//  MZLevelRegion.m
//  Meixue
//
//  Created by 心情 on 2017/7/10.
//  Copyright © 2017年 NetEase. All rights reserved.
//

#import "MZLevelRegion.h"

@implementation MZLevelRegion

- (NSString *)componentsJoinedByString:(NSString *)separator {
    NSMutableArray *arr = [NSMutableArray array];
    if (self.province.name) {
        [arr addObject:self.province.name];
    }
    if (self.city.name) {
        [arr addObject:self.city.name];
    }
    if (self.county.name) {
        [arr addObject:self.county.name];
    }
    return [arr componentsJoinedByString:separator];
}

@end

@implementation MZLevelRegionItem

+ (NSDictionary<NSString *,id> *)modelCustomPropertyMapper {
    return @{
             @"subItems" : @[@"subItems", @"items"],
             };
}

- (BOOL)modelCustomTransformFromDictionary:(NSDictionary *)dic {
    NSString *regionId, *name;
    id tempId = dic[@"id"];
    if ([tempId isKindOfClass:[NSNumber class]]) {
        regionId = [(NSNumber *)tempId stringValue];
    }
    id tempName = dic[@"name"];
    if ([tempName isKindOfClass:[NSString class]]) {
        name = [tempName copy];
    }
    self.info = [[MZIdNamePair alloc] init];
    self.info.id = regionId;
    self.info.name = name;
    
    return YES;
}

+ (NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass {
    return @{
             @"subItems" : [MZLevelRegionItem class],
             };
}

@end
