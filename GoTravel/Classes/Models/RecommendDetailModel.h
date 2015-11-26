//
//  RecommendDetailModel.h
//  GoTravel
//
//  Created by lanou3g on 15/11/15.
//  Copyright © 2015年 小辉╰つ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RecommendDetailModel : NSObject


/**故事详情用户头像*/
@property (nonatomic, copy) NSString *avatar_m;

/**故事详情用户名字*/
@property (nonatomic, copy) NSString *name;

/**故事详情 固定写法: 故事发生在sopt -- poi -- name */
@property (nonatomic, copy) NSString *AddressName;

/**故事详情 描述 spot -- text*/
@property (nonatomic, copy) NSString *text;

/**故事详情图片的接口 spot--detail_list -- photo_w640*/
@property (nonatomic, copy) NSString *photo_w640;

/**故事详情图片的接口 spot--detail_list -- text*/
@property (nonatomic, copy) NSString *detailText;

/*
 
 data-spot--recommendations :评论人的信息
 
 */

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;


@end
