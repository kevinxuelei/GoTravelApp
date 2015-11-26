//
//  TravelNotesModel.m
//  GoTravel
//
//  Created by lanou3g on 15/11/12.
//  Copyright © 2015年 小辉╰つ. All rights reserved.
//

#import "TravelNotesModel.h"

@implementation TravelNotesModel



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
    
    
    
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.index_title forKey:@"index_title"];
    [aCoder encodeObject:self.name forKey:@"name"];
    [aCoder encodeObject:self.avatar_m forKey:@"avatar_m"];
    [aCoder encodeObject:self.cover_image_w640 forKey:@"cover_image_w640"];
    [aCoder encodeObject:self.popular_place_str forKey:@"popular_place_str"];
    [aCoder encodeObject:self.first_day forKey:@"first_day"];
    [aCoder encodeObject:self.day_count forKey:@"day_count"];
    [aCoder encodeObject:self.view_count forKey:@"view_count"];
    [aCoder encodeInteger:self.next_start forKey:@"next_start"];
    [aCoder encodeInteger:self.trip_id forKey:@"trip_id"];
    [aCoder encodeInteger:self.ID forKey:@"ID"];
    
    
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    
    
    self = [super init];
    if (self) {
        
        self.index_title = [aDecoder decodeObjectForKey:@"index_title"];
        self.name = [aDecoder decodeObjectForKey:@"name"];
        self.avatar_m = [aDecoder decodeObjectForKey:@"avatar_m"];
        self.cover_image_w640 = [aDecoder decodeObjectForKey:@"cover_image_w640"];
        self.popular_place_str = [aDecoder decodeObjectForKey:@"popular_place_str"];
        self.first_day = [aDecoder decodeObjectForKey:@"first_day"];
        self.day_count = [aDecoder decodeObjectForKey:@"day_count"];
        self.view_count = [aDecoder decodeObjectForKey:@"view_count"];
        self.ID = [aDecoder decodeIntegerForKey:@"ID"];
        self.trip_id = [aDecoder decodeIntegerForKey:@"trip_id"];
        self.next_start = [aDecoder decodeIntegerForKey:@"next_start"];

    }
    
    return self;
}


@end
