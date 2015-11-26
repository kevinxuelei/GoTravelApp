//
//  RecommendDetailModel.m
//  GoTravel
//
//  Created by lanou3g on 15/11/15.
//  Copyright © 2015年 小辉╰つ. All rights reserved.
//

#import "RecommendDetailModel.h"

@implementation RecommendDetailModel


- (instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    
    self = [super init];
    
    if (self) {
        
        [self setValuesForKeysWithDictionary:dictionary];
    }

    return self;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
//    if ([key isEqualToString:@"id"]) {
//        
//        //self.ID = value;
//    }

}


@end
