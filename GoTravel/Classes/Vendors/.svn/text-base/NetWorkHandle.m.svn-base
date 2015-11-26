//
//  NetWorkHandle.m
//  NetWork
//
//  Created by lanou3g on 15/10/5.
//  Copyright (c) 2015年 魏义涛. All rights reserved.
//

#import "NetWorkHandle.h"



@implementation NetWorkHandle

- (void)getDataWithURLString:(NSString *)string
                    compare:(MyBlock)block
{
//    对地址进行UTF-8的转码 防止参数里面有中文
//    NSString *urlString = [string stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:string];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        
        if (nil != data) {
//            因为不确定数据的类型 所以用id 泛型指针 去接收
            id object = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
            block(object);
        }
        
    }];
}
+ (void)getDataWithURLString:(NSString *)string
                    compare:(MyBlock)block
{
    //    对地址进行UTF-8的转码 防止参数里面有中文
//    NSString *urlString = [string stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:string];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        
        if (nil != data) {
            //            因为不确定数据的类型 所以用id 泛型指针 去接收
            id object = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
            block(object);
        }
        
    }];
}
- (void)postDataWithURLString:(NSString *)string andBodyString:(NSString *)bodyString compare:(MyBlock)block
{
    
//    NSString *urlString = [string stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:string];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"POST"];
    
    NSData *data = [bodyString dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPBody:data];
    
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        
        if (nil != data) {
            
            id object = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
            
            block(object);
         }
        
    }];
}
+ (void)postDataWithURLString:(NSString *)string andBodyString:(NSString *)bodyString compare:(MyBlock)block
{
    
//    NSString *urlString = [string stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:string];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"POST"];
    
    NSData *data = [bodyString dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPBody:data];
    
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        
        if (nil != data) {
            
            id object = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
            
            block(object);
        }
        
    }];
}

@end
