//
//  NearbyTableViewModel.h
//  GoTravel
//
//  Created by lanou3g on 15/11/13.
//  Copyright © 2015年 小辉╰つ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NearbyTableViewModel : NSObject

//详情描述
//"description
//图片
 //"cover_s":"http://photos.breadtrip.com/photo_2015_02_19_0aa742b07f7adf96f2eb0c7a2027484c.jpg?imageView/1/w/280/h/280/q/75",
//距离
//"distance": 0.4201673095588781,
//名字
//"name": "便宜坊(五彩城店)",
//想去人数
//"wish_to_go_count": 0,
//点评
//"comments_count": 0,
//推荐
//"recommended": true,

//地址
//address

//行业分类
//icon
//联系方式
//tel
//详情页面分类
//category
//详情页面的大图
//cover

//当前店铺的经纬度位置
//"lat": 40.031808,
//"lng": 116.3389





//店名
@property(nonatomic,copy)NSString *name;
//图片 **
@property(nonatomic,copy)NSString *cover_s;
//点评
@property(nonatomic,copy)NSString *comments_count;
//详情
@property(nonatomic,copy)NSString *mydescription;
//距离
@property(nonatomic,copy)NSString *distance;
//去过的人数
@property(nonatomic,copy)NSString *visited_count;
//推荐理由
@property(nonatomic,copy)NSString *recommended_reason;
//点评数
@property(nonatomic,copy)NSString *tips_count;
//推荐
@property(nonatomic,copy)NSString *recommended;

//地址
@property(nonatomic,copy)NSString *address;
//行业分类(图标)
@property(nonatomic,copy)NSString *icon;
//联系方式
@property(nonatomic,copy)NSString *tel;
//详情页面的大图
@property(nonatomic,copy)NSString *cover;

//当前店铺的纬度
@property(nonatomic,copy)NSString *lat;
//当前店铺的经度
@property(nonatomic,copy)NSString *lng;





-(instancetype)initWithDictionary:(NSDictionary *)dict;




@end
