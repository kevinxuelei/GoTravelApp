//
//  RecommendModel.h
//  GoTravel
//
//  Created by lanou3g on 15/11/12.
//  Copyright © 2015年 小辉╰つ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RecommendModel : NSObject<NSCoding>

/**轮播图图片*/
@property (nonatomic, copy) NSString *image_url;
/**轮播图web*/
@property (nonatomic, copy) NSString *html_url;

/**每日精选的标题*/
@property (nonatomic, copy) NSString *text;

/**每日精选的图片*/ // 全部
@property (nonatomic, copy) NSString *index_cover;


/**每日精选或精选游记的描述标题*/ //全部
@property (nonatomic, copy) NSString *index_title;

/**每日精选或精彩游记用户的名字*/ //全部
@property (nonatomic, copy) NSString *name;


/**每日精选,当点击用户头像进入的背景图*/
@property (nonatomic, copy) NSString *cover;

/**每日精选或精彩(用户名加前by)用户的头像*/  //全部
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


/**用户ID*/
@property (nonatomic, assign) NSInteger ID;


/**点击每日精选详情*/
@property (nonatomic, copy) NSString *spot_id;

//自定义字典
- (instancetype)initWithDictionary:(NSDictionary *)dictionary;




@end
