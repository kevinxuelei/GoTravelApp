//
//  DetailsDestinationViewModel.h
//  GoTravel
//
//  Created by lanou3g on 15/11/12.
//  Copyright © 2015年 小辉╰つ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DetailsDestinationViewModel : NSObject
/*
 "id": "11",
 "cnname": "中国",
 "enname": "China",
 "photos": [],轮播图数组
 "overview_url": "http://appview.qyer.com/place/china/ctyprofile?spm=app",概述
 "entryCont": "普通话在大部分地区适用，部分地区通用维吾尔语，蒙古语，藏语，壮语，傣语，哈萨克语等",
 "hot_city": [
 "id": "52",
 "cnname": "台北",
 "enname": "Taipei",
 "photo": "http://pi
 ],热门城市
 "new_discount": [
 "id": "57377",
 "title": "【多个假期】全国多地直飞三亚5-6天自由行(入住五星酒店,多重优惠)",
 "price": "<em>1290</em>元起",
 "priceoff": "4.8折",
 "expire_date": "2016年10月22日结束",
 "photo": "http://p
 ]超值自由行
 */
@property (nonatomic, copy) NSString *overview_url;

@property (nonatomic, copy) NSString *bigcnname;
@property (nonatomic, copy) NSString *enname;

@property (nonatomic, copy) NSString *photo;
//传入下一页
@property (nonatomic, copy) NSString *cnname;
@property (nonatomic, copy) NSString *cnnameStr;
@property (nonatomic, copy) NSString *projectid;

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *price;
@property (nonatomic, copy) NSString *priceoff;
@property (nonatomic, copy) NSString *expire_date;

@property (nonatomic, copy) NSString *entryCont;
@property (nonatomic, strong) NSArray *photosArray;

- (instancetype)initWithDictionary:(NSDictionary *)dict;
@end
