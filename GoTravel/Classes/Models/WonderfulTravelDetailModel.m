//
//  WonderfulTravelDetailModel.m
//  GoTravel
//
//  Created by lanou3g on 15/11/16.
//  Copyright © 2015年 小辉╰つ. All rights reserved.
//游记详情界面

#import "WonderfulTravelDetailModel.h"

@implementation WonderfulTravelDetailModel

- (instancetype)initWithDictionary:(NSDictionary *)dic
{
    self = [super init];
    
    if (self) {
        
        [self setValuesForKeysWithDictionary:dic];
    }

    return self;
    
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{



}

@end
