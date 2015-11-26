//
//  PictureImageModel.h
//  GoTravel
//
//  Created by lanou3g on 15/11/16.
//  Copyright © 2015年 小辉╰つ. All rights reserved.
//播放图片

#import <Foundation/Foundation.h>

@interface PictureImageModel : NSObject

/**图片url*/
@property (nonatomic, copy) NSString *photo_s;

/**清晰*/
@property (nonatomic, copy) NSString *photo_webtrip;

/**user用户头像*/
@property (nonatomic, copy) NSString *avatar_m;

/**维度*/
@property (nonatomic, assign) double latitude;

/**经度*/
@property (nonatomic, assign) double longitude;

- (instancetype)initWithDictionary:(NSDictionary *)dic;

@end
