//
//  DestinationViewControllerModel.h
//  GoTravel
//
//  Created by lanou3g on 15/11/12.
//  Copyright © 2015年 小辉╰つ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DestinationViewControllerModel : NSObject
/*
 "id": 10,
 "cnname": "亚洲",
 "enname": "Asia",
 "hot_country": [],
 "country": []
 
 "id": 11,
 "cnname": "中国",
 "enname": "China",
 "photo": "http://site.qyer.com/uploadfile/2014/0417/20140417012348768.jpg",
 "count": 40,
 "label": "城市",
 "flag": 1
 */
@property (nonatomic, copy) NSString *cnname;
@property (nonatomic, copy) NSString *enname;
@property (nonatomic, copy) NSString *photo;
@property (nonatomic, copy) NSString *count;
@property (nonatomic, copy) NSString *label;
@property (nonatomic, copy) NSString *cityID;
@property (nonatomic, copy) NSString *bigcnname;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
@end
