//
//  DataBaseTool.m
//  GoTravel
//
//  Created by lanou3g on 15/11/22.
//  Copyright © 2015年 小辉╰つ. All rights reserved.
//

#import "DataBaseTool.h"
#import "RecommendModel.h"
#import "TravelNotesModel.h"
#import "FMDB.h"
@implementation DataBaseTool



/**
 *  AFNetworkReachabilityStatusUnknown          = -1,  // 未知
 *  AFNetworkReachabilityStatusNotReachable     = 0,   // 无连接
 *  AFNetworkReachabilityStatusReachableViaWWAN = 1,   // 3G
 *  AFNetworkReachabilityStatusReachableViaWiFi = 2,   // 局域网络Wifi
 */
+ (void)checkNetWorkStatus:(void (^)(AFNetworkReachabilityStatus status))block{
    
    // 如果要检测网络状态的变化, 必须要用检测管理器的单例startMoitoring
    
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    // 检测网络连接的单例,网络变化时的回调方法
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        
#pragma mark--- 回传回去网络的状态
        block( status );
        
        if(status == AFNetworkReachabilityStatusNotReachable){
            
            NSLog(@"网络连接已断开，请检查您的网络！");
            
            return ;
        }
    }];
    
}


//创建单利对象
+ (instancetype)shareHandle
{
    
    static DataBaseTool *dataBase = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        dataBase = [[DataBaseTool alloc] init];
        
    });

    return dataBase;

}
//首先创建数据库
static FMDatabase *db = nil;

#pragma mark ---获取数据库路径
- (NSString *)getDataBasePath{

    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)lastObject];
}
#pragma mark ---打开数据库
- (void)openData{
    NSString *pathStr = [self getDataBasePath];
    NSLog(@"数据库存储的路径 %@",pathStr);
    pathStr  = [pathStr stringByAppendingString:@"/baseData.sqlite"];
    db = [FMDatabase databaseWithPath:pathStr];
    if ([db open]) {
        NSLog(@"数据库打开成功");
    }else{
        NSLog(@"数据库打开失败");
        
    }
    
}
#pragma mark ---创建表格
- (void)createRecommendOneTable{
    [db executeUpdate:@"CREATE TABLE IF NOT EXISTS RecommendOneTable (ID INTEGER PRIMARY KEY AUTOINCREMENT, image_url TEXT,html_url TEXT)"];
}
- (void)createRecommendTwoTable{
    //model.name model.avatar_m model.index_title model.index_cover
    [db executeUpdate:@"CREATE TABLE IF NOT EXISTS RecommendTwoTable (name TEXT PRIMARY KEY, avatar_m TEXT, index_title TEXT, index_cover TEXT, spot_id TEXT)"];
    
    
}
- (void)createRecommendThreeTable{
    //model.cover_image_w640  model.index_title   model.first_day model.day_count model.view_count model.popular_place_str model.avatar_m model.name
    [db executeUpdate:@"CREATE TABLE IF NOT EXISTS RecommendThreeTable (name TEXT PRIMARY KEY, cover_image_w640 TEXT, index_title TEXT, first_day TEXT, day_count TEXT, view_count TEXT, popular_place_str TEXT, avatar_m TEXT, ID integer, next_start integer)"];
    
    
    
}
#pragma mark ---插入数据
/**插入推荐界面的轮播图数据表*/
- (void)insertIntoRecommendOneModel:(RecommendModel *)model{
  BOOL ret = [db executeUpdate:@"INSERT INTO RecommendOneTable (image_url, html_url) VALUES (?,?);",model.image_url,model.html_url];
    if (ret) {
        NSLog(@"插入成功");
    }else{
        NSLog(@"插入失败");
    }

}
/**插入推荐界面的每日精彩故事数据表*/
- (void)insertIntoRecommendTwoModel:(RecommendModel *)model{
 BOOL ret = [db executeUpdate:@"INSERT INTO RecommendTwoTable (name, avatar_m, index_title, index_cover, spot_id) VALUES (?,?,?,?,?);",model.name,model.avatar_m,model.index_title,model.index_cover,model.spot_id];
    if (ret) {
        NSLog(@"插入成功");
    }else{
        NSLog(@"插入失败");
    }
}
/**插入推荐界面的精彩游记数据表*/
- (void)insertIntoRecommendThreeModel:(TravelNotesModel *)model{
 BOOL ret = [db executeUpdate:@"INSERT INTO RecommendThreeTable (name, cover_image_w640, index_title, first_day, day_count, view_count, popular_place_str, avatar_m, ID, next_start) VALUES (?,?,?,?,?,?,?,?,?,?);",model.name,model.cover_image_w640,model.index_title,model.first_day,model.day_count,model.view_count,model.popular_place_str,model.avatar_m,[NSNumber numberWithInteger:model.ID],[NSNumber numberWithInteger:model.next_start]];
    if (ret) {
        NSLog(@"插入成功");
    }else{
        NSLog(@"插入失败");
    }

}

#pragma mark ---获取数据
/**获取推荐界面的轮播图数据表*/
- (NSMutableArray *)selectRecommendOneModelFormTable{
    NSMutableArray *array = [NSMutableArray array];
    FMResultSet *set = [db executeQuery:@"SELECT *FROM RecommendOneTable"];
    while (set.next) {
        RecommendModel *model = [[RecommendModel alloc] init];
        model.image_url = [set stringForColumn:@"image_url"];
        model.html_url = [set stringForColumn:@"html_url"];
        [array addObject:model];

    }
    return array;
}
/**获取推荐界面的每日精彩故事数据表*/
- (NSMutableArray *)selectRecommendTwoModelFromTable{

    NSMutableArray *array = [NSMutableArray array];
    FMResultSet *set = [db executeQuery:@"SELECT *FROM RecommendTwoTable"];
    while (set.next) {
        
        RecommendModel *model = [[RecommendModel alloc] init];
        model.name = [set stringForColumn:@"name"];
        model.avatar_m = [set stringForColumn:@"avatar_m"];
        model.index_title = [set stringForColumn:@"index_title"];
        model.index_cover = [set stringForColumn:@"index_cover"];
        model.spot_id = [set stringForColumn:@"spot_id"];
        [array addObject:model];
        
        
    }

    return array;
}
/**获取推荐界面的精彩游记数据表*/
- (NSMutableArray *)selectRecommendThreeModelFromTable{

    NSMutableArray *array = [NSMutableArray array];
    FMResultSet *set = [db executeQuery:@"SELECT *FROM RecommendThreeTable"];
    while (set.next) {
        TravelNotesModel *model = [[TravelNotesModel alloc] init];
        model.cover_image_w640 = [set stringForColumn:@"cover_image_w640"];
        model.index_title = [set stringForColumn:@"index_title"];
        model.first_day = [set stringForColumn:@"first_day"];
        model.day_count = [set stringForColumn:@"day_count"];
        model.view_count = [set stringForColumn:@"view_count"];
        model.popular_place_str = [set stringForColumn:@"popular_place_str"];
        model.avatar_m = [set stringForColumn:@"avatar_m"];
        model.name = [set stringForColumn:@"name"];
        model.ID = [set longForColumn:@"ID"];
        
        model.next_start = [set longForColumn:@"next_start"];
        [array addObject:model];
        
    }
    return array;
}

#pragma mark ---删除数据
/**删除推荐界面的全部数据表*/
- (void)deleteAllData{
    [db executeUpdate:@"DELETE FROM RecommendOneTable"];
    [db executeUpdate:@"DELETE FROM RecommendTwoTable"];
    [db executeUpdate:@"DELETE FROM RecommendThreeTable"];
}
/**删除推荐界面的轮播图数据表*/
- (void)DELETERecommendOneTable{
  BOOL ret =[db executeUpdate:@"DELETE FROM RecommendOneTable"];
    if (ret) {
        NSLog(@"删除成功");
    }else{
        NSLog(@"删除失败");
    }
}
/**删除推荐界面的每日精彩故事数据表*/
- (void)DELETERecommendTwoTable{
  BOOL ret =  [db executeUpdate:@"DELETE FROM RecommendTwoTable"];
    if (ret) {
        NSLog(@"删除成功");
    }else{
        NSLog(@"删除失败");
    }
}
/**删除推荐界面的精彩游记数据表*/
- (void)DELETERecommendThreeTable{
  BOOL ret =  [db executeUpdate:@"DELETE FROM RecommendThreeTable"];
    if (ret) {
        NSLog(@"删除成功");
    }else{
        NSLog(@"删除失败");
    }
}

#pragma mark ---移除单个数据
- (void)deleleOne:(NSInteger )numer{
 BOOL result = [db executeUpdate:@"DELETE FROM RecommendOneTable WHERE ID = ?",numer];
    
    if (result) {
        
         NSLog(@"删除成功");
    }else{
         NSLog(@"删除失败");
    }
   
}

#pragma mark ---更新数据
- (void)updateRecommendOneTableData:(RecommendModel *)model{


  BOOL result =  [db executeUpdate:@"UPDATE RecommendOneTable SET image_url = ? WHERE html_url = ?;",model.image_url,model.html_url];
    
    if (result) {
        
        NSLog(@"更新成功");
    }else{
        NSLog(@"更新失败");
    }
}


#pragma mark ---关闭数据库
- (void)closeDataBase{
    
    [db close];
}

#pragma mark ---提示用户网络未连接
- (void)alertInternetNotOpen:(UIViewController *)controll{
    NSString *ret = [[NSUserDefaults standardUserDefaults] objectForKey:@"NETStates"];
    if ([ret isEqualToString:@"NO"] ) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"友情提示" message:@"网络连接异常,请检查您的网络!" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:cancelAction];
        [alertController addAction:okAction];
        [controll presentViewController:alertController animated:YES completion:nil];
        
        
    }

}

#pragma mark ----加载视觉效果图
- (void)LoadVisualEffectViews:(UIViewController *)controll{
    UIImageView *blurImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"1423794197595.png"]];
    blurImage.frame = controll.view.frame;
    [controll.view addSubview:blurImage];
    
    UIVisualEffectView *visualView = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight]];
    visualView.frame = controll.view.bounds;
    [blurImage addSubview:visualView];
    [controll.view sendSubviewToBack:blurImage];
    
}
@end
