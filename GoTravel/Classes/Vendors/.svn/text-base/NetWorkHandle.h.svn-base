//
//  NetWorkHandle.h
//  NetWork
//
//  Created by lanou3g on 15/10/5.
//  Copyright (c) 2015年 魏义涛. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^MyBlock)(id object);

@interface NetWorkHandle : NSObject

//get
- (void)getDataWithURLString:(NSString *)string compare:(MyBlock)block;
+ (void)getDataWithURLString:(NSString *)string compare:(MyBlock)block;
//post
- (void)postDataWithURLString:(NSString *)string andBodyString:(NSString *)bodyString compare:(MyBlock)block;
+ (void)postDataWithURLString:(NSString *)string andBodyString:(NSString *)bodyString compare:(MyBlock)block;
@end
