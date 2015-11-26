//
//  DataBasehandle.h
//  WJL-Watercress
//
//  Created by 王剑亮 on 15/10/8.
//  Copyright (c) 2015年 wangjianliang. All rights reserved.
//

#import <Foundation/Foundation.h>

#pragma mark---这是本人封装的模型数据库的工具 本工具面向任何的对象模型！！！工具会不定时更新完善QQ：378254160
#pragma mark--- 本工具适合所有的类 模型对象的存储 根据runtime运行时+ sqlite3 + KVC实现的自行添加sqlite3
#pragma mark--- 需要注意 1.modelClass 这个类所有的属性 必须全部是NSString类型的数据！不然无法使用！
#pragma mark--- 需要注意 2.表的内容是根据model类创建的 这个表只能操作对应modelClass类的对象！

@interface DataBasehandle : NSObject

#pragma mark--- 数据库单列的对象 用的时候用单列创建
+(DataBasehandle *) sharedDataBasehandle;

#pragma mark---创建一个表 或者 打开已经创建的表 根据表的名字和运行时的model对象的类 创建一个表！
-(void)createtableName:(NSString *)name Modelclass:(Class)modelClass;

#pragma mark--- 插入一个model 这个model是开始创建表那个modelClass类的对象！
-(void)insertIntoTableModel:(id )model;

#pragma mark--- 删除一个 model 这个model是开始创建表那个modelClass类的对象！
-(void)deleteFromTableModel:(id )model;

#pragma mark--- 取出这个表的所有的model 返回model对象的数组
-(NSMutableArray *)selectAllModel;

#pragma mark--- 更新表中 modelClass 所对应属性的值
#pragma mark--- attributeName：属性的名字 如 @"name"
#pragma mark--- oldname：      属性值没改变之前的值 如 @"张三"
#pragma mark--- newstring：    属性改变之后的值 如 @"李四"
-(void)updateFromAttributeName:(NSString *)attributeName Oldstring:(NSString *)oldname NewString:(NSString *)newstring;

#pragma mark---查找出来 属性值的model数组
#pragma mark--- attributeName：属性的名字 如 @"sex"
#pragma mark--- valueStr：     这个属性对应的值 如 @"男" 那么就会返回 所有@"sex"属性为@"男"的模型数组
-(NSMutableArray *)selectFromAttributeName:(NSString *)attributeName ValueStr:(NSString *)valueStr;

@end
