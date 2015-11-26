//
//  WonderfulTravelDetailModel.h
//  GoTravel
//
//  Created by lanou3g on 15/11/16.
//  Copyright © 2015年 小辉╰つ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WonderfulTravelDetailModel : NSObject

/**地图图片(带有大头针)*/
@property (nonatomic, copy) NSString *trackpoints_thumbnail_image;

/**user用户头像*/
@property (nonatomic, copy) NSString *avatar_m;

/**user用户姓名*/
@property (nonatomic, copy) NSString *name;

/**游记标题*/
@property (nonatomic, copy) NSString *textName;
/**开始时间*/
@property (nonatomic, copy) NSString *first_day;
/**总天数*/
@property (nonatomic, assign) NSInteger day_count;
/**里程*/
@property (nonatomic, copy) NSString *mileage;

/**喜欢人数*/
@property (nonatomic, copy) NSString *recommendations;

- (instancetype)initWithDictionary:(NSDictionary *)dic;

@end
