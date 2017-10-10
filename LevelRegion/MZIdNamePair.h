//
//  MZIdNamePair.h
//  meizhuang
//
//  Created by shinn on 2016/9/23.
//  Copyright © 2016年 netease. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <YYModel/YYModel.h>

@interface MZIdNamePair : NSObject <YYModel, NSCoding>
@property (nonatomic) NSString *id;
@property (nonatomic) NSString *name;

@end
