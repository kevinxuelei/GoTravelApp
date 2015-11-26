//
//  RecommendModel.m
//  GoTravel
//
//  Created by lanou3g on 15/11/12.
//  Copyright © 2015年 小辉╰つ. All rights reserved.
//

#import "RecommendModel.h"

@implementation RecommendModel

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
    
    
    [aCoder encodeObject:self.image_url forKey:@"image_url"];
    [aCoder encodeObject:self.html_url forKey:@"html_url"];
    [aCoder encodeObject:self.text forKey:@"text"];
    [aCoder encodeObject:self.index_cover forKey:@"index_cover"];
    [aCoder encodeObject:self.index_title forKey:@"index_title"];
    [aCoder encodeObject:self.name forKey:@"name"];
    [aCoder encodeObject:self.cover forKey:@"cover"];
    [aCoder encodeObject:self.avatar_m forKey:@"avatar_m"];
    [aCoder encodeObject:self.cover_image_w640 forKey:@"cover_image_w640"];
    [aCoder encodeObject:self.popular_place_str forKey:@"popular_place_str"];
    [aCoder encodeObject:self.first_day forKey:@"first_day"];
    [aCoder encodeObject:self.day_count forKey:@"day_count"];
    [aCoder encodeObject:self.view_count forKey:@"view_count"];
  
    [aCoder encodeObject:self.spot_id forKey:@"spot_id"];
 
    [aCoder encodeInteger:self.ID forKey:@"ID"];


}

- (instancetype)initWithCoder:(NSCoder *)aDecoder{

    
    self = [super init];
    if (self) {
        
        self.image_url = [aDecoder decodeObjectForKey:@"image_url"];
        self.html_url = [aDecoder decodeObjectForKey:@"html_url"];
        self.text = [aDecoder decodeObjectForKey:@"text"];
        self.index_cover = [aDecoder decodeObjectForKey:@"index_cover"];
        self.index_title = [aDecoder decodeObjectForKey:@"index_title"];
        self.name = [aDecoder decodeObjectForKey:@"name"];
        self.cover = [aDecoder decodeObjectForKey:@"cover"];
        self.avatar_m = [aDecoder decodeObjectForKey:@"avatar_m"];
        self.cover_image_w640 = [aDecoder decodeObjectForKey:@"cover_image_w640"];
        self.popular_place_str = [aDecoder decodeObjectForKey:@"popular_place_str"];
        self.first_day = [aDecoder decodeObjectForKey:@"first_day"];
        self.day_count = [aDecoder decodeObjectForKey:@"day_count"];
        self.view_count = [aDecoder decodeObjectForKey:@"view_count"];
        self.spot_id = [aDecoder decodeObjectForKey:@"spot_id"];
        self.ID = [aDecoder decodeIntForKey:@"ID"];
    }

    return self;
}

@end
