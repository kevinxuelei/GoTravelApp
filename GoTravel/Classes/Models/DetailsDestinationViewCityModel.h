//
//  DetailsDestinationViewCityModel.h
//  GoTravel
//
//  Created by lanou3g on 15/11/12.
//  Copyright © 2015年 小辉╰つ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DetailsDestinationViewCityModel : NSObject
/*
 "id": 62,
 "country_id": 232,
 "overview_url": "http://appview.qyer.com/place/singapore/profile",城市信息
 "selecthotel_url": "http://appview.qyer.com/index.php?action=hotelDetail&spm=index&aid=352438&cityid=62",酒店
 "photos": [],轮播图
 "country_cnname": "新加坡",
 "country_enname": "Singapore",
 "cnname": "新加坡",
 "enname": "Singapore",
 "entryCont": "[新加坡](Singapore)地处东南亚，总面积仅有710平方公里，是世界上最小的国家之一，被称为“小红点”。尽管面积不大，新加坡却凭其自由贸易经济，高效劳动力和优越的地理位置，成为[亚洲](",
 "new_discount": [],超值自由行
 "local_discount": []精彩当地游
 */
//一区
@property (nonatomic, strong) NSArray *photosArray;
@property (nonatomic, copy) NSString *entryCont;
@property (nonatomic, copy) NSString *overview_url;

@property (nonatomic, copy) NSString *bigcnname;

//二区 三区
@property (nonatomic, copy) NSString *photo;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *priceoff;
@property (nonatomic, copy) NSString *price;
@property (nonatomic, copy) NSString *cityId;//id
@property (nonatomic, copy) NSString *cnname;
/*
 "highlight": {
 "htitle1": "折扣君找亮点",
 "hcontent1": "直飞航班：搭乘直飞，一站直达，省去转机时间以及旅途劳累<br />
 优质酒店：住宿四星时尚酒店，享受更舒适的住宿环境",
 "edittime": 1447401858
 },
 */
@property (nonatomic, copy) NSString *htitle1;
@property (nonatomic, copy) NSString *hcontent1;
@property (nonatomic, copy) NSString *edittime;

- (instancetype)initWithDictionary:(NSDictionary *)dict;

@end