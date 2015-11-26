//
//  DataBaseTool.h
//  GoTravel
//
//  Created by lanou3g on 15/11/22.
//  Copyright © 2015年 小辉╰つ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFHTTPRequestOperationManager.h"
@class RecommendModel;
@class TravelNotesModel;
@interface DataBaseTool : NSObject

//创建单利对象
+ (instancetype)shareHandle;

/**
 *  AFNetworkReachabilityStatusUnknown          = -1,  // 未知
 *  AFNetworkReachabilityStatusNotReachable     = 0,   // 无连接
 *  AFNetworkReachabilityStatusReachableViaWWAN = 1,   // 3G
 *  AFNetworkReachabilityStatusReachableViaWiFi = 2,   // 局域网络Wifi
 */
+ (void)checkNetWorkStatus:(void (^)(AFNetworkReachabilityStatus status))block;




#pragma mark ---获取数据库路径
- (NSString *)getDataBasePath;
#pragma mark ---打开数据库
- (void)openData;
#pragma mark ---创建表格
/**创建推荐界面的轮播图数据表*/
- (void)createRecommendOneTable;
/**创建推荐界面的每日精彩故事数据表*/
- (void)createRecommendTwoTable;
/**创建推荐界面的精彩游记数据表*/
- (void)createRecommendThreeTable;
#pragma mark ---插入数据
/**插入推荐界面的轮播图数据表*/
- (void)insertIntoRecommendOneModel:(RecommendModel *)model;
/**插入推荐界面的每日精彩故事数据表*/
- (void)insertIntoRecommendTwoModel:(RecommendModel *)model;
/**插入推荐界面的精彩游记数据表*/
- (void)insertIntoRecommendThreeModel:(TravelNotesModel *)model;

#pragma mark ---获取数据
/**获取推荐界面的轮播图数据表*/
- (NSMutableArray *)selectRecommendOneModelFormTable;
/**获取推荐界面的每日精彩故事数据表*/
- (NSMutableArray *)selectRecommendTwoModelFromTable;
/**获取推荐界面的精彩游记数据表*/
- (NSMutableArray *)selectRecommendThreeModelFromTable;

#pragma mark ---删除数据
/**删除推荐界面的全部数据表*/
- (void)deleteAllData;
/**删除推荐界面的轮播图数据表*/
- (void)DELETERecommendOneTable;
/**删除推荐界面的每日精彩故事数据表*/
- (void)DELETERecommendTwoTable;
/**删除推荐界面的精彩游记数据表*/
- (void)DELETERecommendThreeTable;
#pragma mark ---更新数据
- (void)updateRecommendOneTableData:(RecommendModel *)model;


#pragma mark ---关闭数据库
- (void)closeDataBase;

#pragma mark ---提示用户网络未连接
- (void)alertInternetNotOpen:(UIViewController *)controll;
#pragma mark ----加载视觉效果图
- (void)LoadVisualEffectViews:(UIViewController *)controll;

@end
