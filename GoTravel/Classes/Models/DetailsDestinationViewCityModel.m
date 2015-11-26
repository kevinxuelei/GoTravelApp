//
//  DetailsDestinationViewCityModel.m
//  GoTravel
//
//  Created by lanou3g on 15/11/12.
//  Copyright © 2015年 小辉╰つ. All rights reserved.
//

#import "DetailsDestinationViewCityModel.h"

@implementation DetailsDestinationViewCityModel

- (instancetype)initWithDictionary:(NSDictionary *)dict
{
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}
-(void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    if ([key isEqualToString:@"photos"]) {
        self.photosArray = value;
    }
    if ([key isEqualToString:@"id"]) {
        self.cityId = value;
    }
}
@end