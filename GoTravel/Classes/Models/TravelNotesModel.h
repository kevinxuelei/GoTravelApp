//
//  TravelNotesModel.h
//  GoTravel
//
//  Created by lanou3g on 15/11/12.
//  Copyright © 2015年 小辉╰つ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TravelNotesModel : NSObject<NSCoding>


/**每日精选或精选游记的描述标题*/
@property (nonatomic, copy) NSString *index_title;

/**每日精选或精彩游记用户的名字*/
@property (nonatomic, copy) NSString *name;

/**每日精选或精彩(用户名加前by)用户的头像*/
@property (nonatomic, copy) NSString *avatar_m;


/**精彩游记的背景图片*/
@property (nonatomic, copy) NSString *cover_image_w640;



/**精彩游记的市区名*/
@property (nonatomic, copy) NSString *popular_place_str;

/**精彩游记的开始时间*/
@property (nonatomic, copy) NSString *first_day;

/**精彩游记的总共时间数*/
@property (nonatomic, copy) NSString *day_count;

/**浏览次数*/
@property (nonatomic, copy) NSString *view_count;


/**加载更多精彩游记*/
@property (nonatomic, assign) NSInteger next_start;

/**用户ID*/
@property (nonatomic, assign) NSInteger ID;

/**精选游记详情id*/
@property (nonatomic, assign) NSInteger trip_id;

//自定义字典
- (instancetype)initWithDictionary:(NSDictionary *)dictionary;



@end
