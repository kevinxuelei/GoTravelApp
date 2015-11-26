//
//  NearbyTableViewModel.m
//  GoTravel
//
//  Created by lanou3g on 15/11/13.
//  Copyright © 2015年 小辉╰つ. All rights reserved.
//

#import "NearbyTableViewModel.h"

@implementation NearbyTableViewModel

-(void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    if ([key isEqualToString:@"description"]) {
        self.mydescription = value;
    }


}

-(instancetype)initWithDictionary:(NSDictionary *)dict
{
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:dict];
    }
    
    return self;

}





@end
