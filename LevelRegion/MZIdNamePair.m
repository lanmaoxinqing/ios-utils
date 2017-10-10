//
//  MZIdNamePair.m
//  meizhuang
//
//  Created by shinn on 2016/9/23.
//  Copyright © 2016年 netease. All rights reserved.
//

#import "MZIdNamePair.h"

@implementation MZIdNamePair

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self) {
        self.id = [aDecoder decodeObjectForKey:NSStringFromSelector(@selector(id))];
        self.name = [aDecoder decodeObjectForKey:NSStringFromSelector(@selector(name))];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    if (self.id) {
        [aCoder encodeObject:self.id forKey:NSStringFromSelector(@selector(id))];
    }
    if (self.name) {
        [aCoder encodeObject:self.name forKey:NSStringFromSelector(@selector(name))];
    }
}

- (NSString *)debugDescription
{
    return [NSString stringWithFormat:@"<%@: %p, id: %@, name: %@>", NSStringFromClass(self.class), self, self.id, self.name];
}

#pragma mark ================ address ================
+ (NSDictionary<NSString *,id> *)modelCustomPropertyMapper {
    return @{
             @"name" : @[ @"name", @"locationName" ],
             };
}


@end
