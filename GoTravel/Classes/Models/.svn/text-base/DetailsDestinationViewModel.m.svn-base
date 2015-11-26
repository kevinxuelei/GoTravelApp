//
//  DetailsDestinationViewModel.m
//  GoTravel
//
//  Created by lanou3g on 15/11/12.
//  Copyright © 2015年 小辉╰つ. All rights reserved.
//

#import "DetailsDestinationViewModel.h"

@implementation DetailsDestinationViewModel
- (instancetype)initWithDictionary:(NSDictionary *)dict
{
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}
-(void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    //    if ([key isEqualToString:@"photos"]) {
    //        self.photosArray = value;
    //    } else if ([key isEqualToString:@"hot_city"]) {
    //        self.hot_cityArray = value;
    //    } else if ([key isEqualToString:@"new_discount"]) {
    //        self.discountArray = value;
    //    }
    if ([key isEqualToString:@"id"]) {
        self.projectid = value;
    }
    if ([key isEqualToString:@"photos"]) {
        self.photosArray = value;
    }
}
@end
